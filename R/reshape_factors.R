#' Reshape a wide Stambaugh factor table to the tidy long contract
#'
#' @description Shared reshape tail of the Stambaugh build functions: melt a
#'   wide table with a `period` column and one column per factor into the long
#'   format, drop missing values, and label the frequency. Missing-value
#'   sentinels must already be `NA` in `wide` before calling this.
#'
#' @param wide A data.table with a character `period` column and one numeric
#'   column per factor.
#' @param frequency Either `"day"` or `"month"`.
#'
#' @return A \link[data.table:data.table-class]{data.table} with columns
#'   `frequency`, `factor`, `period` and `value`, in that order.
#'
#' @keywords internal
#' @noRd
reshape_factors <- function(wide, frequency) {
  long <- data.table::melt(
    wide,
    id.vars = "period",
    variable.name = "factor",
    value.name = "value",
    variable.factor = FALSE
  )
  long <- long[!is.na(long[["value"]])]
  long[["frequency"]] <- frequency
  data.table::setcolorder(long, c("frequency", "factor", "period", "value"))
  long
}