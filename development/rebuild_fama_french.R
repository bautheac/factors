# Rebuild data/fama_french.rda as a snapshot of FFresearch::factors.
# Run from the package root: Rscript development/rebuild_fama_french.R
# FFresearch is a build-time dependency only (Suggests); no French data is
# downloaded or parsed here.

library(data.table)

cat("FFresearch version:", as.character(packageVersion("FFresearch")), "\n")

fama_french <- FFresearch::factors[, .(region, frequency, factor, period, value)]

save(fama_french, file = "data/fama_french.rda", compress = "bzip2")
cat("Saved", nrow(fama_french), "rows to data/fama_french.rda\n")
