#' Fama/French research factors
#'
#' @description Return (factors) and level (risk free rate) time series for the Fama/French
#'   asset pricing factors. A snapshot of the \code{factors} dataset from the FFresearch
#'   package, version 0.0.1.0 (bautheac/FFresearch master, including PR #17), snapshotted
#'   2026-11-13; not built in this package. FFresearch is a build-time dependency only
#'   (Suggests): there is no runtime dependency, and no French data is downloaded or
#'   parsed here. Rebuild with development/rebuild_fama_french.R.
#'
#' @format A \link[data.table:data.table-class]{data.table} with variables:
#' \itemize{
#'   \item{region: geographical market considered for factor construction; factor with
#'     levels US, developed, developed (ex US), Europe, JP, Asia-Pacific (ex JP),
#'     North America.}
#'   \item{frequency: factor return frequency; factor with levels month, day, year.}
#'   \item{factor: Fama/French factor; character. One of CMA, HML, LT_Rev, market, Mom,
#'     risk free rate, RMW, SMB, ST_Rev, WML.}
#'   \item{period: period over which factor returns are calculated or risk free rate level
#'     is observed; character, YYYYMM (month), YYYYMMDD (day) or YYYY (year).}
#'   \item{value: corresponding return (factors) or level (risk free rate) observation;
#'     numeric.}
#' }
#'
#' @details US monthly factors cover 192602-202609.
#'
#'   The FFresearch version used for the snapshot is recorded on the dataset
#'   itself: `attr(fama_french, "ffresearch_version")`.
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
#'   All factors are constructed from US stocks; see Details for the verification
#'   against the source papers.
#'
#' @format A \link[data.table:data.table-class]{data.table} with variables:
#' \itemize{
#'   \item{frequency: factor return frequency (day, month); character.}
#'   \item{factor: Stambaugh factor; character. One of non-traded liquidity, traded
#'     liquidity, size, management, performance, market, risk free rate.}
#'   \item{period: period over which factor returns are calculated or risk free rate level
#'     is observed; character, YYYYMM for monthly and YYYYMMDD for daily observations.}
#'   \item{value: corresponding return (factors) or level (risk free rate) observation;
#'     numeric.}
#' }
#'
#' @source \url{https://fnce.wharton.upenn.edu/profile/stambaug/} (the former
#'   finance.wharton.upenn.edu/~stambaug/ address redirects there); the data files
#'   are served from faculty.wharton.upenn.edu. Liquidity factors: Pastor & Stambaugh (2003),
#'   "Liquidity Risk and Expected Stock Returns", Journal of Political Economy 111(3),
#'   642-685, \doi{10.1086/374184}. Size, management, performance, market and risk free
#'   rate: Stambaugh & Yuan (2017), "Mispricing Factors", The Review of Financial Studies
#'   30(4), 1270-1315, \doi{10.1093/rfs/hhw107}.
#'
#' @details Region: US, verified against both papers. Their factor universes are ordinary
#'   common shares listed on NYSE/AMEX/NASDAQ (CRSP data), so every row is US. The
#'   dataset itself has no region column; \link{all_factors} adds region = "US" to every
#'   Stambaugh row.
#'
#'   Coverage: liquidity 196208-202512 (traded liquidity from 196801; earlier
#'   observations are missing in the source file); mispricing factors monthly
#'   196301-201612 and daily 19630102-20161230. The author has not refreshed the
#'   mispricing files past 2016.
#'
#'   market is the excess market return plus the risk free rate (MKTRF + RF);
#'   risk free rate is RF.
#'
#'   Rebuild with development/rebuild_stambaugh.R (cached downloads; the build
#'   functions are tested against saved fixtures).
#'
#' @importFrom data.table data.table
#'
"stambaugh"
