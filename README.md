
# `ggirf`

This package provides ggplot2 support for impulse response analysis in
various packages such as `vars`, `lpirfs`, `BGVAR` used for
macroeconomic analysis. The library includes custom colors and a ggplot2
theme. You can optionally provide different colors.

## Installation

You can install the development version of `ggirf` from
[GitHub](https://github.com/) with:

    # install.packages("devtools")
    devtools::install_github("muhsinciftci/ggirf")

## Contribution

Should you want to contribute to this package, please make a pull
request via this repo

## VAR impulse response analysis via `vars` package

``` r
library(vars)
#> Loading required package: MASS
#> Loading required package: strucchange
#> Loading required package: zoo
#> 
#> Attaching package: 'zoo'
#> The following objects are masked from 'package:base':
#> 
#>     as.Date, as.Date.numeric
#> Loading required package: sandwich
#> Loading required package: urca
#> Loading required package: lmtest
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.1
#> ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.2
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ stringr::boundary() masks strucchange::boundary()
#> ✖ dplyr::filter()     masks stats::filter()
#> ✖ dplyr::lag()        masks stats::lag()
#> ✖ dplyr::select()     masks MASS::select()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(lpirfs)
library(ggirf)
theme_set(gg_theme_irf())
```

``` r
var_estimation <- vars::VAR(Canada, p = 2, type = "const")
var_irf        <- vars::irf(var_estimation)
```

and the impulse response graph via `ggirf` would be:

``` r
gg_vars(irf_result = var_irf, var_shock = 'e') +
  gg_theme_irf() +
  scale_x_continuous(minor_breaks = NULL, n.breaks = 6)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" /> or
you can simply provide one variable as well. **Providing multiple shocks
once is not allowed.** Providing a subset of endogenous variables at
once is allowed though.

``` r
gg_vars(irf_result = var_irf, var_shock = 'e', var_endo = c('e', 'rw'), shade_color = 'orange') +
  gg_theme_irf() +
  scale_x_continuous(minor_breaks = NULL, n.breaks = 6) +
  ggtitle('Subset of endogenous variables')
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

## Local projections impulse response analysis via `lpirfs` package

``` r
endog_data <- vars::Canada |> tibble::as_tibble()

est_lp_lin <- lp_lin(
  endog_data,
  lags_endog_lin = 2,
  trend          = 0,
  shock_type     = 1,
  confint        = 1.96,
  hor            = 12
  )
```

The default charts are:

``` r
linear_plots <- plot_lin(est_lp_lin)
linear_plots[[1]]
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

The same result in `ggirf` package would be:

``` r
gg_lpirfs_lin(
  lp_lin = est_lp_lin,
  shock_lp = 'e',
  endo_lp = 'e'
)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

or plotting many endogenous variables at once is possible. Default is
all variables

``` r
gg_lpirfs_lin(
  lp_lin = est_lp_lin,
  shock_lp = 'e',
  num_col = 2
) +
  ggtitle('The impact of variable .... on variables')
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

or one can only produce the resulting tibble instead of charts. This is
useful especially when one want to compare results from different
methods and plot them together.

``` r
gg_lpirfs_lin(
  lp_lin = est_lp_lin,
  shock_lp = 'e',
  return_only_data = T
) |> 
  head()
#> # A tibble: 6 × 6
#>   Shock variables     low Periods     mean      up
#>   <chr> <chr>       <dbl>   <int>    <dbl>   <dbl>
#> 1 e     e          1            1  1        1     
#> 2 e     prod      -0.0567       1 -0.0567  -0.0567
#> 3 e     rw        -0.320        1 -0.320   -0.320 
#> 4 e     U         -0.525        1 -0.525   -0.525 
#> 5 e     e          1.44         2  1.51     1.58  
#> 6 e     prod       0.0226       2 -0.00331 -0.0292
```
