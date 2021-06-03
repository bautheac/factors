library(magrittr); library(doParallel)

# start cluster ####
cluster <- makeCluster(detectCores() - 1L); registerDoParallel(cluster)

# Fama & French ####
for (j in readxl::read_xlsx(path = "data-raw/urls.xlsx", sheet = "factors")$data)
  download.file(j, destfile = paste0("data-raw/", stringr::str_match(j, "(?<=ftp/).+\\.zip")), method = "libcurl")
# start <- lubridate::year("2018-12-31") - 50L
start <- lubridate::year(Sys.Date()) - 50L

## contemporaneous ####
gc(); urls <- readxl::read_xlsx(path = "data-raw/urls.xlsx", sheet = "factors") %>% dplyr::filter(type == "contemporaneous")

contemporaneous <- foreach(x = seq_along(urls$data), .combine = rbind) %dopar% {
  library(magrittr)

  # params ####
  data <- dplyr::slice(urls, x)
  region <- dplyr::select(data, region) %>% purrr::flatten_chr(); skip <- dplyr::select(data, skip) %>% purrr::flatten_chr()
  file <- dplyr::select(data, data) %>% purrr::flatten_chr(); file <- paste0("data-raw", stringr::str_extract(file, "/[^/]+\\.zip$"))
  message(paste(x, file, sep = " - "))
  file <- utils::unzip(file, exdir = "data-raw"); data <- read.csv(file, sep = ",", skip = skip, header = T, stringsAsFactors = FALSE)

  annual <- any(stringr::str_detect(data$X, "[Aa]nnual"))
  annual <- ifelse(annual, which(stringr::str_detect(data$X, "[Aa]nnual")), NA)
  out <- if (is.na(annual)) data else dplyr::slice(data, 1L:(annual - 1L))
  k <- nchar(as.integer(out$X[1L])); frequency <- dplyr::case_when(k == 4 ~ "year", k == 6 ~ "month", k == 8 ~ "day")
  out <- dplyr::mutate(out, market = as.numeric(`Mkt.RF`) + as.numeric(`RF`), Region = region, Frequency = frequency) %>%
    dplyr::select(Region, Frequency, Period = X, SMB, HML, RMW, CMA, market, `risk free rate` = RF) %>%
    tidyr::gather(Factor, Return, -c(Region, Frequency, Period))

  if (!is.na(annual)){
    j <- any(stringr::str_detect(data$X[(annual + 2L):NROW(data$X)], "[a-zA-Z]+"))
    j <- ifelse(j, which(stringr::str_detect(data$X[(annual + 2L):NROW(data$X)], "[a-zA-Z]+"))[1L], NROW(data$X) - annual)
    annual <- dplyr::slice(data, (annual + 2L):(annual + j))
    k <- nchar(as.integer(annual$X[1L])); frequency <- dplyr::case_when(k == 4 ~ "year", k == 6 ~ "month", k == 8 ~ "day")
    annual <- dplyr::mutate(annual, market = as.numeric(`Mkt.RF`) + as.numeric(`RF`), Region = region, Frequency = frequency) %>%
      dplyr::select(Region, Frequency, Period = X, SMB, HML, RMW, CMA, market, `risk free rate` = RF) %>%
      tidyr::gather(Factor, Return, -c(Region, Frequency, Period))
    out <- rbind(out, annual)
  }

  unlink(file, force = FALSE); gc(); out
} %>%
  dplyr::mutate(year = as.integer(stringr::str_extract(Period, "^[0-9]{4}"))) %>% dplyr::filter(year >= start) %>% dplyr::select(-year) %>%
  dplyr::mutate(Return = ifelse(Return %in% c("  -99.99", "  -999"), NA, as.numeric(Return))) %>% dplyr::filter(complete.cases(.)) %>%
  dplyr::mutate_at(dplyr::vars(Region, Frequency), dplyr::funs(forcats::as_factor(.)))

## prior returns ####
gc(); urls <- readxl::read_xlsx(path = "data-raw/urls.xlsx", sheet = "factors") %>% dplyr::filter(type == "prior returns")

`prior returns` <- foreach(x = seq_along(urls$data), .combine = rbind) %dopar% {
  library(magrittr)

  # params ####
  data <- dplyr::slice(urls, x)
  region <- dplyr::select(data, region) %>% purrr::flatten_chr(); skip <- dplyr::select(data, skip) %>% purrr::flatten_chr()
  file <- dplyr::select(data, data) %>% purrr::flatten_chr(); file <- paste0("data-raw", stringr::str_extract(file, "/[^/]+\\.zip$"))
  message(paste(x, file, sep = " - "))
  # data ####
  file <- utils::unzip(file, exdir = "data-raw"); data <- read.csv(file, sep = ",", skip = skip, header = T, stringsAsFactors = FALSE)

  annual <- any(stringr::str_detect(data$X, "[Aa]nnual"))
  annual <- ifelse(annual, which(stringr::str_detect(data$X, "[Aa]nnual")), NA)
  out <- if (is.na(annual)) data else dplyr::slice(data, 1L:(annual - 1L))
  k <- nchar(as.integer(out$X[1L])); frequency <- dplyr::case_when(k == 4 ~ "year", k == 6 ~ "month", k == 8 ~ "day")
  out <- dplyr::mutate(out, Region = region, Frequency = frequency) %>%
    dplyr::select(Region, Frequency, Period = `X`, dplyr::everything()) %>%
    tidyr::gather(Factor, Return, -c(Region, Frequency, Period))

  if (!is.na(annual)){
    j <- any(stringr::str_detect(data$X[(annual + 2L):NROW(data$X)], "[a-zA-Z]+"))
    j <- ifelse(j, which(stringr::str_detect(data$X[(annual + 2L):NROW(data$X)], "[a-zA-Z]+"))[1L], NROW(data$X) - annual)
    annual <- dplyr::slice(data, (annual + 2L):(annual + j))
    k <- nchar(as.integer(annual$X[1L])); frequency <- dplyr::case_when(k == 4 ~ "year", k == 6 ~ "month", k == 8 ~ "day")
    annual <- dplyr::mutate(annual, Region = region, Frequency = frequency) %>%
      dplyr::select(Region, Frequency, Period = `X`, dplyr::everything()) %>%
      tidyr::gather(Factor, Return, -c(Region, Frequency, Period))
    out <- rbind(out, annual)
  }

  unlink(file, force = FALSE); gc(); out
} %>% dplyr::mutate(year = as.integer(stringr::str_extract(Period, "^[0-9]{4}"))) %>% dplyr::filter(year >= start) %>% dplyr::select(-year) %>%
  dplyr::mutate(Return = ifelse(Return %in% c("  -99.99", "  -999"), NA, as.numeric(Return))) %>% dplyr::filter(complete.cases(.)) %>%
  dplyr::mutate_at(dplyr::vars(Region, Frequency), dplyr::funs(forcats::as_factor(.)))

factors <- plyr::rbind.fill(contemporaneous, `prior returns`)

fama_french <- setNames(factors, tolower(names(factors))) %>% dplyr::mutate(period = trimws(period, which = "both")) %>%
  dplyr::select(region, frequency, factor, period, value = return) %>% dplyr::arrange(region, frequency, factor, period) %>%
  data.table::data.table()

usethis::use_data(fama_french, overwrite = TRUE); remove(contemporaneous, `prior returns`, factors, fama_french); gc()



# Stambaugh (2003) ####

## liquidity (Pastor–Stambaugh (2003)) ####
liquidity <- data.table::fread("http://finance.wharton.upenn.edu/~stambaug/liq_data_1962_2020.txt", fill = T, skip = 11L) %>%
  dplyr::select(1L, 3L:4L) %>% setNames(c("period", "non-traded liquidity", "traded liquidity")) %>%
  tidyr::gather(factor, value, -period) %>% dplyr::mutate(field = "return", frequency = "month") %>%
  dplyr::select(frequency, factor, field, period, value)

## mispricing (Stambaugh–Yuan (2017)) ####
day <- data.table::fread("http://finance.wharton.upenn.edu/~stambaug/M4d.csv") %>% dplyr::mutate(market = MKTRF + RF) %>%
  dplyr::select(-MKTRF) %>% setNames(c("period", "size", "management", "performance", "risk free rate", "market")) %>%
  tidyr::gather(factor, value, -period) %>% dplyr::mutate(field = "return", frequency = "day") %>%
  dplyr::select(frequency, factor, field, period, value)
month <- data.table::fread("http://finance.wharton.upenn.edu/~stambaug/M4.csv") %>% dplyr::mutate(market = MKTRF + RF) %>%
  dplyr::select(-MKTRF) %>% setNames(c("period", "size", "management", "performance", "risk free rate", "market")) %>%
  tidyr::gather(factor, value, -period) %>% dplyr::mutate(field = "return", frequency = "month") %>%
  dplyr::select(frequency, factor, field, period, value)

## merge ####
# `Stambaugh et al.` <- dplyr::bind_rows(liquidity, day, month) %>% dplyr::mutate(field = ifelse(factor == "risk free rate", "level", field)) %>%
#   data.table::as.data.table()
stambaugh <- dplyr::bind_rows(liquidity, day, month) %>% dplyr::select(-field) %>% data.table::as.data.table()

## save ####
usethis::use_data(stambaugh, overwrite = TRUE); remove(stambaugh)



parallel::stopCluster(cluster)
