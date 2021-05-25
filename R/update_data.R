#' Update the dictionary
#'
#' This function either adds a new entry to the dictionary if the package is not among
#' the keys, or refreshes the time stamp otherwise.
#'
#' @param pkg the name of the package to add to the dictionary
#'
#' @export
#'
packtrack_update <- function(pkg) {
  .packtrack_data$time[[pkg]] <- Sys.time()
  if (.packtrack_data$n$has_key(pkg)) {
      .packtrack_data$n[[pkg]] <- .packtrack_data$n[[pkg]] + 1L
  } else {
    .packtrack_data$n[[pkg]] <- 1L
  }
  #packtrack_unlock() ## for unlocking the saving on drive -> for future
  NULL
}
