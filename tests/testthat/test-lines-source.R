# Lines-source tests (#8).
# Fixtures are verbatim trims of the real Stambaugh files (CRLF, tabs and the
# ragged trailing tab included). Expected lines are hand-written from the
# fixture content; readLines() strips the CRLF, so none appears below.

test_that("lines_from_path returns the exact lines of the liquidity fixture", {
  lines <- lines_from_path(test_path("fixtures", "liquidity.txt"))

  # 11 '%' header lines + 10 data rows, 196708-196805: five -99 sentinel rows
  # (four fields) followed by five real traded rows (trailing tab).
  expect_length(lines, 21L)
  expect_identical(
    lines[[1]],
    "% LIQUIDITY FACTORS OF PASTOR AND STAMBAUGH (JPE 2003) UPDATED THROUGH DEC 2025"
  )
  expect_identical(
    lines[[21]],
    "196805\t -0.02061336\t  0.01335513\t -0.01657204\t"
  )
})

test_that("lines_from_path returns the exact lines of the monthly mispricing fixture", {
  lines <- lines_from_path(test_path("fixtures", "mispricing_month.csv"))

  # Header + 10 data rows, 196301-196310.
  expect_length(lines, 11L)
  expect_identical(lines[[1]], "YYYYMM,MKTRF,SMB,MGMT,PERF,RF")
  expect_identical(
    lines[[11]],
    "196310,0.025300,-0.00395755,-0.003751353,0.0472126459,0.00290"
  )
})

test_that("lines_from_path returns the exact lines of the daily mispricing fixture", {
  lines <- lines_from_path(test_path("fixtures", "mispricing_daily.csv"))

  # Header + 10 data rows, 19630102-19630115.
  expect_length(lines, 11L)
  expect_identical(lines[[1]], "DATE,MKTRF,SMB,MGMT,PERF,RF")
  expect_identical(
    lines[[11]],
    "19630115,-0.001000,0.0035915555,0.0005799282,0.0052992626,0.00011"
  )
})
