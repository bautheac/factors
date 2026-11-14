# Rebuild both shipped datasets (fama_french and stambaugh).
# Run from the package root: Rscript data-raw/rebuild.R

source("data-raw/rebuild_fama_french.R")
source("data-raw/rebuild_stambaugh.R")
