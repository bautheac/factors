factors
================

[![Travis-CI Build Status](https://travis-ci.org/bautheac/FFresearch.svg?branch=master)](https://travis-ci.org/bautheac/factors) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/bautheac/FFresearch?branch=master&svg=true)](https://ci.appveyor.com/project/bautheac/factors) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

<style> body {text-align: justify} </style>
factors
-------

Various asset pricing research factor time series conveniently packaged for consumption by R users. The data is pulled directly from authors' website. Install from [github](https://github.com/bautheac/factors/) with `devtools::install_github("bautheac/factors")`.

### Fama & French

The 'Fama & French' dataset provides the return (factors) and level (risk free rate) time series for the classic Fama/French asset pricing factors as used in their three (Fama and French 1992; Fama and French 1993; Fama and French 1995) and most recently five-factor (Fama and French 2015; Fama and French 2016; Fama and French 2017) asset pricing models very popular to the asset pricing enthousiasts:

    #>    region frequency factor period value
    #> 1:     US     month    CMA 196801  6.45
    #> 2:     US     month    CMA 196802  2.48
    #> 3:     US     month    CMA 196803 -1.15
    #> 4:     US     month    CMA 196804 -3.66
    #> 5:     US     month    CMA 196805 -1.85
    #> 6:     US     month    CMA 196806  2.65

### Stambaugh et al

The 'Stambaugh et al' dataset provides the return (factors) and level (risk free rate) time series for various research asset pricing factors put together by Robert F. Stambaugh and collaborators including Lubos Pastor and Yu Yuan. The factors include traded & non-traded liquidity (Pástor and Stambaugh 2003), as well as market, size and two 'mispricing' factors: management & performance (Stambaugh and Yuan 2016):

    #>    frequency               factor period       value
    #> 1:     month non-traded liquidity 196208  0.00437073
    #> 2:     month non-traded liquidity 196209  0.01230259
    #> 3:     month non-traded liquidity 196210 -0.07407571
    #> 4:     month non-traded liquidity 196211  0.02923186
    #> 5:     month non-traded liquidity 196212  0.01592809
    #> 6:     month non-traded liquidity 196301  0.01013548

references
----------

Fama, Eugene F., and Kenneth R. French. 1992. “The Cross-Section of Expected Stock Returns.” *The Journal of Finance* 47 (2): 427–65. doi:[10.1111/j.1540-6261.1992.tb04398.x](https://doi.org/10.1111/j.1540-6261.1992.tb04398.x).

———. 1993. “Common Risk Factors in the Returns on Stocks and Bonds.” *Journal of Financial Economics* 33 (1): 3–56. doi:[10.1016/0304-405X(93)90023-5](https://doi.org/10.1016/0304-405X(93)90023-5).

———. 1995. “Size and Book-to-Market Factors in Earnings and Returns.” *The Journal of Finance* 50 (1): 131–55. doi:[10.1111/j.1540-6261.1995.tb05169.x](https://doi.org/10.1111/j.1540-6261.1995.tb05169.x).

———. 2015. “A Five-Factor Asset Pricing Model.” *Journal of Financial Economics* 116 (1): 1–22. doi:[10.1016/j.jfineco.2014.10.010](https://doi.org/10.1016/j.jfineco.2014.10.010).

———. 2016. “Dissecting Anomalies with a Five-Factor Model.” *The Review of Financial Studies* 29 (1): 69–103. doi:[10.1093/rfs/hhv043](https://doi.org/10.1093/rfs/hhv043).

———. 2017. “International Tests of a Five-Factor Asset Pricing Model.” *Journal of Financial Economics* 123 (3): 441–63. doi:[10.1016/j.jfineco.2016.11.004](https://doi.org/10.1016/j.jfineco.2016.11.004).

Pástor, L’uboš, and Robert F Stambaugh. 2003. “Liquidity Risk and Expected Stock Returns.” *Journal of Political Economy* 111 (3). The University of Chicago Press: 642–85.

Stambaugh, Robert F, and Yu Yuan. 2016. “Mispricing Factors.” *The Review of Financial Studies* 30 (4). Oxford University Press: 1270–1315.
