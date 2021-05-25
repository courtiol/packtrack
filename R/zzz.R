#' Display welcome message
#'
#' This function should not be called by the user. It displays a message when
#' the package is being loaded.
#'
#' @param libname argument needed but automatically defined.
#' @param pkgname argument needed but automatically defined.
#'
#' @export
#'
.onAttach <- function(libname, pkgname) {
  packageStartupMessage( ## display message
    "packtrack version ", utils::packageDescription("packtrack")$Version, " is loaded: ",
       "the usage of your packages is being tracked (@^@)!")
}


#' Load
#'
#' This function should not be called by the user. It set initiate some hidden
#' variables used by this packages when the package is being loaded. The
#' function also modifies the prompt to indicate that packtrack is running.
#'
#' @param libname argument needed but automatically defined.
#' @param pkgname argument needed but automatically defined.
#'
#' @export
#'
.onLoad <- function(libname, pkgname) {

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

  NULL
}


#' Unload
#'
#' This function should not be called by the user. It reset original R
#' parameters when the package is being unloaded.
#'
#' @param libpath argument needed but automatically defined.
#'
#' @export
#'
.onUnload <- function(libpath) {

  ## remove @^@ in R prompt if needed:
  options("prompt" = gsub(pattern = "@^@ ", replacement = "",
                          x =  options("prompt"), fixed = TRUE))

  ## restore original loadNamespace function:
  assign("loadNamespace", .packtrack_data$loadNamespace_original, "package:base")
}

