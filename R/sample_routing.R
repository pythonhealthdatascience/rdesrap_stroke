#' Sample a destination based on probabilities
#'
#' Randomly selects a destination from a list, where each destination has an
#' associated probability.
#'
#' @param prob_list Named list. The names are destination labels (character),
#' and the values are their corresponding probabilities (numeric, non-negative,
#' sum to 1).
#'
#' @return A character string. The name of the selected destination.
#' @export

sample_routing <- function(prob_list) {
  sample(seq_along(prob_list), size = 1L, prob = unlist(prob_list))
}
