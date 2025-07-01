#' Run simulation.
#'
#' @param run_number Integer representing index of current simulation run.
#' @param param Named list of model parameters.
#' @param set_seed Whether to set seed within the model function (which we
#' may not wish to do if being set elsewhere - such as done in runner()).
#' Default is TRUE.
#'
#' @importFrom simmer add_generator get_mon_arrivals get_mon_resources simmer
#' @importFrom simmer timeout trajectory wrap
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

  # Define the stroke patient trajectory
  stroke_patient <- trajectory("stroke_patient_path") |>
    timeout(1)

  # Add patient generator
  env <- env |>
    add_generator("stroke_patient", stroke_patient, function () {
      rexp(n = 1L, rate = 1L / param[["asu_arrivals"]][["stroke"]])
    }) |>
    simmer::run(20) |>
    wrap()

  # Extract the monitored arrivals and resources information from the simmer
  # environment object
  result <- list(
    arrivals = get_mon_arrivals(env, per_resource = TRUE, ongoing = TRUE),
    resources = get_mon_resources(env)
  )

  return(result)
}
