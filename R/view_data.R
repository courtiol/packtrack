#' View the data
#'
#' This function displays information about the usage of the packages.
#'
#' @param previously_loaded boolean indicating whether to add (TRUE) or not
#' (FALSE) information about packages that were already loaded before
#' that the tracking was activated. This includes for instance the packtrack package
#' itself. Default is to do the same as the argument selected for non_used.
#'
#' @param non_used a boolean indicating whether to add (TRUE) or not
#' (FALSE, default) information about packages not recorded during tracking.
#'
#'
#'
#' @export
#'
#'
packtrack_view <- function(previously_loaded = non_used, non_used = FALSE) {

  ## check that .packtrack_data is present (not the case if packtrack has been stopped with option delete_cache = TRUE):
  if (!exists(".packtrack_data")) {
    stop("You must activate packtrack to use this function; call packtrack_start() to do so.")
  }

  ## extract last time a package has been used and set time zone:
  dat_time <- .packtrack_data$time$data.frame()
  dat_time$Values <- format(dat_time$Values, tz =  Sys.timezone())

  ## extract number of times packages have been used:
  dat_n <- .packtrack_data$n$data.frame()

  ## merge the last time info with the number of times info:
  dat <- merge(dat_time, dat_n, by = "Keys")

  ## prettify the output:
  colnames(dat) <- c("package", "last_loaded", "times_loaded")
  dat <- dat[order(dat$package), ]
  rownames(dat) <- NULL

  ## include previously loaded packages:
  if (previously_loaded) {
    loaded_pkg <- data.frame(package = loadedNamespaces(), last_loaded = NA,  times_loaded = 1)
    loaded_pkg_missing <- loaded_pkg[!loaded_pkg$package %in% dat$package, ]
    dat <- merge(dat, loaded_pkg_missing, all.x = TRUE, all.y = TRUE)
  }

  ## include non-used packages:
  if (non_used) {
    if (!previously_loaded) {
      stop("Using non_used = TRUE together with previously_loaded = FALSE would not make sense because packages already loaded when the tracking has started would be considered as never used. Consider changing the input of the function!")
    }
    all_pkg <- data.frame(package = dir(.libPaths()), last_loaded = NA,  times_loaded = 0)
    all_pkg_missing <- all_pkg[!all_pkg$package %in% dat$package, ]
    dat <- merge(all_pkg_missing, dat, all.x = TRUE, all.y = TRUE)
  }

  ## return the output:
  dat
}

