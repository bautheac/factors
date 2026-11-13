test_that("all_factors('stambaugh') returns a data.table with the contract columns in order", {
  res <- all_factors("stambaugh")

  expect_s3_class(res, "data.table")
  expect_identical(
    names(res),
    c("source", "region", "frequency", "factor", "period", "value")
  )
})

test_that("all_factors() defaults to the Stambaugh source", {
  expect_identical(all_factors(), all_factors("stambaugh"))
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

test_that("all_factors('stambaugh') works with FFresearch not installed", {
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
    'res <- all_factors("stambaugh")',
    'stopifnot(data.table::is.data.table(res), nrow(res) > 0L)',
    'cat("ALL_FACTORS_OK\n")'
  ), script)

  out <- system2(
    file.path(R.home("bin"), "Rscript"), shQuote(script),
    stdout = TRUE, stderr = TRUE
  )

  expect_null(attr(out, "status"))
  expect_true("ALL_FACTORS_OK" %in% out)
})
