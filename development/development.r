source(file = "development/new.r")
data.table::.__C__data.table
usethis::use_tibble()
devtools::document()
pkgdown::build_site()

usethis::use_data_raw()


data("factors")
data("breakpoints")
data("portfolios_univariate")
data("portfolios_bivariate")
data("portfolios trivariate")
data("portfolios industries")
data("variables")

portfolios_bivariate
dplyr::distinct(portfolios_univariate, field)

library(factors)
data("Stambaugh et al")
