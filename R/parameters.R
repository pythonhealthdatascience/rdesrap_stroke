#' Generate parameter list for simulation.
#'
#' @param parameter_file Path to parameters JSON file. Ignored if
#' parameter_config given.
#' @param parameter_config Optional list of parameters (overrides file).
#' @param warm_up_period Integer. Length of warm-up period (days).
#' @param data_collection_period Integer. Length of data collection period
#' (days).
#' @param number_of_runs Integer. Number of simulation runs.
#' @param scenario_name Label for scenario (int|float|string).
#' @param cores Integer. Number of CPU cores to use.
#' @param log_to_console Whether to print activity log to console.
#' @param log_to_file Whether to save activity log to file.
#' @param file_path Path to save log to file.
#'
#' @importFrom jsonlite fromJSON
#'
#' @return A named list of all simulation parameters.
#' @export

parameters <- function(
  parameter_file = NULL,
  parameter_config = NULL,
  warm_up_period = 365L * 3L,
  data_collection_period = 365L * 5L,
  number_of_runs = 150L,
  scenario_name = NULL,
  cores = 1L,
  log_to_console = FALSE,
  log_to_file = FALSE,
  file_path = NULL
) {
  # Load parameters
  if (!is.null(parameter_config)) {
    config <- parameter_config
  } else {
    if (is.null(parameter_file)) {
      parameter_file <- system.file(
        "extdata", "parameters.json", package = "simulation"
      )
    }
    config <- fromJSON(parameter_file, simplifyVector = FALSE)
  }

  # Handle simulation_parameters section in config
  if (!is.null(config$simulation_parameters)) {
    dist_config <- config$simulation_parameters
  } else {
    dist_config <- config
  }

  # Return parameter list (including NULL which will populate later)
  list(
    dist_config = dist_config,
    warm_up_period = warm_up_period,
    data_collection_period = data_collection_period,
    number_of_runs = number_of_runs,
    scenario_name = scenario_name,
    cores = cores,
    log_to_console = log_to_console,
    log_to_file = log_to_file,
    file_path = file_path,
    verbose = NULL,
    dist = NULL
  )
}

