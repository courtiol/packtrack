#' Start the tracking of namespaces
#'
#' This function activates packtrack and is automatically called when the package is loaded.
#'
#' @param replace_cache whether or not to replace the existing .packtrack_data file (default = `FALSE`).
#'
#' @export
#'
packtrack_start <- function(replace_cache = FALSE) {
  ## check that .packtrack_data is not present (not the case if packtrack has been stopped with option delete_cache = FALSE):
  if (!replace_cache && exists(".packtrack_data")) {
     stop("The packtrack cache is already present, so calling packtrack_start() would destroy it. Call packtrack_start(replace_cache = TRUE) if this is really what you want.")
  }

  ## initialise hidden variables:
  .packtrack_data <<- list(time = hashmap::hashmap("@^@_start", Sys.time()),
                           n = hashmap::hashmap("@^@_start", 0L),
                           loadNamespace_original = loadNamespace)
  class(.packtrack_data) <<-  c("pktk", class(.packtrack_data))

  ## change R prompt if needed:
  options("prompt" = paste0("@^@ ", gsub(pattern = "@^@ ", replacement = "",
                                         x =  options("prompt"), fixed = TRUE)))

  ## override original loadNamespace function:
  unlockBinding("loadNamespace", env = as.environment("package:base"))
  assign("loadNamespace", function(package, ...) {
    packtrack_update(package)
    mf <- as.list(match.call(expand.dots = TRUE))
    do.call(.packtrack_data$loadNamespace_original, mf[-1], envir = parent.frame())
  }, "package:base")

  invisible(NULL)
}

#' Stop the tracking of namespaces
#'
#' This function desctivates packtrack and is automatically called when the package is unloaded.
#'
#' @param delete_cache whether or not to delete the existing .packtrack_data file (default = `TRUE`).
#'
#' @export
#'
packtrack_stop <- function(delete_cache = TRUE) {
  ## remove @^@ in R prompt if needed:
  options("prompt" = gsub(pattern = "@^@ ", replacement = "",
                          x =  options("prompt"), fixed = TRUE))

  ## restore original loadNamespace function:
  assign("loadNamespace", .packtrack_data$loadNamespace_original, "package:base")

  ## delete the file tracking the namespace usage:
  if (delete_cache && exists(".packtrack_data")) {
    rm(.packtrack_data, envir = globalenv())
  }

  invisible(NULL)
}
