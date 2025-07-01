#' Run simulation.
#'
#' @param run_number Integer representing index of current simulation run.
#' @param param Named list of model parameters.
#' @param set_seed Whether to set seed within the model function (which we
#' may not wish to do if being set elsewhere - such as done in \code{runner()}).
#' Default is TRUE.
#'
#' @importFrom simmer get_mon_arrivals get_mon_resources simmer wrap
#' @importFrom utils capture.output
#'
#' @return TBC
#' @export

model <- function(run_number, param, set_seed = TRUE) {

  # Set random seed based on run number
  if (set_seed) {
    set.seed(run_number)
  }

  # Determine whether to get verbose activity logs
  verbose <- any(c(param[["log_to_console"]], param[["log_to_file"]]))

  # Transform LOS parameters to lognormal scale
  param[["asu_los_lnorm"]] <- transform_to_lnorm(param[["asu_los"]])
  param[["rehab_los_lnorm"]] <- transform_to_lnorm(param[["rehab_los"]])

  # Create simmer environment
  env <- simmer("simulation", verbose = verbose)

  # Add ASU and rehab direct admission patient generators
  for (unit in c("asu", "rehab")) {
    for (patient_type in names(param[[paste0(unit, "_arrivals")]])) {

      # Create patient trajectory
      traj <- if (unit == "asu") {
        create_asu_trajectory(env, patient_type, param)
      } else {
        create_rehab_trajectory(env, patient_type, param)
      }

      # Add patient generator using the created trajectory
      sim_log <- capture.output(
        env <- add_patient_generator(
          env = env,
          trajectory = traj,
          unit = unit,
          patient_type = patient_type,
          param = param
        )
      )
    }
  }

  # Run the model
  sim_log <- capture.output(
    env <- env |>
      simmer::run(20L) |>
      wrap()
  )

  # Save and/or display the log
  if (isTRUE(verbose)) {
    # Create full log message by adding parameters
    param_string <- paste(names(param), param, sep = "=", collapse = ";\n ")
    full_log <- append(c("Parameters:", param_string, "Log:"), sim_log)
    # Print to console
    if (isTRUE(param[["log_to_console"]])) {
      print(full_log)
    }
    # Save to file
    if (isTRUE(param[["log_to_file"]])) {
      writeLines(full_log, param[["file_path"]])
    }
  }

  # Extract the monitored arrivals and resources information from the simmer
  # environment object
  result <- list(
    arrivals = get_mon_arrivals(env, per_resource = TRUE, ongoing = TRUE),
    resources = get_mon_resources(env)
  )

  return(result)
}
