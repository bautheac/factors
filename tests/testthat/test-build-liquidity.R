# Build tests for the Pastor-Stambaugh liquidity series (#9).
# The fixture is a verbatim trim of liq_data_1962_2025.txt (CRLF, tabs and the
# ragged trailing tab included). Expected rows are hand-listed from the
# fixture: column 1 = period, column 3 = non-traded liquidity factor,
# column 4 = traded liquidity factor; column 2 (aggregate liquidity level) is
# ignored. The traded column's -99 sentinel (196708-196712) must become NA
# and those rows must be dropped.

test_that("build_liquidity returns exactly the hand-listed fixture rows", {
  lines <- lines_from_path(test_path("fixtures", "liquidity.txt"))

  res <- build_liquidity(lines)

  expect_s3_class(res, "data.table")
  expect_identical(names(res), c("frequency", "factor", "period", "value"))
  expect_type(res$period, "character")
  expect_type(res$value, "double")

  expected <- data.table::data.table(
    frequency = "month",
    factor = c(rep("non-traded liquidity", 10L), rep("traded liquidity", 5L)),
    period = c(
      "196708", "196709", "196710", "196711", "196712",
      "196801", "196802", "196803", "196804", "196805",
      "196801", "196802", "196803", "196804", "196805"
    ),
    value = c(
      # Non-traded liquidity (column 3), 196708-196805.
      0.07046546, 0.03128358, -0.04273159, -0.01380812, 0.03347359,
      0.00277601, -0.02540306, -0.08725577, 0.08557644, 0.01335513,
      # Traded liquidity (column 4), 196801-196805 only.
      -0.02725374, 0.02387298, 0.00783476, 0.00450124, -0.01657204
    )
  )

  # Row order is not part of the contract; compare both sides sorted.
  data.table::setorderv(res, c("factor", "period"))
  data.table::setorderv(expected, c("factor", "period"))
  expect_identical(res, expected)
})

test_that("build_liquidity drops the -99 sentinel traded rows", {
  lines <- lines_from_path(test_path("fixtures", "liquidity.txt"))

  res <- build_liquidity(lines)

  # 10 non-traded rows (196708-196805) + 5 traded rows (196801-196805).
  expect_identical(nrow(res), 15L)
  expect_false(-99 %in% res$value)
  expect_false(anyNA(res$value))

  traded <- res[res$factor == "traded liquidity"]
  expect_identical(nrow(traded), 5L)
  expect_setequal(traded$period, c("196801", "196802", "196803", "196804", "196805"))

  non_traded <- res[res$factor == "non-traded liquidity"]
  expect_identical(nrow(non_traded), 10L)
})
