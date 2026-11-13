# Build tests for the Stambaugh-Yuan mispricing series (#10).
# Fixtures are verbatim trims of M4.csv / M4d.csv (header + 10 data rows).
# Expected rows are hand-listed from the fixture content; market values are
# MKTRF + RF worked out by hand from the fixture's decimal numbers.

# Order-independent row comparison: sort both sides by (period, factor).
by_period_factor <- function(x) x[order(x$period, x$factor)]

# The single value for one factor in one period.
value_at <- function(x, factor, period) {
  x$value[x$factor == factor & x$period == period]
}

test_that("build_mispricing returns the exact monthly rows from the fixture", {
  lines <- lines_from_path(test_path("fixtures", "mispricing_month.csv"))

  result <- build_mispricing(lines, frequency = "month")

  expect_s3_class(result, "data.table")
  expect_identical(names(result), c("frequency", "factor", "period", "value"))
  expect_identical(nrow(result), 50L)
  expect_type(result$frequency, "character")
  expect_type(result$factor, "character")
  expect_type(result$period, "character")
  expect_type(result$value, "double")
  expect_identical(unique(result$frequency), "month")
  expect_identical(
    sort(unique(result$factor)),
    sort(c("size", "management", "performance", "risk free rate", "market"))
  )

  expected <- data.table::data.table(
    frequency = "month",
    factor = rep(
      c("size", "management", "performance", "risk free rate", "market"),
      10L
    ),
    period = rep(
      c("196301", "196302", "196303", "196304", "196305",
        "196306", "196307", "196308", "196309", "196310"),
      each = 5L
    ),
    value = c(
      # 196301: market = 0.049300 + 0.00250 = 0.051800
      0.024818199, 0.0213493902, -0.02275123, 0.00250, 0.0518,
      # 196302: market = -0.023800 + 0.00230 = -0.021500
      0.0180957537, 0.0109613701, 0.000873805, 0.00230, -0.0215,
      # 196303: market = 0.030800 + 0.00230 = 0.033100
      -0.008183017, 0.0058899084, 0.0232814338, 0.00230, 0.0331,
      # 196304: market = 0.045100 + 0.00250 = 0.047600
      -0.037327651, 0.0001900053, 0.0050770119, 0.00250, 0.0476,
      # 196305: market = 0.017600 + 0.00240 = 0.020000
      0.0215184543, 0.0175932042, 0.0028483846, 0.00240, 0.02,
      # 196306: market = -0.020000 + 0.00230 = -0.017700
      0.0009943648, -0.02386818, -0.001521306, 0.00230, -0.0177,
      # 196307: market = -0.003900 + 0.00270 = -0.001200
      -0.020503863, -0.017134513, -0.013391583, 0.00270, -0.0012,
      # 196308: market = 0.050700 + 0.00250 = 0.053200
      -0.002230629, 0.0041486202, 0.0209280905, 0.00250, 0.0532,
      # 196309: market = -0.015700 + 0.00270 = -0.013000
      -0.008812091, 0.008398419, 0.00839391, 0.00270, -0.013,
      # 196310: market = 0.025300 + 0.00290 = 0.028200
      -0.00395755, -0.003751353, 0.0472126459, 0.00290, 0.0282
    )
  )

  expect_equal(by_period_factor(result), by_period_factor(expected))
})

test_that("build_mispricing returns the exact daily rows from the fixture", {
  lines <- lines_from_path(test_path("fixtures", "mispricing_daily.csv"))

  result <- build_mispricing(lines, frequency = "day")

  expect_s3_class(result, "data.table")
  expect_identical(names(result), c("frequency", "factor", "period", "value"))
  expect_identical(nrow(result), 50L)
  expect_type(result$frequency, "character")
  expect_type(result$factor, "character")
  expect_type(result$period, "character")
  expect_type(result$value, "double")
  expect_identical(unique(result$frequency), "day")
  expect_identical(
    sort(unique(result$factor)),
    sort(c("size", "management", "performance", "risk free rate", "market"))
  )

  expected <- data.table::data.table(
    frequency = "day",
    factor = rep(
      c("size", "management", "performance", "risk free rate", "market"),
      10L
    ),
    period = rep(
      c("19630102", "19630103", "19630104", "19630107", "19630108",
        "19630109", "19630110", "19630111", "19630114", "19630115"),
      each = 5L
    ),
    value = c(
      # 19630102: market = -0.005400 + 0.00011 = -0.005290
      0.0093755891, 0.0061762024, -0.007267985, 0.00011, -0.00529,
      # 19630103: market = 0.016600 + 0.00011 = 0.016710
      0.0053450927, 0.0049818483, -0.021465573, 0.00011, 0.01671,
      # 19630104: market = 0.006800 + 0.00011 = 0.006910
      -0.005395758, 0.0033103892, -0.006416354, 0.00011, 0.00691,
      # 19630107: market = 0.000600 + 0.00011 = 0.000710
      0.0051170448, 0.0048454586, -0.000347014, 0.00011, 0.00071,
      # 19630108: market = 0.009000 + 0.00011 = 0.009110
      -0.000346261, 0.0006779304, 0.0020791184, 0.00011, 0.00911,
      # 19630109: market = -0.001600 + 0.00011 = -0.001490
      0.005832405, 0.0023819824, 0.0080242057, 0.00011, -0.00149,
      # 19630110: market = 0.001900 + 0.00011 = 0.002010
      -0.002576116, 0.0043698968, -0.003556165, 0.00011, 0.00201,
      # 19630111: market = 0.002500 + 0.00011 = 0.002610
      0.0012711552, 0.0009406539, 0.0006613416, 0.00011, 0.00261,
      # 19630114: market = 0.005700 + 0.00011 = 0.005810
      -0.001007994, -0.003332295, -0.008522128, 0.00011, 0.00581,
      # 19630115: market = -0.001000 + 0.00011 = -0.000890
      0.0035915555, 0.0005799282, 0.0052992626, 0.00011, -0.00089
    )
  )

  expect_equal(by_period_factor(result), by_period_factor(expected))
})

test_that("market equals MKTRF + RF, with the numbers written out", {
  month <- build_mispricing(
    lines_from_path(test_path("fixtures", "mispricing_month.csv")),
    frequency = "month"
  )
  day <- build_mispricing(
    lines_from_path(test_path("fixtures", "mispricing_daily.csv")),
    frequency = "day"
  )

  # Monthly 196301: MKTRF = 0.049300, RF = 0.00250 -> market = 0.051800
  expect_equal(value_at(month, "market", "196301"), 0.051800)
  expect_equal(value_at(month, "risk free rate", "196301"), 0.00250)
  # Monthly 196310: MKTRF = 0.025300, RF = 0.00290 -> market = 0.028200
  expect_equal(value_at(month, "market", "196310"), 0.028200)
  expect_equal(value_at(month, "risk free rate", "196310"), 0.00290)
  # Daily 19630102: MKTRF = -0.005400, RF = 0.00011 -> market = -0.005290
  expect_equal(value_at(day, "market", "19630102"), -0.005290)
  expect_equal(value_at(day, "risk free rate", "19630102"), 0.00011)
  # Daily 19630115: MKTRF = -0.001000, RF = 0.00011 -> market = -0.000890
  expect_equal(value_at(day, "market", "19630115"), -0.000890)
  expect_equal(value_at(day, "risk free rate", "19630115"), 0.00011)
})

test_that("sentinel values become NA and their rows are dropped", {
  lines <- lines_from_path(test_path("fixtures", "mispricing_month.csv"))
  # Synthetic rows with sentinels injected into real M4.csv rows:
  # 196311: SMB = -99; 196312: PERF = -99.99; 196401: RF = -99.
  lines <- c(
    lines,
    "196311,-0.008500,-99,-0.014158352,-0.020970503,0.00270",
    "196312,0.018300,-0.020187271,0.0086580404,-99.99,0.00290",
    "196401,0.022400,0.0072109217,0.0059015435,0.0362689535,-99"
  )

  result <- build_mispricing(lines, frequency = "month")

  # Only the NA-valued long rows are dropped, not the whole period:
  # 50 fixture rows + 4 (196311) + 4 (196312) + 3 (196401).
  expect_identical(nrow(result), 61L)
  expect_false(anyNA(result$value))
  expect_false(any(result$value %in% c(-99, -99.99)))

  # The sentinel factor rows are gone.
  expect_length(value_at(result, "size", "196311"), 0L)
  expect_length(value_at(result, "performance", "196312"), 0L)
  expect_length(value_at(result, "risk free rate", "196401"), 0L)
  # A sentinel RF also takes market down with it (MKTRF + NA = NA).
  expect_length(value_at(result, "market", "196401"), 0L)

  # The remaining factors of those periods keep their exact values.
  # 196311: market = -0.008500 + 0.00270 = -0.005800
  expect_equal(value_at(result, "management", "196311"), -0.014158352)
  expect_equal(value_at(result, "performance", "196311"), -0.020970503)
  expect_equal(value_at(result, "risk free rate", "196311"), 0.00270)
  expect_equal(value_at(result, "market", "196311"), -0.0058)
  # 196312: market = 0.018300 + 0.00290 = 0.021200
  expect_equal(value_at(result, "size", "196312"), -0.020187271)
  expect_equal(value_at(result, "management", "196312"), 0.0086580404)
  expect_equal(value_at(result, "risk free rate", "196312"), 0.00290)
  expect_equal(value_at(result, "market", "196312"), 0.0212)
  # 196401: size, management and performance survive.
  expect_equal(value_at(result, "size", "196401"), 0.0072109217)
  expect_equal(value_at(result, "management", "196401"), 0.0059015435)
  expect_equal(value_at(result, "performance", "196401"), 0.0362689535)
})

test_that("an invalid frequency errors with a clear message", {
  lines <- lines_from_path(test_path("fixtures", "mispricing_month.csv"))

  expect_error(build_mispricing(lines, "week"), "frequency must be")
  expect_error(build_mispricing(lines, ""), "frequency must be")
  expect_error(build_mispricing(lines, NA_character_), "frequency must be")
  expect_error(build_mispricing(lines, 1), "frequency must be")
  expect_error(build_mispricing(lines, c("day", "month")), "frequency must be")
})
