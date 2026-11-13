# Rebuild data/stambaugh.rda from Stambaugh's published source files.
# Run from the package root: Rscript development/rebuild_stambaugh.R
# Download URLs are scraped from the index page (the old ~stambaug file URLs
# are dead) and the liquidity file name is discovered, not hard-coded.
# Downloads are cached in git-ignored data-raw/cache/; a cached file is not
# downloaded again, so a rebuild does not refetch unchanged files. To force
# re-downloads, run with --force (Rscript development/rebuild_stambaugh.R
# --force); deleting data-raw/cache/ also forces re-download.

pkgload::load_all(quiet = TRUE)

force <- "--force" %in% commandArgs(trailingOnly = TRUE)

cache_dir <- "data-raw/cache"
dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

index_lines <- lines_from_url("http://finance.wharton.upenn.edu/~stambaug/")
liquidity_name <- discover_liquidity_file(index_lines)

# Absolute hrefs from the index page; never reconstruct ~stambaug URLs.
hrefs <- unlist(regmatches(
  index_lines,
  gregexpr('(?<=href=")[^"]+', index_lines, perl = TRUE)
))
pick_url <- function(name) {
  url <- hrefs[endsWith(hrefs, paste0("/", name))]
  if (length(url) != 1L) {
    stop("Expected exactly one index page href for '", name, "', found ", length(url), ".", call. = FALSE)
  }
  url
}

fetch_cached <- function(url, force = FALSE) {
  path <- file.path(cache_dir, basename(url))
  if (!force && file.exists(path)) {
    cat("Cache hit:", path, "\n")
  } else {
    cat("Downloading", url, "\n")
    download.file(url, path, mode = "wb", quiet = TRUE)
  }
  path
}

liquidity <- build_liquidity(lines_from_path(fetch_cached(pick_url(liquidity_name), force)))
month <- build_mispricing(lines_from_path(fetch_cached(pick_url("M4.csv"), force)), "month")
day <- build_mispricing(lines_from_path(fetch_cached(pick_url("M4d.csv"), force)), "day")

stambaugh <- data.table::rbindlist(list(liquidity, month, day))

save(stambaugh, file = "data/stambaugh.rda", compress = "bzip2")
cat("Saved", nrow(stambaugh), "rows to data/stambaugh.rda\n")
