# Liquidity file discovery tests (#11).
# The index fixture is a verbatim copy of Stambaugh's profile page (2026-11-13);
# its Data section links liq_data_1962_2025.txt. Expected names are taken from
# the page itself, not recomputed from the discovery pattern.

test_that("discover_liquidity_file finds the current liquidity file in the index fixture", {
  lines <- lines_from_path(test_path("fixtures", "stambaugh_index.html"))

  expect_identical(discover_liquidity_file(lines), "liq_data_1962_2025.txt")
})

test_that("discover_liquidity_file picks the latest end year when several files match", {
  lines <- c(
    '<li><a href="https://faculty.wharton.upenn.edu/wp-content/uploads/2016/11/liq_data_1962_2020.txt">old liquidity series</a></li>',
    '<li><a href="https://faculty.wharton.upenn.edu/wp-content/uploads/2016/11/liq_data_1962_2025.txt">Pastor-Stambaugh liquidity series</a></li>'
  )

  expect_identical(discover_liquidity_file(lines), "liq_data_1962_2025.txt")
})

test_that("discover_liquidity_file errors clearly when no file matches", {
  expect_error(
    discover_liquidity_file(c("<html>", "<body>no data links here</body>", "</html>")),
    "No liquidity data file matching"
  )
  expect_error(discover_liquidity_file(character(0)), "No liquidity data file matching")
})

test_that("discover_liquidity_file finds files whose start year is not 1962", {
  lines <- '<li><a href="https://faculty.wharton.upenn.edu/wp-content/uploads/2026/11/liq_data_1963_2030.txt">liquidity series</a></li>'

  expect_identical(discover_liquidity_file(lines), "liq_data_1963_2030.txt")
})

test_that("discover_liquidity_file picks the latest end year across start years", {
  lines <- c(
    '<a href="https://faculty.wharton.upenn.edu/wp-content/uploads/2016/11/liq_data_1962_2025.txt">current</a>',
    '<a href="https://faculty.wharton.upenn.edu/wp-content/uploads/2026/11/liq_data_1926_2030.txt">extended</a>'
  )

  expect_identical(discover_liquidity_file(lines), "liq_data_1926_2030.txt")
})
