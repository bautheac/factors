#' Fama/French research factors
#'
#' @description Return (factors) and level (risk free rate) time series for the Fama/French
#'   asset pricing factors.
#'
#' @format A \linkS4class{data.table} with variables:
#' \itemize{
#'   \item{region: geographical market considered for factor construction.}
#'   \item{frequency: factor return frequency (day, month, year).}
#'   \item{period: period over which factor returns are calculated or risk free rate level is observed.}
#'   \item{factor: Fama/French factor}
#'   \item{value: corresponding return (factors) or level (risk free rate) observation.}
#' }
#'
#' @source \url{http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html}.
#'
#' @importFrom data.table data.table
#'
"fama_french"


#' Stambaugh et al. research factors
#'
#' @description Return (factors) and level (risk free rate) time series for various research asset
#'   pricing factors put together by Robert F. Stambaugh and collaborators including
#'   Lubos Pastor and Yu Yuan. The factors include liquidity (traded & non-traded),
#'   market, size as well as two 'mispricing' factors: management & performance.
#'
#' @format A \linkS4class{data.table} with variables:
#' \itemize{
#'   \item{frequency: factor return frequency (day, month, year).}
#'   \item{period: period over which factor returns are calculated or risk free rate level is observed.}
#'   \item{factor: Fama/French factor}
#'   \item{value: corresponding return (factors) or level (risk free rate) observation.}
#' }
#'
#' @source \url{http://finance.wharton.upenn.edu/~stambaug}.
#'
#' @importFrom data.table data.table
#'
"stambaugh"
