#' Discover the current liquidity data file name
#'
#' @description Finds the Pastor-Stambaugh liquidity data file name in the lines
#'   of Stambaugh's index page. The year range in the file name goes stale, so
#'   the build discovers it from the page instead of hard-coding it. Only parses
#'   the given lines; never opens files or URLs.
#'
#' @param index_lines Character vector of lines from the index page, as returned
#'   by [lines_from_path()] or [lines_from_url()].
#'
#' @return The liquidity data file name (basename), e.g.
#'   `"liq_data_1962_2025.txt"`. If several file names match, the one with the
#'   latest end year is returned. Errors if no file name matches.
#'
#' @keywords internal
discover_liquidity_file <- function(index_lines) {
  pattern <- "liq_data_1962_(\\d{4})\\.txt"
  matches <- unlist(regmatches(index_lines, gregexpr(pattern, index_lines)))
  if (length(matches) == 0L) {
    stop(
      "No liquidity data file matching 'liq_data_1962_<year>.txt' found in the index page lines.",
      call. = FALSE
    )
  }
  end_years <- as.integer(sub(pattern, "\\1", matches))
  matches[[which.max(end_years)]]
}
