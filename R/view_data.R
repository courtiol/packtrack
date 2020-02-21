#' View the data
#'
#' This function display information about the usage of the packages.
#'
#' @param include_non_used a boolean indicating whether to add (TRUE) or not
#' (FALSE, default) information about user packages not recorded during
#' tracking.
#'
#' @export
#'
#' @examples
#'  pktk_view()
#'
pktk_view <- function(include_non_used = FALSE) {
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

  ## include non used packages
  if (include_non_used) {
    all_pkg <- data.frame(package = dir(.libPaths()))
    dat <- merge(all_pkg[!all_pkg$package %in% dat$package, , drop = FALSE],
                 dat, by = "package", all = TRUE)
    dat$times_used[is.na(dat$times_used)] <- 0
  }

  ## return the output:
  dat
}

