#' Printing method for the object of class pktk
#'
#' @param x the object to be printed
#' @param ... not used but needed to define a printing method
#'
#' @export
#'
#' @method print pktk
#'
print.pktk <- function(x, ...) {

  cat("internal object storing the data required for packtrack...\n",
      "To see the collected data, please run pktk_view()")

  return(invisible(x))
}
