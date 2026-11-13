factors
================

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<style> body {text-align: justify} </style>

[factors](https://github.com/bautheac/factors/) packages various asset
pricing research factor time series for convenient consumption by R
users. The data is pulled directly from authors’ website. Install from
GitHub with `devtools::install_github("bautheac/factors")`.

### All factors

`all_factors()` returns every factor shipped by the package in a single
long-format table, with a `source` column to tell French and Stambaugh
factors apart:

``` r
head(all_factors())
#>    source region frequency factor period value
#>    <char> <char>    <char> <char> <char> <num>
#> 1: French     US     month    CMA 196307 -1.15
#> 2: French     US     month    CMA 196308 -0.38
#> 3: French     US     month    CMA 196309  0.15
#> 4: French     US     month    CMA 196310 -2.25
#> 5: French     US     month    CMA 196311  2.27
#> 6: French     US     month    CMA 196312 -0.25
```

### Fama & French

The `fama_french` dataset provides the return (factors) and level (risk
free rate) time series for the classic Fama/French asset pricing factors
as used in their three (Fama and French 1992, 1993, 1995) and most
recently five-factor (Fama and French 2015, 2016, 2017) asset pricing
models very popular to the asset pricing enthusiasts. It is a snapshot
of the `factors` dataset from the
[FFresearch](https://github.com/bautheac/FFresearch/) package, not built
here:

    #>    region frequency factor period value
    #>    <fctr>    <fctr> <char> <char> <num>
    #> 1:     US     month    CMA 196307 -1.15
    #> 2:     US     month    CMA 196308 -0.38
    #> 3:     US     month    CMA 196309  0.15
    #> 4:     US     month    CMA 196310 -2.25
    #> 5:     US     month    CMA 196311  2.27
    #> 6:     US     month    CMA 196312 -0.25

### Stambaugh et al

The `stambaugh` dataset provides the return (factors) and level (risk
free rate) time series for various research asset pricing factors put
together by Robert F. Stambaugh and collaborators including Lubos Pastor
and Yu Yuan. The factors include traded & non-traded liquidity (Pástor
and Stambaugh 2003), as well as market, size and two ‘mispricing’
factors: management & performance (Stambaugh and Yuan 2016):

    #>    frequency               factor period       value
    #>       <char>               <char> <char>       <num>
    #> 1:     month non-traded liquidity 196208  0.00425841
    #> 2:     month non-traded liquidity 196209  0.01112344
    #> 3:     month non-traded liquidity 196210 -0.07388795
    #> 4:     month non-traded liquidity 196211  0.02812444
    #> 5:     month non-traded liquidity 196212  0.01495171
    #> 6:     month non-traded liquidity 196301  0.00941523

### finRes

Although the [factors](https://bautheac.github.io/factors/) package is
self-contained it belongs to the
[finRes](https://bautheac.github.io/finRes/) suite of packages where it
helps with asset pricing research and analysis.

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-fama_cross_section_1992" class="csl-entry">

Fama, Eugene F., and Kenneth R. French. 1992. “The Cross-Section of
Expected Stock Returns.” *The Journal of Finance* 47 (2): 427–65.
<https://doi.org/10.1111/j.1540-6261.1992.tb04398.x>.

</div>

<div id="ref-fama_common_1993" class="csl-entry">

———. 1993. “Common Risk Factors in the Returns on Stocks and Bonds.”
*Journal of Financial Economics* 33 (1): 3–56.
<https://doi.org/10.1016/0304-405X(93)90023-5>.

</div>

<div id="ref-fama_size_1995" class="csl-entry">

———. 1995. “Size and Book-to-Market Factors in Earnings and Returns.”
*The Journal of Finance* 50 (1): 131–55.
<https://doi.org/10.1111/j.1540-6261.1995.tb05169.x>.

</div>

<div id="ref-fama_five_factor_2015" class="csl-entry">

———. 2015. “A Five-Factor Asset Pricing Model.” *Journal of Financial
Economics* 116 (1): 1–22.
<https://doi.org/10.1016/j.jfineco.2014.10.010>.

</div>

<div id="ref-fama_dissecting_2016" class="csl-entry">

———. 2016. “Dissecting Anomalies with a Five-Factor Model.” *The Review
of Financial Studies* 29 (1): 69–103.
<https://doi.org/10.1093/rfs/hhv043>.

</div>

<div id="ref-fama_international_2017" class="csl-entry">

———. 2017. “International Tests of a Five-Factor Asset Pricing Model.”
*Journal of Financial Economics* 123 (3): 441–63.
<https://doi.org/10.1016/j.jfineco.2016.11.004>.

</div>

<div id="ref-pastor_liquidity_2003" class="csl-entry">

Pástor, L’uboš, and Robert F Stambaugh. 2003. “Liquidity Risk and
Expected Stock Returns.” *Journal of Political Economy* 111 (3): 642–85.

</div>

<div id="ref-stambaugh_mispricing_2016" class="csl-entry">

Stambaugh, Robert F, and Yu Yuan. 2016. “Mispricing Factors.” *The
Review of Financial Studies* 30 (4): 1270–1315.

</div>

</div>
