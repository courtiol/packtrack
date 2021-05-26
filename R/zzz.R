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
  packtrack_start(create_cache = TRUE)
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
  packtrack_stop(delete_cache = TRUE)
}

