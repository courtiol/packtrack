
# packtrack

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/packtrack)](https://CRAN.R-project.org/package=packtrack)
<!-- badges: end -->

The goal of __{packtrack}__ is to track the usage of R packages on your system.

This package is __highly experimental__ and far from being complete.

The main motivation for this project is that R packages tend to accumulate beyond desire.
If you install a package to try out, it usually comes with new dependencies that will be installed alongside with it.
Thus, unless you are very meticulous or use particular systems such as __{packrat}__, you will quickly loose track of what you actually need to keep on your system.
Installed packages do not take much space on the disk, but one major caveat of keeping unnecessary dependencies is that your update time will increase with the number of installed R packages.

By tracking which packages you are using, __{packtrack}__ will help you identify which are the ones you don't use, so that you can remove them.

The package can also be used to study which dependencies are used in practice during various workflow, which can help developers identify which dependencies they could move from _Import_ to _Suggests_.

## Installation

You can install this package using __{remotes}__ (or __{devtools}__):

``` r
remotes::install_github("courtiol/packtrack")
```

## Example

``` r
library(packtrack)     ## tracking begins
#> packtrack version 0.0.0.9000 is loaded: the usage of your packages is being tracked (@^@)!

pktk_view()            ## no packages used yet
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-22 10:27:56            0

library(stringr)       ## we load stringr

pktk_view()            ## stringr has been imported
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-22 10:27:56            0
#> 2   stringr 2020-02-22 10:27:56            1

str_c("foo", "bar")    ## we use a function not using dependencies
#> [1] "foobar"

pktk_view()            ## no package has been used
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-22 10:27:56            0
#> 2   stringr 2020-02-22 10:27:56            1

str_glue("foo", "bar") ## we use a function using dependencies
#> foobar

pktk_view()            ## several packages have been used
#>     package         last_loaded times_loaded
#> 1 @^@_start 2020-02-22 10:27:56            0
#> 2    crayon 2020-02-22 10:27:56            1
#> 3      glue 2020-02-22 10:27:56            1
#> 4 grDevices 2020-02-22 10:27:56            4
#> 5   methods 2020-02-22 10:27:56            2
#> 6     stats 2020-02-22 10:27:56            1
#> 7   stringr 2020-02-22 10:27:56            1
#> 8     utils 2020-02-22 10:27:56            5

pktk_view(previously_loaded = TRUE) ## also lists packages loaded before tracking
#>      package         last_loaded times_loaded
#> 1       base                <NA>            1
#> 2  codetools                <NA>            1
#> 3   compiler                <NA>            1
#> 4     crayon 2020-02-22 10:27:56            1
#> 5     crayon                <NA>            1
#> 6   datasets                <NA>            1
#> 7     digest                <NA>            1
#> 8   evaluate                <NA>            1
#> 9       glue 2020-02-22 10:27:56            1
#> 10      glue                <NA>            1
#> 11  graphics                <NA>            1
#> 12 grDevices 2020-02-22 10:27:56            4
#> 13 grDevices                <NA>            1
#> 14   hashmap                <NA>            1
#> 15     highr                <NA>            1
#> 16 htmltools                <NA>            1
#> 17     knitr                <NA>            1
#> 18  magrittr                <NA>            1
#> 19   methods 2020-02-22 10:27:56            2
#> 20   methods                <NA>            1
#> 21 packtrack                <NA>            1
#> 22      Rcpp                <NA>            1
#> 23     rlang                <NA>            1
#> 24 rmarkdown                <NA>            1
#> 25     stats 2020-02-22 10:27:56            1
#> 26     stats                <NA>            1
#> 27   stringi                <NA>            1
#> 28   stringr 2020-02-22 10:27:56            1
#> 29   stringr                <NA>            1
#> 30     tools                <NA>            1
#> 31     utils 2020-02-22 10:27:56            5
#> 32     utils                <NA>            1
#> 33      xfun                <NA>            1
#> 34      yaml                <NA>            1
#> 35 @^@_start 2020-02-22 10:27:56            0
```

<sup>Created on 2020-02-22 by the [reprex package](https://reprex.tidyverse.org) (v0.3.0)</sup>


## What to expect in the future

- better tracking (not all namespaces are being tracked in all circumstances)
- information collected will not disappear when you close R (by means of the package __{later}__ and/or __{callr}__ or __{processx}__)
- companion functions to explore the collected data and help you diagnose which R packages can be safely deleted from your system

## CRAN release?

Under the current implementation, the tracking procedure implies overriding a base function, which is against CRAN policies (for good reasons).
It would be possible to do similar things without overriding any function, but that would imply to run a loop in the background.
Such a loop would be needed to regularly check which namespaces have been loaded and update the list of packages that have been used.
The result would be almost the same, but such a loop would use more system resources and one difference is that the tracking would also not be able to count how many imports of the same package have been performed (but perhaps, this information is not really interesting anyhow...).

## Help \& feedbacks wanted!

If you find that this package is an idea worth pursuing, please let me know.
Developing is always more fun when it becomes a collaborative work.
So please also email me (or leave an issue) if you want to get involved!
