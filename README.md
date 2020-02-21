
# packtrack

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/packtrack)](https://CRAN.R-project.org/package=packtrack)
<!-- badges: end -->

The goal of __{packtrack}__ is to track the usage of R packages.

This package is __highly experimental__ and far from being complete.

The main motivation for this project is that R packages tend to accumulate beyond desire.
If you install a package to try out, it usually comes with new dependencies that will be installed alongside with it.
Thus, unless you are very meticulous or use particular systems such as __{packrat}__, you will quickly loose track of what you actually need to keep on your system.
Installed packages do not take much space on the disk but one major caveat of keeping unnecessary dependencies is that your update time will increase as the number of R packages on your system grows.

By tracking which packages you are using, __{packtrack}__ will help you identify which ones you don't use, so that you can remove them.

The package can also be used to study which dependencies are really used in practice, which can help developers know which dependencies they could move from _Import_ to _Suggests_.

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
#>     package         last_loaded times_used
#> 1 @^@_start 2020-02-21 09:20:38          0

library(stringr)       ## we load stringr

pktk_view()            ## stringr has been imported
#>     package         last_loaded times_used
#> 1 @^@_start 2020-02-21 09:20:38          0
#> 2   stringr 2020-02-21 09:20:38          1

str_c("foo", "bar")    ## we use a function not using dependencies
#> [1] "foobar"

pktk_view()            ## no package has been used
#>     package         last_loaded times_used
#> 1 @^@_start 2020-02-21 09:20:38          0
#> 2   stringr 2020-02-21 09:20:38          1

str_glue("foo", "bar") ## we use a function using dependencies
#> foobar

pktk_view()            ## several packages have been used
#>     package         last_loaded times_used
#> 1 @^@_start 2020-02-21 09:20:38          0
#> 2    crayon 2020-02-21 09:20:38          1
#> 3      glue 2020-02-21 09:20:38          1
#> 4 grDevices 2020-02-21 09:20:38          4
#> 5   methods 2020-02-21 09:20:38          2
#> 6     stats 2020-02-21 09:20:38          1
#> 7   stringr 2020-02-21 09:20:38          1
#> 8     utils 2020-02-21 09:20:38          5

<sup>Created on 2020-02-21 by the [reprex package](https://reprex.tidyverse.org) (v0.3.0)</sup>
```

## What to expect in the future

- better tracking (not all namespaces are being tracked in all circumstances)
- information collected will not disappear when you close R (by means of the package __{later}__ and/or __{callr}__ or __{processx}__)
- companion functions to explore the collected data and help you diagnose which packages can be safely deleted

## CRAN release?

Under the current implementation, the tracking procedure implies overriding an R base function, which is against CRAN policies (for good reasons).
It would be possible to do similar things without overriding any function, but that would imply to run a loop in the background.
Such a loop would be needed to regularly check which namespaces have been loaded and update the list of packages that have been used.
The result would be almost the same, but such a loop would use system resources.
One difference is that the tracking would also not be able to count how many import of the same package have been performed but perhaps, this information is not really interesting anyhow...

## Help \& feedbacks wanted!

If you find that this is an idea worth pursuing, please let me know.
Also, developing is always more fun when it becomes a collaborative work.
So please email me or leave an issue if you want to get involved!
