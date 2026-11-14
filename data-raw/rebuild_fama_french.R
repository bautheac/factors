# Rebuild data/fama_french.rda as a snapshot of FFresearch::factors.
# Run from the package root: Rscript data-raw/rebuild_fama_french.R
# FFresearch is a build-time dependency only (Suggests); no French data is
# downloaded or parsed here.

library(data.table)

cat("FFresearch version:", as.character(packageVersion("FFresearch")), "\n")

fama_french <- FFresearch::factors[, .(region, frequency, factor, period, value)]

# Record the FFresearch version used for this snapshot on the data itself, so
# the shipped dataset carries its provenance (spec #1: "The rebuild records
# the FFresearch version used").
attr(fama_french, "ffresearch_version") <- as.character(packageVersion("FFresearch"))

save(fama_french, file = "data/fama_french.rda", compress = "bzip2")
cat("Saved", nrow(fama_french), "rows to data/fama_french.rda\n")
