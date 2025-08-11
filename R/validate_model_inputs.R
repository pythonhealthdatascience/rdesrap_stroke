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
  check_param_names(param)
  check_param_values(param)
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


#' Check parameter names.
#'
#' Ensure that all required parameters are present, and no extra parameters are
#' provided.
#'
#' @param param List containing parameters for the simulation.
#'
#' @importFrom jsonlite fromJSON
#'
#' @return None. Throws an error if there are missing or extra parameters.
#' @export

check_param_names <- function(param) {

  # Check the distribution names....
  # Import JSON with the required names
  config <- fromJSON(
    system.file("extdata", "parameters.json", package = "simulation"),
    simplifyVector = FALSE
  )[["simulation_parameters"]]
  required <- names(config)

  # Check what names are within param, if any missing or extra
  missing_names <- setdiff(required, names(param[["dist_config"]]))
  extra_names <- setdiff(names(param[["dist_config"]]), required)
  if (length(missing_names) > 0L || length(extra_names) > 0L)
    stop("Problem in param$dist_config. Missing: ", missing_names, ". ",
         "Extra: ", extra_names, call. = FALSE)

  # Check the names in param
  missing_names <- setdiff(names(parameters()), names(param))
  extra_names <- setdiff(names(param), names(parameters()))
  if (length(missing_names) > 0L || length(extra_names) > 0L)
    stop("Problem in param. Missing: ", missing_names, ". ",
         "Extra: ", extra_names, ".", call. = FALSE)
}


#' Validate probability vector
#'
#' Checks that values are between 0 and 1 (inclusive), that they sum to 1
#' (with tolerance of +-0.01).
#'
#' @param vec Numeric vector. The probability vector to be checked.
#' @param name Character string. The name or label for the vector, used in
#' error messages.
#'
#' @return Throws an error if the vector is invalid; otherwise, returns nothing.
#' @export

check_prob_vector <- function(vec, name) {
  if (!is.numeric(vec)) {
    stop('Routing vector "', name, '" must be numeric.', call. = FALSE)
  }
  if (any(vec < 0L | vec > 1L)) {
    stop('All values in routing vector "', name, '" must be between 0 and 1.',
         call. = FALSE)
  }
  if (sum(vec) < 0.99 || sum(vec) > 1.01) {
    stop('Values in routing vector "', name, '" must sum to 1 (+-0.01).',
         call. = FALSE)
  }
}


#' Check if a value is a positive integer
#'
#' Throws an error if the value is not a positive integer (> 0).
#'
#' @param x The value to check.
#' @param name The name of the parameter (for error messages).
#'
#' @return None. Throws an error if the check fails.
#' @export

check_positive_integer <- function(x, name) {
  if (is.null(x) || x <= 0L || x %% 1L != 0L) {
    stop(
      sprintf('The parameter "%s" must be an integer greater than 0.', name),
      call. = FALSE
    )
  }
}

#' Check if all values are positive
#'
#' Throws an error if any value in the input is not positive (> 0).
#'
#' @param x The vector or list of values to check.
#' @param name The name of the parameter (for error messages).
#'
#' @return None. Throws an error if the check fails.
#' @export

check_all_positive <- function(x, name) {
  if (!is.null(x) && any(unlist(x) <= 0L)) {
    stop(
      sprintf('All values in "%s" must be greater than 0.', name),
      call. = FALSE
    )
  }
}

#' Check if a value is a non-negative integer
#'
#' Throws an error if the value is not a non-negative integer (>= 0).
#'
#' @param x The value to check.
#' @param name The name of the parameter (for error messages).
#'
#' @return None. Throws an error if the check fails.
#' @export

check_nonneg_integer <- function(x, name) {
  if (is.null(x) || x < 0L || x %% 1L != 0L) {
    stop(
      sprintf('The parameter "%s" must be an integer >= 0.', name),
      call. = FALSE
    )
  }
}


#' Check that a parameter list contains only allowed names
#'
#' @param object_name String name of object (for error messages).
#' @param actual_names Character vector of parameter names.
#' @param allowed_names Character vector of allowed parameter names.
#'
#' @return None. Throws an error if unrecognised parameters are present.
#' @export

check_allowed_params <- function(object_name, actual_names, allowed_names) {
  extra_names  <- setdiff(actual_names, allowed_names)
  missing_names <- setdiff(allowed_names, actual_names)
  if (length(extra_names) > 0L) {
    stop("Unrecognised parameter(s) in ", object_name, ": ",
         paste(extra_names, collapse = ", "), ". Allowed: ",
         paste(allowed_names, collapse = ", "), call. = FALSE)
  }
  if (length(missing_names) > 0L) {
    stop("Missing required parameter(s) in ", object_name, ": ",
         paste(missing_names, collapse = ", "), ". Allowed: ",
         paste(allowed_names, collapse = ", "), call. = FALSE)
  }
}


#' Validate parameter values
#'
#' Ensures that specific parameters are positive numbers, non-negative integers,
#' and that probability vectors are in [0, 1] and sum to 1 (within tolerance).
#'
#' @param param List containing parameters for the simulation.
#'
#' @return None. Throws an error if any specified parameter value is invalid.
#' @export

check_param_values <- function(param) {

  # High-level parameters (runs, simulation run length)
  check_positive_integer(param[["number_of_runs"]], "number_of_runs")
  lapply(c("warm_up_period", "data_collection_period"),
         function(nm) check_nonneg_integer(param[[nm]], nm))

  # Loop through each distribution in dist_config
  for (dist_name in names(param$dist_config)) {
    entry  <- param$dist_config[[dist_name]]
    type   <- entry$class_name
    params <- entry$params

    check_allowed_params(object_name = paste0("param$dist_config", dist_name),
                         actual_names = names(entry),
                         allowed_names = c("class_name", "params"))

    if (type == "exponential") {
      check_all_positive(params$mean, paste0(dist_name, "$mean"))
      check_allowed_params(
        object_name = paste0("param$dist_config$", dist_name, "$params"),
        actual_names = names(params),
        allowed_names = c("mean")
      )
    }

    if (type == "lognormal") {
      check_all_positive(params$mean, paste0(dist_name, "$mean"))
      check_all_positive(params$sd,   paste0(dist_name, "$sd"))
      check_allowed_params(
        object_name = paste0("param$dist_config$", dist_name, "$params"),
        actual_names = names(params),
        allowed_names = c("mean", "sd")
      )
    }

    if (type == "discrete") {
      vals <- unlist(params$values)
      prob <- unlist(params$prob)
      if (length(vals) != length(prob)) {
        stop(sprintf("Discrete dist '%s' values and prob length mismatch",
                     dist_name), call. = FALSE)
      }
      check_prob_vector(prob, paste0(dist_name, "$prob"))
      check_allowed_params(
        object_name = paste0("param$dist_config$", dist_name, "$params"),
        actual_names = names(params),
        allowed_names = c("values", "prob")
      )
    }
  }
}
