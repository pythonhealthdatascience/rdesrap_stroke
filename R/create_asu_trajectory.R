#' Create acute stroke unit (ASU) patient trajectory.
#'
#' Represents patient stay in the ASU - samples their (1) destination after
#' the ASU, and (2) length of stay (LOS) on the ASU.
#'
#' @param env Simmer environment object. The simulation environment where
#' generators will be added.
#' @param patient_type Character string specifying patient category. Must be
#' one of: "stroke", "tia", "neuro", or "other". Determines which arrival rate
#' parameter is used.
#' @param param Nested list containing simulation parameters. Must have
#' structure \code{param$asu_routing$<patient_type>} containing the probability
#' of routing to each destination (e.g.
#' \code{param$asu_routing$stroke$rehab = 0.24}).
#'
#' @importFrom simmer branch trajectory
#' @importFrom stats rlnorm
#'
#' @return Simmer trajectory object. Defines patient journey logic through the
#' healthcare system.
#' @export

create_asu_trajectory <- function(env, patient_type, param) {

  # Set up simmer trajectory object...
  trajectory(paste0("ASU_", patient_type, "_path")) |>

    # Sample destination after ASU (as destination influences length of stay)
    set_attribute("post_asu_destination", function() {
      sample_routing(prob_list = param[["asu_routing"]][[patient_type]])
    }) |>

    timeout(function() {

      # Retrieve attribute, and use to get post-ASU destination as a string
      dest_index <- get_attribute(env, "post_asu_destination")
      dest_names <- names(param[["asu_routing"]][[patient_type]])
      dest <- dest_names[dest_index]

      # Determine which LOS distribution to use
      if (patient_type == "stroke") {
        los_params <- switch(
          dest,
          esd = param[["asu_los_lnorm"]][["stroke_esd"]],
          rehab = param[["asu_los_lnorm"]][["stroke_noesd"]],
          other = param[["asu_los_lnorm"]][["stroke_mortality"]],
          stop("Stroke post-asu destination '", dest, "' invalid",
               call. = FALSE)
        )
      } else {
        los_params <- param[["asu_los_lnorm"]][[patient_type]]
      }

      # Sample LOS from lognormal
      rlnorm(
        n = 1L,
        meanlog = los_params[["meanlog"]],
        sdlog = los_params[["sdlog"]]
      )
    }) |>

    # If that patient's destination is rehab, then start on that trajectory
    branch(
      option = function() {
        # Retrieve attribute, and use to get post-ASU destination as a string
        dest_index <- get_attribute(env, "post_asu_destination")
        dest_names <- names(param[["asu_routing"]][[patient_type]])
        dest <- dest_names[dest_index]
        # Return 1 for rehab and 0 otherwise
        if (dest == "rehab") 1L else 0L
      },
      continue = FALSE,  # Do not continue main trajectory after branch
      create_rehab_trajectory(env, patient_type, param)
    )
}
