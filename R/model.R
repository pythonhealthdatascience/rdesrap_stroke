#' Run simulation.
#'
#' @param run_number Integer representing index of current simulation run.
#' @param param Named list of model parameters.
#' @param set_seed Whether to set seed within the model function (which we
#' may not wish to do if being set elsewhere - such as done in runner()).
#' Default is TRUE.
#'
#' @importFrom simmer get_attribute get_mon_arrivals get_mon_resources
#' @importFrom simmer set_attribute simmer timeout wrap
#'
#' @return TBC
#' @export

model <- function(run_number, param, set_seed = TRUE) {

  # Set random seed based on run number
  if (set_seed) {
    set.seed(run_number)
  }

  # Create simmer environment
  env <- simmer("simulation", verbose = TRUE)

  # Add ASU and rehab direct admission patient generators
  for (unit in c("asu", "rehab")) {
    for (patient_type in names(param[[paste0(unit, "_arrivals")]])) {
      env <- add_patient_generator(
        env = env,
        # Get trajectory given unit and patient type
        trajectory = (
          if (unit == "asu") create_asu_trajectory(patient_type, param)
          else create_rehab_trajectory(patient_type, param)
        ),
        unit = unit,
        patient_type = patient_type,
        param = param
      )
    }
  }

  # Run the model
  env <- env |>
    simmer::run(20L) |>
    wrap()

  # Extract the monitored arrivals and resources information from the simmer
  # environment object
  result <- list(
    arrivals = get_mon_arrivals(env, per_resource = TRUE, ongoing = TRUE),
    resources = get_mon_resources(env)
  )

  return(result)
}
