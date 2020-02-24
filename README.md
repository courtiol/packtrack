
<!-- README.md is generated from README.Rmd. Please edit that file -->

# packtrack

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/packtrack)](https://CRAN.R-project.org/package=packtrack)
<!-- badges: end -->

The goal of **{packtrack}** is to track the usage of R packages on your
system.

This package is **highly experimental** and far from being complete.

The main motivation for this project is that R packages tend to
accumulate beyond desire. If you install a package to try out, it
usually comes with new dependencies that will be installed alongside
with it. Thus, unless you are very meticulous or use particular systems
such as **{packrat}**, you will quickly loose track of what you actually
need to keep on your system. Installed packages do not take much space
on the disk, but one major caveat of keeping unnecessary dependencies is
that your update time will increase with the number of installed R
packages.

By tracking which packages you are using, **{packtrack}** will help you
identify which are the ones you don’t use, so that you can remove them.

The package can also be used to study which dependencies are used in
practice during various workflow, which can help developers identify
which dependencies they could move from *Import* to *Suggests*.

## Installation

You can install this package using **{remotes}** (or **{devtools}**):

``` r
remotes::install_github("courtiol/packtrack")
```

## Example

``` r
library(packtrack) ## tracking begins
#> packtrack version 0.0.0.9000 is loaded: the usage of your packages is being tracked (@^@)!

pktk_view() ## no packages used yet
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-24 13:50:10            0

library(stringr) ## we load stringr

pktk_view() ## stringr has been imported
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-24 13:50:10            0
#> 2   stringr 2020-02-24 13:50:10            1

str_c("foo", "bar") ## we use a function not using dependencies
#> [1] "foobar"

pktk_view() ## no package has been used
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-24 13:50:10            0
#> 2   stringr 2020-02-24 13:50:10            1

str_glue("foo", "bar") ## we use a function using dependencies
#> foobar

pktk_view() ## several packages have been used
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-24 13:50:10            0
#> 2    crayon 2020-02-24 13:50:10            1
#> 3      glue 2020-02-24 13:50:10            1
#> 4 grDevices 2020-02-24 13:50:10            4
#> 5   methods 2020-02-24 13:50:10            2
#> 6     stats 2020-02-24 13:50:10            1
#> 7   stringr 2020-02-24 13:50:10            1
#> 8     utils 2020-02-24 13:50:10            5

pktk_view(previously_loaded = TRUE) ## also includes the packages loaded before tracking
#>      package         last_loaded times_loaded
#> 1  @^@_start 2020-02-24 13:50:10            0
#> 2       base                <NA>            1
#> 3  codetools                <NA>            1
#> 4   compiler                <NA>            1
#> 5     crayon 2020-02-24 13:50:10            1
#> 6   datasets                <NA>            1
#> 7     digest                <NA>            1
#> 8   evaluate                <NA>            1
#> 9       glue 2020-02-24 13:50:10            1
#> 10  graphics                <NA>            1
#> 11 grDevices 2020-02-24 13:50:10            4
#> 12   hashmap                <NA>            1
#> 13 htmltools                <NA>            1
#> 14     knitr                <NA>            1
#> 15  magrittr                <NA>            1
#> 16   methods 2020-02-24 13:50:10            2
#> 17 packtrack                <NA>            1
#> 18      Rcpp                <NA>            1
#> 19     rlang                <NA>            1
#> 20 rmarkdown                <NA>            1
#> 21     stats 2020-02-24 13:50:10            1
#> 22   stringi                <NA>            1
#> 23   stringr 2020-02-24 13:50:10            1
#> 24     tools                <NA>            1
#> 25     utils 2020-02-24 13:50:10            5
#> 26      xfun                <NA>            1
#> 27      yaml                <NA>            1

all_pkg <- pktk_view(non_used = TRUE) ## also includes all other packages installed on the system

sum(all_pkg$times_loaded != 0) ## number of packages used during this session
#> [1] 26

sum(all_pkg$times_loaded == 0) ## number of packages not used during this session
#> [1] 582
```

## What to expect in the future

  - better tracking (not all namespaces are being tracked in all
    circumstances)
  - information collected will not disappear when you close R (by means
    of the package **{later}** and/or **{callr}** or **{processx}**)
  - companion functions to explore the collected data and help you
    diagnose which R packages can be safely deleted from your system

## CRAN release?

Under the current implementation, the tracking procedure implies
overriding a base function, which is against CRAN policies (for good
reasons). It would be possible to do similar things without overriding
any function, but that would imply to run a loop in the background. Such
a loop would be needed to regularly check which namespaces have been
loaded and update the list of packages that have been used. The result
would be almost the same, but such a loop would use more system
resources and one difference is that the tracking would also not be able
to count how many imports of the same package have been performed (but
perhaps, this information is not really interesting anyhow…).

## Help & feedbacks wanted\!

If you find that this package is an idea worth pursuing, please let me
know. Developing is always more fun when it becomes a collaborative
work. So please also email me (or leave an issue) if you want to get
involved\!
