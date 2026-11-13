test_that("fama_french is in sync with the installed FFresearch::factors", {
  skip_if_not_installed("FFresearch")

  data("fama_french", package = "factors", envir = environment())
  reference <- FFresearch::factors

  cols <- c("region", "frequency", "factor", "period", "value")
  rerun <- paste(
    "Shipped fama_french differs from FFresearch::factors.",
    "Rerun development/rebuild_fama_french.R to refresh the snapshot."
  )

  expect_true(all(cols %in% names(reference)), info = rerun)

  # Compare the data columns only, in a canonical row order: data.table
  # .internal.selfref pointers differ after save/load, and factor columns
  # are compared as character so level order cannot cause false failures.
  canonical <- function(d) {
    d <- as.data.frame(d)[, cols, drop = FALSE]
    d$region <- as.character(d$region)
    d$frequency <- as.character(d$frequency)
    d <- d[do.call(order, d), , drop = FALSE]
    rownames(d) <- NULL
    d
  }

  shipped <- canonical(fama_french)
  expected <- canonical(reference)

  expect_equal(nrow(shipped), nrow(expected), info = rerun)
  expect_equal(shipped, expected, info = rerun)
})
