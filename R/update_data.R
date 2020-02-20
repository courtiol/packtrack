#' Update the dictionary
#'
#' This function either adds a new entry to the dictionary if the package is not among
#' the keys, or refreshes the time stamp otherwise.
#'
#' @param pkg the name of the package to add to the dictionary
#'
#' @export
#'
pktk_update <- function(pkg) {
  .pktk_data$time[[pkg]] <- Sys.time()
  if (.pktk_data$n$has_key(pkg)) {
      .pktk_data$n[[pkg]] <- .pktk_data$n[[pkg]] + 1L
  } else {
    .pktk_data$n[[pkg]] <- 1L
  }
  #pktk_unlock() ## for unlocking the saving on drive -> for future
  NULL
}
