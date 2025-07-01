#' Create rehab patient trajectory.
#'
#' Represents patient stay on the rehabilitation unit - samples their (1)
#' destination after rehab, and (2) length of stay (LOS) on the unit.
#'
#' @param env Simmer environment object. The simulation environment where
#' generators will be added.
#' @param patient_type Character string specifying patient category. Must be
#' one of: "stroke", "tia", "neuro", or "other". Determines which arrival rate
#' parameter is used.
#' @param param Nested list containing simulation parameters. Must have
#' structure \code{param$rehab_routing$<patient_type>} containing the
#' probability of routing to each destination (e.g.
#' \code{param$rehab_routing$stroke$esd = 0.40}).
#'
#' @importFrom simmer get_attribute log_ set_attribute timeout trajectory
#' @importFrom stats rlnorm
#'
#' @return Simmer trajectory object. Defines patient journey logic through the
#' healthcare system.
#' @export

create_rehab_trajectory <- function(env, patient_type, param) {

  # Set up simmer trajectory object...
  trajectory(paste0("rehab_", patient_type, "_path")) |>

    log_("🚶 Arrived at rehab") |>

    # Sample destination after rehab (as destination influences length of stay)
    set_attribute("post_rehab_destination", function() {
      sample_routing(prob_list = param[["rehab_routing"]][[patient_type]])
    }) |>

    log_(function() {
      # Retrieve attribute, and use to get post-rehab destination as a string
      dest_index <- get_attribute(env, "post_rehab_destination")
      dest_names <- names(param[["rehab_routing"]][[patient_type]])
      dest <- dest_names[dest_index]
      # Create log message
      paste0("🎯 Planned rehab -> ", dest_index, " (", dest, ")")
    }) |>

    set_attribute("rehab_los", function() {
      # Retrieve attribute, and use to get post-rehab destination as a string
      dest_index <- get_attribute(env, "post_rehab_destination")
      dest_names <- names(param[["rehab_routing"]][[patient_type]])
      dest <- dest_names[dest_index]

      # Determine which LOS distribution to use
      if (patient_type == "stroke") {
        los_params <- switch(
          dest,
          esd = param[["rehab_los_lnorm"]][["stroke_esd"]],
          other = param[["rehab_los_lnorm"]][["stroke_noesd"]],
          stop("Stroke post-rehab destination '", dest, "' invalid",
               call. = FALSE)
        )
      } else {
        los_params <- param[["rehab_los_lnorm"]][[patient_type]]
      }

      # Sample LOS from lognormal
      rlnorm(
        n = 1L,
        meanlog = los_params[["meanlog"]],
        sdlog = los_params[["sdlog"]]
      )
    }) |>

    log_(function() {
      paste0("⏳ Rehab length of stay: ",
             round(get_attribute(env, "rehab_los"), 3L))
    }) |>

    timeout(function() get_attribute(env, "rehab_los")) |>

    log_("🏁 Rehab stay completed")
}
