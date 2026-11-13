# Contract tests for the shipped stambaugh dataset (#3).
# Pin the exact shape of data/stambaugh.rda so a rebuild cannot silently
# change it. The contract comes from spec #1, seam 1 (shipped-data contract).

test_that("stambaugh columns are exactly frequency, factor, period, value, in order", {
  data("stambaugh", package = "factors", envir = environment())

  expect_identical(names(stambaugh), c("frequency", "factor", "period", "value"))
})

test_that("stambaugh frequency, factor and period are character, value is numeric", {
  data("stambaugh", package = "factors", envir = environment())

  expect_type(stambaugh$frequency, "character")
  expect_type(stambaugh$factor, "character")
  expect_type(stambaugh$period, "character")
  expect_true(is.numeric(stambaugh$value))
})

test_that("stambaugh has no duplicate (frequency, factor, period) keys", {
  data("stambaugh", package = "factors", envir = environment())

  expect_identical(anyDuplicated(stambaugh, by = c("frequency", "factor", "period")), 0L)
})

test_that("stambaugh value has no NA", {
  data("stambaugh", package = "factors", envir = environment())

  expect_false(anyNA(stambaugh$value))
})

test_that("stambaugh frequency only contains day or month", {
  data("stambaugh", package = "factors", envir = environment())

  expect_true(all(stambaugh$frequency %in% c("day", "month")))
})
