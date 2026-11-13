test_that("shipped datasets load as non-empty data.tables", {
  data("fama_french", package = "factors", envir = environment())
  data("stambaugh", package = "factors", envir = environment())

  expect_s3_class(fama_french, "data.table")
  expect_gt(nrow(fama_french), 0L)

  expect_s3_class(stambaugh, "data.table")
  expect_gt(nrow(stambaugh), 0L)
})
