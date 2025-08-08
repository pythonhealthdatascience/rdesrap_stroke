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
#' @importFrom simmer branch get_attribute log_ release seize set_attribute
#' @importFrom simmer timeout trajectory
#' @importFrom stats rlnorm
#'
#' @return Simmer trajectory object. Defines patient journey logic through the
#' healthcare system.
#' @export

create_asu_trajectory <- function(env, patient_type, param) {

  # Set up simmer trajectory object...
  trajectory(paste0("ASU_", patient_type, "_path")) |>

    log_("\U0001F6B6 Arrived at ASU", level = 1L) |>

    seize("asu_bed", 1L) |>

    # Sample destination after ASU (as destination influences length of stay)
    set_attribute("post_asu_destination", function() {
      param[["dist"]][["routing"]][["asu"]][[patient_type]]()
    }) |>

    log_(function() {
      dest <- get_attribute(env, "post_asu_destination")
      paste0("\U0001F3AF Planned ASU -> ", dest)
    }, level = 1L) |>

    # Sample ASU LOS. For stroke patients, LOS distribution is based on
    # the planned destination after the ASU.
    set_attribute("asu_los", function() {
      dest <- get_attribute(env, "post_asu_destination")
      if (patient_type == "stroke") {
        switch(
          dest,
          esd = param[["dest"]][["los"]][["asu"]][["stroke_esd"]],
          rehab = param[["dest"]][["los"]][["asu"]][["stroke_no_esd"]],
          other = param[["dest"]][["los"]][["asu"]][["stroke_mortality"]],
          stop("Stroke post-asu destination '", dest, "' invalid",
               call. = FALSE)
        )
      } else {
        param[["dest"]][["los"]][["asu"]][[patient_type]]()
      }
    }) |>

    log_(function() {
      paste0("\U000023F3 ASU length of stay: ",
             round(get_attribute(env, "asu_los"), 3L))
    }, level = 1L) |>

    timeout(function() get_attribute(env, "asu_los")) |>

    log_("\U0001F3C1 ASU stay completed", level = 1L) |>

    release("asu_bed", 1L) |>

    # If that patient's destination is rehab, then start on that trajectory
    branch(
      option = function() {
        if (get_attribute(env, "post_asu_destination") == "rehab") 1L else 0L
      },
      continue = FALSE,  # Do not continue main trajectory after branch
      create_rehab_trajectory(env, patient_type, param)
    )
}
