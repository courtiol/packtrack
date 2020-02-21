reprex::reprex({
library(packtrack)     ## tracking begins

pktk_view()            ## no packages used yet

library(stringr)       ## we load stringr

pktk_view()            ## stringr has been imported

str_c("foo", "bar")    ## we use a function not using dependencies

pktk_view()            ## no package has been used

str_glue("foo", "bar") ## we use a function using dependencies

pktk_view()            ## several packages have been used

pktk_view(previously_loaded = TRUE) ## also lists packages loaded before tracking
})
