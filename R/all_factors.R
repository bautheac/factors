#' All factors in one table
#'
#' @description Returns the package's factor datasets in a single long-format
#'   table. Currently only the Stambaugh source is available.
#'
#' @param sources Source names to include. Currently only `"stambaugh"`
#'   (the default) is supported.
#'
#' @return A \linkS4class{data.table} with columns `source`, `region`,
#'   `frequency`, `factor`, `period` and `value`, in that order.
#'
#' @details Stambaugh rows are labelled `region = "US"`; this assumes both
#'   Stambaugh papers use US stocks, an assumption that is unverified.
#'
#' @importFrom data.table data.table
#'
#' @export
all_factors <- function(sources = "stambaugh") {
  sources <- match.arg(sources, "stambaugh")

  env <- new.env(parent = emptyenv())
  data("stambaugh", package = "factors", envir = env)
  st <- env$stambaugh

  data.table(
    source = "Stambaugh",
    region = "US",
    frequency = st$frequency,
    factor = st$factor,
    period = st$period,
    value = st$value
  )
}
