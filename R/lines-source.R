#' Read lines from a local file
#'
#' @description Returns the lines of a text file. Stambaugh build functions
#'   receive these lines directly; they never open files or URLs themselves,
#'   so tests can swap in fixture lines.
#'
#' @param path Path to a text file.
#'
#' @return A character vector, one element per line.
#'
#' @keywords internal
#' @noRd
lines_from_path <- function(path) {
  readLines(path, warn = FALSE)
}

#' Read lines from a URL
#'
#' @description Returns the lines of a text file served at a URL. Same call
#'   shape as lines_from_path() so build functions can take either source.
#'
#' @param url URL of a text file.
#'
#' @return A character vector, one element per line.
#'
#' @keywords internal
#' @noRd
lines_from_url <- function(url) {
  readLines(url, warn = FALSE)
}
