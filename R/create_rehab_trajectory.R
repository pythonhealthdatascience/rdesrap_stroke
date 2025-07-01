#' Create rehab patient trajectory
#'
#' @param patient_type Character string specifying patient category. Must be
#' one of: "stroke", "tia", "neuro", or "other". Determines which arrival rate
#' parameter is used.
#' @param param Nested list containing simulation parameters. Must have
#' structure `param$asu_routing$<patient_type>` containing the probability of
#' routing to each destination (e.g.`param$asu_routing_stroke$rehab = 0.24`).
#'
#' @importFrom simmer trajectory
#'
#' @return Simmer trajectory object. Defines patient journey logic through the
#' healthcare system.
#' @export

create_rehab_trajectory <- function(patient_type, param) {
  trajectory(paste0("rehab_", patient_type, "_path")) |>
    timeout(1L)
}
