#' Build the Pastor-Stambaugh liquidity series
#'
#' @description Parses the lines of Stambaugh's liquidity file into the tidy
#'   long table for the two liquidity factors. Receives lines from an
#'   injectable source (lines_from_path() or lines_from_url()); never opens
#'   files or URLs itself.
#'
#' @param lines Character vector of lines from the liquidity file: a `%`
#'   comment header followed by tab-separated data rows (period, aggregate
#'   liquidity level, non-traded liquidity factor, traded liquidity factor).
#'   Rows may carry a trailing tab.
#'
#' @return A \linkS4class{data.table} with columns `frequency`, `factor`,
#'   `period` and `value`, in that order. `frequency` is `"month"`, `factor`
#'   is `"non-traded liquidity"` or `"traded liquidity"`, `period` is the
#'   source `YYYYMM` string and `value` is numeric. Values equal to the `-99`
#'   missing sentinel become `NA` and those rows are dropped. The aggregate
#'   liquidity level (column 2) is not used.
#'
#' @keywords internal
build_liquidity <- function(lines) {
  lines <- lines[!startsWith(lines, "%")]
  fields <- strsplit(lines, "\t", fixed = TRUE)

  wide <- data.table::data.table(
    period = trimws(vapply(fields, `[[`, character(1), 1L)),
    `non-traded liquidity` = as.numeric(vapply(fields, `[[`, character(1), 3L)),
    `traded liquidity` = as.numeric(vapply(fields, `[[`, character(1), 4L))
  )

  long <- data.table::melt(
    wide,
    id.vars = "period",
    variable.name = "factor",
    value.name = "value",
    variable.factor = FALSE
  )

  sentinel <- !is.na(long$value) & long$value == -99
  long$value[sentinel] <- NA_real_
  long <- long[!is.na(long$value)]

  long$frequency <- "month"
  data.table::setcolorder(long, c("frequency", "factor", "period", "value"))
  long
}
