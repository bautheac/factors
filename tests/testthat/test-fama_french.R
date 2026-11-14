test_that("fama_french has the exact columns and types", {
  data("fama_french", package = "factors", envir = environment())

  expect_s3_class(fama_french, "data.table")
  expect_identical(names(fama_french), c("region", "frequency", "factor", "period", "value"))
  expect_s3_class(fama_french$region, "factor")
  expect_s3_class(fama_french$frequency, "factor")
  expect_type(fama_french$factor, "character")
  expect_type(fama_french$period, "character")
  expect_type(fama_french$value, "double")
  expect_true(all(levels(fama_french$frequency) %in% c("day", "month", "year")))
})

test_that("fama_french carries the current region labels, not global", {
  data("fama_french", package = "factors", envir = environment())

  expect_setequal(
    levels(fama_french$region),
    c("US", "developed", "developed (ex US)", "Europe", "JP",
      "Asia-Pacific (ex JP)", "North America")
  )
})

test_that("US monthly history runs from 1971 through at least 2026-09", {
  data("fama_french", package = "factors", envir = environment())

  # FFresearch trims every series to a 1971 coverage start (spec #3 follow-up,
  # 2026-11-14); the snapshot inherits it.
  periods <- fama_french[region == "US" & frequency == "month", period]
  expect_gt(length(periods), 0L)
  expect_identical(min(periods), "197101")
  expect_gte(max(periods), "202609")
})

test_that("no snapshot row predates the 1971 coverage start", {
  data("fama_french", package = "factors", envir = environment())

  years <- as.integer(substring(fama_french$period, 1, 4))
  expect_gte(min(years), 1971L)
})

test_that("fama_french has no duplicate keys", {
  data("fama_french", package = "factors", envir = environment())

  expect_identical(
    anyDuplicated(fama_french, by = c("region", "frequency", "factor", "period")),
    0L
  )
})

test_that("fama_french value has no NA", {
  data("fama_french", package = "factors", envir = environment())

  expect_false(anyNA(fama_french$value))
})

test_that("fama_french records the FFresearch version used for the snapshot", {
  data("fama_french", package = "factors", envir = environment())

  version <- attr(fama_french, "ffresearch_version")
  expect_type(version, "character")
  expect_length(version, 1L)
  expect_false(is.na(version))
  expect_match(version, "^[0-9]+(\\.[0-9]+)+$")
})
