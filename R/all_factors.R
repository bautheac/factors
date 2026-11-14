#' All factors in one table
#'
#' @description Returns the package's factor datasets in a single long-format
#'   table.
#'
#' @param sources Character vector of source names to include: `"french"`
#'   (the shipped \link{fama_french} dataset) and/or `"stambaugh"` (the shipped
#'   \link{stambaugh} dataset). Defaults to both. An unknown source name is an
#'   error.
#'
#' @return A \link[data.table:data.table-class]{data.table} with columns `source`, `region`,
#'   `frequency`, `factor`, `period` and `value`, in that order. `source` is
#'   `"French"` or `"Stambaugh"`. French rows come first, then Stambaugh,
#'   regardless of the order of `sources`. All columns are character except
#'   `value` (numeric); `fama_french`'s factor columns are coerced to
#'   character.
#'
#' @details Stambaugh rows are labelled `region = "US"`: both Stambaugh papers
#'   build their factors from US stocks (ordinary common shares on
#'   NYSE/AMEX/NASDAQ, CRSP), verified against the papers; see \link{stambaugh}.
#'   `market` and `risk free rate` are shared names across sources and mean the
#'   same thing. Other factors keep distinct names (French `SMB` and Stambaugh
#'   `size`, for example, are different constructions) and are told apart by
#'   `source`. `period` stays character in each source's own format (`YYYYMM`,
#'   `YYYYMMDD` or `YYYY`); the formats are comparable across sources. Both
#'   datasets ship with the package, so there is no runtime dependency on
#'   FFresearch.
#'
#' @examples
#' all_factors()
#' all_factors("stambaugh")
#'
#' @importFrom data.table data.table rbindlist
#' @importFrom utils data
#'
#' @export
all_factors <- function(sources = c("french", "stambaugh")) {
  allowed <- c("french", "stambaugh")
  bad <- sources[!sources %in% allowed]
  if (length(bad) > 0L) {
    stop(
      "Unknown source: ", paste(dQuote(bad), collapse = ", "),
      ". Allowed sources: ", paste(dQuote(allowed), collapse = ", "), ".",
      call. = FALSE
    )
  }

  env <- new.env(parent = emptyenv())
  parts <- list()

  if ("french" %in% sources) {
    data("fama_french", package = "factors", envir = env)
    ff <- env$fama_french
    parts$french <- data.table(
      source = "French",
      region = as.character(ff$region),
      frequency = as.character(ff$frequency),
      factor = ff$factor,
      period = ff$period,
      value = ff$value
    )
  }
  if ("stambaugh" %in% sources) {
    data("stambaugh", package = "factors", envir = env)
    parts$stambaugh <- data.table(source = "Stambaugh", region = "US", env$stambaugh)
  }

  rbindlist(parts)
}