#' Build the Stambaugh-Yuan mispricing factor series
#'
#' @description Parses the lines of a Stambaugh-Yuan mispricing file (M4.csv
#'   for monthly, M4d.csv for daily) into the tidy long format. The lines are
#'   injected by the caller, e.g. from [lines_from_path()] or
#'   [lines_from_url()]; this function never opens files or URLs itself.
#'
#' @param lines Character vector of file lines: one header line
#'   (`YYYYMM,MKTRF,SMB,MGMT,PERF,RF` or `DATE,MKTRF,SMB,MGMT,PERF,RF`)
#'   followed by comma-separated data rows.
#' @param frequency Either `"day"` or `"month"`.
#'
#' @return A \linkS4class{data.table} with columns `frequency`, `factor`,
#'   `period` and `value`, in that order. Factors are `size` (SMB),
#'   `management` (MGMT), `performance` (PERF), `risk free rate` (RF) and
#'   `market` (MKTRF + RF). `period` is character (`YYYYMM` or `YYYYMMDD`),
#'   `value` is numeric. Missing-value sentinels (`-99`, `-99.99`) become
#'   `NA` and those rows are dropped.
#'
#' @keywords internal
build_mispricing <- function(lines, frequency) {
  if (!is.character(frequency) || length(frequency) != 1L ||
      !frequency %in% c("day", "month")) {
    stop('frequency must be "day" or "month"', call. = FALSE)
  }

  wide <- data.table::fread(
    text = paste(lines, collapse = "\n"),
    colClasses = c("character", rep("numeric", 5L))
  )
  # Column order is fixed in both files: period, MKTRF, SMB, MGMT, PERF, RF.
  # The period column is named YYYYMM (monthly) or DATE (daily).
  data.table::setnames(wide, c("period", "MKTRF", "SMB", "MGMT", "PERF", "RF"))

  for (col in c("MKTRF", "SMB", "MGMT", "PERF", "RF")) {
    data.table::set(
      wide,
      i = which(wide[[col]] %in% c(-99, -99.99)),
      j = col,
      value = NA_real_
    )
  }

  wide[["market"]] <- wide[["MKTRF"]] + wide[["RF"]]
  wide[["MKTRF"]] <- NULL
  data.table::setnames(
    wide,
    c("SMB", "MGMT", "PERF", "RF"),
    c("size", "management", "performance", "risk free rate")
  )

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
