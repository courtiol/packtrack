#' View the data
#'
#' This function display information about the usage of the packages.
#'
#' @export
#'
#' @examples
#'  pktk_view()
#'
pktk_view <- function() {
  ## extract last time a package has been used and set time zone:
  dat_time <- .pktk_data$time$data.frame()
  dat_time$Values <- format(dat_time$Values, tz =  Sys.timezone())

  ## extract number of times packages have been used:
  dat_n <- .pktk_data$n$data.frame()

  ## merge the last time info with the number of times info:
  dat <- merge(dat_time, dat_n, by = "Keys")

  ## prettify the output:
  colnames(dat) <- c("package", "last_loaded", "times_used")
  dat <- dat[order(dat$package), ]
  rownames(dat) <- NULL

  ## return the output:
  dat
}
