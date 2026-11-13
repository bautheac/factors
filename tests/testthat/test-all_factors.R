test_that("all_factors() returns a data.table with the contract columns in order", {
  res <- all_factors()

  expect_s3_class(res, "data.table")
  expect_identical(
    names(res),
    c("source", "region", "frequency", "factor", "period", "value")
  )
  expect_identical(
    vapply(res, typeof, character(1)),
    c(source = "character", region = "character", frequency = "character",
      factor = "character", period = "character", value = "double")
  )
})

test_that("all_factors() returns both sources, French rows first", {
  res <- all_factors()

  expect_identical(unique(res$source), c("French", "Stambaugh"))
  expect_identical(all_factors(c("stambaugh", "french")), res)
})

test_that("all_factors('french') returns only French rows, values unchanged", {
  env <- new.env(parent = emptyenv())
  data("fama_french", package = "factors", envir = env)
  shipped <- env$fama_french

  res <- all_factors("french")

  expect_identical(unique(res$source), "French")
  expect_identical(nrow(res), nrow(shipped))
  expect_identical(res$region, as.character(shipped$region))
  expect_identical(res$frequency, as.character(shipped$frequency))
  expect_identical(res$factor, shipped$factor)
  expect_identical(res$period, shipped$period)
  expect_identical(res$value, shipped$value)
})

test_that("all_factors() keeps every shipped row from both sources, French block first", {
  env <- new.env(parent = emptyenv())
  data("fama_french", package = "factors", envir = env)
  data("stambaugh", package = "factors", envir = env)
  ff <- env$fama_french
  st <- env$stambaugh

  res <- all_factors()

  expect_identical(nrow(res), nrow(ff) + nrow(st))
  expect_identical(
    res$source,
    rep(c("French", "Stambaugh"), c(nrow(ff), nrow(st)))
  )

  fr <- res[seq_len(nrow(ff))]
  expect_identical(fr$region, as.character(ff$region))
  expect_identical(fr$frequency, as.character(ff$frequency))
  expect_identical(fr$factor, ff$factor)
  expect_identical(fr$period, ff$period)
  expect_identical(fr$value, ff$value)

  sb <- res[nrow(ff) + seq_len(nrow(st))]
  expect_identical(sb$region, rep("US", nrow(st)))
  expect_identical(sb$frequency, st$frequency)
  expect_identical(sb$factor, st$factor)
  expect_identical(sb$period, as.character(st$period))
  expect_identical(sb$value, st$value)
})

test_that("every row is labelled source Stambaugh and region US", {
  res <- all_factors("stambaugh")

  expect_identical(unique(res$source), "Stambaugh")
  expect_identical(unique(res$region), "US")
  expect_false(anyNA(res$source))
  expect_false(anyNA(res$region))
})

test_that("all_factors('stambaugh') keeps every shipped row, unchanged", {
  env <- new.env(parent = emptyenv())
  data("stambaugh", package = "factors", envir = env)
  shipped <- env$stambaugh

  res <- all_factors("stambaugh")

  expect_identical(nrow(res), nrow(shipped))
  expect_identical(res$frequency, shipped$frequency)
  expect_identical(res$factor, shipped$factor)
  expect_identical(res$period, shipped$period)
  expect_identical(res$value, shipped$value)
})

test_that("an unknown source errors, naming the bad value and the allowed values", {
  expect_error(all_factors("bogus"), "bogus")
  expect_error(all_factors("bogus"), "french")
  expect_error(all_factors("bogus"), "stambaugh")
  expect_error(all_factors(c("french", "typo")), "typo")
})

test_that("all_factors() has no duplicate keys", {
  res <- all_factors()

  expect_identical(
    anyDuplicated(res, by = c("source", "region", "frequency", "factor", "period")),
    0L
  )
})

test_that("all_factors() works with FFresearch not installed", {
  skip_on_cran()

  # Library path holding every installed package except FFresearch.
  lib <- tempfile("no-ffresearch-lib-")
  dir.create(lib)
  for (p in list.dirs(.libPaths(), recursive = FALSE)) {
    nm <- basename(p)
    if (nm != "FFresearch" && !dir.exists(file.path(lib, nm))) {
      file.symlink(p, file.path(lib, nm))
    }
  }

  root <- normalizePath(test_path("..", ".."))
  script <- tempfile(fileext = ".R")
  writeLines(c(
    sprintf(".libPaths(c(%s, .Library), include.site = FALSE)", deparse(lib)),
    'stopifnot(!requireNamespace("FFresearch", quietly = TRUE))',
    sprintf("pkgload::load_all(%s, quiet = TRUE)", deparse(root)),
    'res <- all_factors()',
    'stopifnot(data.table::is.data.table(res), identical(unique(res$source), c("French", "Stambaugh")))',
    'fr <- all_factors("french")',
    'stopifnot(identical(unique(fr$source), "French"), nrow(fr) > 0L)',
    'st <- all_factors("stambaugh")',
    'stopifnot(identical(unique(st$source), "Stambaugh"), nrow(st) > 0L)',
    'cat("ALL_FACTORS_OK\n")'
  ), script)

  out <- system2(
    file.path(R.home("bin"), "Rscript"), shQuote(script),
    stdout = TRUE, stderr = TRUE
  )

  expect_null(attr(out, "status"))
  expect_true("ALL_FACTORS_OK" %in% out)
})
