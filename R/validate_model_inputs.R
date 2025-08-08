#' Validate input parameters for the simulation.
#'
#' @param run_number Integer representing index of current simulation run.
#' @param param List containing parameters for the simulation.
#'
#' @return Throws an error if any parameter is invalid.
#' @export

valid_inputs <- function(run_number, param) {
  check_run_number(run_number)
  check_log_file_path(param)
}


#' Checks if the run number is a non-negative integer.
#'
#' @param run_number Integer representing index of current simulation run.
#'
#' @return Throws an error if the run number is invalid.
#' @export

check_run_number <- function(run_number) {
  if (run_number < 0L || run_number %% 1L != 0L) {
    stop("The run number must be a non-negative integer. Provided: ",
         run_number, call. = FALSE)
  }
}

#' Check logging file path
#'
#' @param param List containing parameters for the simulation.
#'
#' @return None. Throws an error if valid file path not provided, when
#' log_to_file = TRUE.
#' @export

check_log_file_path <- function(param) {
  log_to_file <- param[["log_to_file"]]
  file_path <- param[["file_path"]]
  if (isTRUE(log_to_file) && (is.null(file_path) || !nzchar(file_path))) {
    stop(
      "If 'log_to_file' is TRUE, you must provide a non-NULL, ",
      "non-empty 'file_path'.",
      call. = FALSE
    )
  }
}
