#' Validate input parameters for the simulation.
#'
#' @param run_number Integer representing index of current simulation run.
#' @param param List containing parameters for the simulation.
#'
#' @return Throws an error if any parameter is invalid.
#' @export

valid_inputs <- function(run_number, param) {
  check_run_number(run_number)
  check_all_param_names(param)
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


#' Validate parameter names.
#'
#' Ensure that all required parameters are present, and no extra parameters are
#' provided.
#'
#' @param valid_names Character vector of valid argument names.
#' @param input_names Character vector of input parameter names.
#'
#' @return Throws an error if there are missing or extra parameters.
#' @export

check_param_names <- function(valid_names, input_names) {

  # Find missing keys (i.e. are there things in valid_names not in input)
  # and extra keys (i.e. are there things in input not in valid_names)
  missing_keys <- setdiff(valid_names, input_names)
  extra_keys <- setdiff(input_names, valid_names)

  # If there are any missing or extra keys, throw an error
  if (length(missing_keys) > 0L || length(extra_keys) > 0L) {
    error_message <- ""
    if (length(missing_keys) > 0L) {
      error_message <- paste0(
        error_message, "Missing keys: ", toString(missing_keys), ". "
      )
    }
    if (length(extra_keys) > 0L) {
      error_message <- paste0(
        error_message, "Extra keys: ", toString(extra_keys), ". "
      )
    }
    stop(error_message, call. = FALSE)
  }
}


#' Validate all parameter groups in a parameter list.
#'
#' This function checks that the top-level and all nested parameter lists have
#' the correct names.
#'
#' @param param List of parameter groups.
#'
#' @return Throws an error if any group has missing or extra parameters.
#' @export

check_all_param_names <- function(param) {

  # Validate top-level parameter names
  valid_top_names <- names(formals(create_parameters))
  input_top_names <- names(param)
  check_param_names(valid_names = valid_top_names,
                    input_names = input_top_names)

  # List of sub-parameter validation functions and their expected names
  param_validators <- list(
    asu_arrivals = create_asu_arrivals,
    rehab_arrivals = create_rehab_arrivals,
    asu_los = create_asu_los,
    rehab_los = create_rehab_los,
    asu_routing = create_asu_routing,
    rehab_routing = create_rehab_routing
  )

  # Validate each sub-parameter group, if present
  for (param_name in names(param_validators)) {
    valid_names <- names(param_validators[[param_name]]())
    input_names <- names(param[[param_name]])
    check_param_names(valid_names, input_names)
  }
}


#' Validate probability vector
#'
#' CHecks that values are between 0 and 1 (inclusive), that they sum to 1
#' (with tolerance of ±0.01).
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
  if (any(vec < 0 | vec > 1)) {
    stop('All values in routing vector "', name, '" must be between 0 and 1.',
         call. = FALSE)
  }
  if (sum(vec) < 0.99 || sum(vec) > 1.01) {
    stop('Values in routing vector "', name, '" must sum to 1 (±0.01).',
         call. = FALSE)
  }
}


#' Validate parameter values.
#'
#' Ensure that specific parameters are positive numbers, or non-negative
#' integers, and that probability vectors are in [0, 1] and sum to 1 (within
#' tolerance).
#'
#' @param param List containing parameters for the simulation.
#'
#' @return Throws an error if any specified parameter value is invalid.
#' @export

check_param_values <- function(param) {

  # Check that number of runs is positive integer
  if (
    !is.null("number_of_runs") &&
    "number_of_runs" <= 0L &&
    "number_of_runs" %% 1L == 0L
  ) {
    stop('The parameter "', p, '" must be integer greater than 0.',
         call. = FALSE)
  }

  # Check that listed parameters are not negative (i.e. must be 0+)
  non_neg <- c("asu_arrivals", "rehab_arrivals", "asu_los", "rehab_los")
  for (sub in non_neg) {
    if (!is.null(param[[sub]])) {
      vals <- unlist(param[[sub]])
      if (any(vals <= 0L)) {
        stop('All values in "', sub, '" must be greater than 0.', call. = FALSE)
      }
    }
  }

  # Check that listed parameters are non-negative integers
  n_list <- c("warm_up_period", "data_collection_period")
  for (n in n_list) {
    if (param[[n]] < 0L || param[[n]] %% 1L != 0L) {
      stop('The parameter "', n,
           '" must be an integer greater than or equal to 0.', call. = FALSE)
    }
  }

  # Check that listed parameters are between 0 and 1 and sum to 1 (+- 0.01)
  for (routing in c("asu_routing", "rehab_routing")) {
    for (name in names(param[[routing]])) {
      vec <- unlist(param[[routing]][[name]], use.names = FALSE)
      check_prob_vector(vec, paste0(routing, "$", name))
    }
  }
}
