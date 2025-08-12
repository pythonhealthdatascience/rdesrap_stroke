# Functional testing for the Discrete-Event Simulation (DES) Model.
#
# These verify that the system or components perform their intended
# functionality.


# -----------------------------------------------------------------------------
# Helper function
# -----------------------------------------------------------------------------


#' Update one or more probabilities in a routing parameter list.
#'
#' @param param The full model parameters list, as returned by [parameters()].
#' @param routing_name Character string naming the routing block within
#'   `param$dist_config` (e.g. `"asu_routing_tia"`).
#' @param updates Named numeric vector or list, where names are route names
#'   and values are the new probabilities to set.
#'
#' @return The modified `params_list` with the updated probability.

update_routing_prob <- function(param, routing_name, updates) {
  if (!routing_name %in% names(param$dist_config)) {
    stop(sprintf("Routing '%s' not found in param$dist_config", routing_name),
         call. = FALSE)
  }

  params_list <- param$dist_config[[routing_name]]$params

  if (is.null(names(updates)) || !all(nzchar(names(updates)))) {
    stop("'updates' must be a named vector or list", call. = FALSE)
  }

  for (route in names(updates)) {
    idx <- which(params_list$values == route)
    if (length(idx) != 1L) {
      stop(sprintf(
        "Expected exactly one match for route '%s', found %d",
        route, length(idx)
      ), call. = FALSE)
    }
    params_list$prob[[idx]] <- updates[[route]]
  }

  param$dist_config[[routing_name]]$params <- params_list
  param
}


# -----------------------------------------------------------------------------
# 1. Parameter validation
# -----------------------------------------------------------------------------

test_that("model errors for invalid asu_arrivals values", {
  param <- parameters()
  # Negative value for stroke
  param$dist_config$asu_arrival_stroke$params$mean <- -1L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_arrival_stroke$params$mean" must be greater than 0.',
    fixed = TRUE
  )
  # Zero value for neuro
  param <- parameters()
  param$dist_config$asu_arrival_neuro$params$mean <- 0L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_arrival_neuro$params$mean" must be greater than 0.',
    fixed = TRUE
  )
})


test_that("model errors for invalid asu_los values", {
  # Negative mean for stroke_no_esd
  param <- parameters()
  param$dist_config$asu_los_stroke_noesd$params$mean <- -5L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_los_stroke_noesd$params$mean" must be greater than 0.',
    fixed = TRUE
  )
  # Zero sd for tia
  param <- parameters()
  param$dist_config$asu_los_tia$params$sd <- 0L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_los_tia$params$sd" must be greater than 0.',
    fixed = TRUE
  )
})


test_that("model errors for invalid asu_routing probabilities", {
  param <- parameters()
  # Non-numeric value
  param <- update_routing_prob(param, "asu_routing_stroke", c(rehab = "a"))
  expect_error(
    model(param = param, run_number = 1L),
    'Routing vector "asu_routing_stroke$params$prob" must be numeric.',
    fixed = TRUE
  )
  # Probability out of bounds
  param <- parameters()
  param <- update_routing_prob(param, "asu_routing_stroke", c(rehab = -0.1))
  expect_error(
    model(param = param, run_number = 1L),
    'All values in routing vector "asu_routing_stroke$params$prob" must be between 0 and 1.',  # nolint: line_length_linter
    fixed = TRUE
  )
  # Probabilities do not sum to 1
  param <- parameters()
  param <- update_routing_prob(param, "asu_routing_stroke",
                               c(rehab = 0.5, esd = 0.5, other = 0.5))
  expect_error(
    model(param = param, run_number = 1L),
    'Values in routing vector "asu_routing_stroke$params$prob" must sum to 1 (+-0.01).',  # nolint: line_length_linter
    fixed = TRUE
  )
})


test_that("model errors for invalid rehab_routing probabilities", {
  # Probabilities should be within 0 and 1
  param <- parameters()
  param <- update_routing_prob(param, "rehab_routing_other", c(esd = 1.5))
  expect_error(
    model(param = param, run_number = 1L),
    'All values in routing vector "rehab_routing_other$params$prob" must be between 0 and 1.',  # nolint: line_length_linter
    fixed = TRUE
  )

  # Probabilities should sum to 1
  param <- parameters()
  param <- update_routing_prob(param, "rehab_routing_stroke",
                               c(esd = 0.8, other = 0.3))
  expect_error(
    model(param = param, run_number = 1L),
    'Values in routing vector "rehab_routing_stroke$params$prob" must sum to 1 (+-0.01)',  # nolint: line_length_linter
    fixed = TRUE
  )
})


patrick::with_parameters_test_that(
  "model errors for invalid, missing, and extra keys in parameters",
  {
    param <- parameters()
    param <- mod(param)
    expect_error(model(run_number = 0L, param = param), msg, fixed = TRUE)
  },
  patrick::cases(
    missing_number_of_runs = list(
      mod = function(p) {
        p$number_of_runs <- NULL
        p
      },
      msg = "Problem in param. Missing: number_of_runs. Extra: ."
    ),
    # Missing key in param$dist_config
    missing_rehab_arrival_neuro = list(
      mod = function(p) {
        p$dist_config$rehab_arrival_neuro <- NULL
        p
      },
      msg = "Problem in param$dist_config. Missing: rehab_arrival_neuro. Extra: ."  # nolint: line_length_linter
    ),
    # Missing specific dist_config key
    missing_rehab_los_tia = list(
      mod = function(p) {
        p$dist_config$rehab_los_tia$params <- NULL
        p
      },
      msg = "Missing required parameter(s) in param$dist_configrehab_los_tia: params. Allowed: class_name, params"  # nolint: line_length_linter
    ),
    # Extra key in top-level param
    extra_top_level = list(
      mod = function(p) {
        p$extra_key <- 5L
        p
      },
      msg = "Problem in param. Missing: . Extra: extra_key."
    ),
    # Extra key in param$dist_config
    extra_in_dist_config = list(
      mod = function(p) {
        p$dist_config$extra_key <- 5L
        p
      },
      msg = "Problem in param$dist_config. Missing: . Extra: extra_key."
    ),
    # Extra key in nested dist_config entry
    extra_in_asu_arrival_stroke = list(
      mod = function(p) {
        p$dist_config$asu_arrival_stroke$extra_key <- 5L
        p
      },
      msg = "Unrecognised parameter(s) in param$dist_configasu_arrival_stroke: extra_key. Allowed: class_name, params"  # nolint: line_length_linter
    )
  )
)

# -----------------------------------------------------------------------------
# 2. Run results
# -----------------------------------------------------------------------------

test_that("values are non-negative and not NA", {
  param <- parameters(
    warm_up_period = 20L, data_collection_period = 20L,
    cores = 1L, number_of_runs = 1L
  )
  results <- runner(param = param)

  # Check that at least one patient was processed
  expect_gt(nrow(results[["arrivals"]]), 0L)

  # Check that length of stay is greater than 0
  expect_true(all(results[["arrivals"]][["start_time"]] > 0L))

  # Check that there are no missing values
  expect_false(anyNA(
    results[["arrivals"]][c("name", "start_time", "resource", "replication")]
  ))
  expect_false(anyNA(results[["occupancy"]]))
  expect_false(anyNA(results[["occupancy_stats"]][["asu_bed"]]))
  expect_false(anyNA(results[["occupancy_stats"]][["rehab_bed"]]))
})


patrick::with_parameters_test_that(
  "adjusting parameters decreases arrivals",
  {
    # Set some defaults
    default_param <- parameters(
      warm_up_period = 100L, data_collection_period = 200L,
      cores = 1L, number_of_runs = 1L
    )

    # Set up parameter sets
    init_param <- default_param
    adj_param <- default_param
    init_param$dist_config[[group]]$params$mean <- init_value
    adj_param$dist_config[[group]]$params$mean <- adj_value

    # Run model and compare number of arrivals
    init_arrivals <- nrow(runner(param = init_param)[["arrivals"]])
    adj_arrivals <- nrow(runner(param = adj_param)[["arrivals"]])
    expect_gt(init_arrivals, adj_arrivals)
  },
  patrick::cases(
    list(group = "asu_arrival_stroke", init_value = 2L, adj_value = 6L),
    list(group = "rehab_los_stroke_noesd", init_value = 30L, adj_value = 10L)
  )
)


# -----------------------------------------------------------------------------
# 3. Seeds
# -----------------------------------------------------------------------------

test_that("the same seed returns the same result", {

  param <- parameters(
    warm_up_period = 20L, data_collection_period = 20L,
    cores = 1L, number_of_runs = 3L
  )

  # Run model twice using same run number (which will set the seed)
  same1 <- model(run_number = 0L, param = param)[["occupancy"]]
  same2 <- model(run_number = 0L, param = param)[["occupancy"]]
  expect_identical(same1, same2)

  # Conversely, if run with different run number, expect different
  diff <- model(run_number = 1L, param = param)[["occupancy"]]
  expect_failure(expect_identical(same1, diff))

  # Repeat experiment, but with multiple replications
  same_repeat1 <- runner(param = param)[["occupancy"]]
  same_repeat2 <- runner(param = param)[["occupancy"]]
  expect_identical(same_repeat1, same_repeat2)
})


test_that("model and runner produce same results if override future.seed", {

  param <- parameters(
    warm_up_period = 20L, data_collection_period = 20L,
    cores = 1L, number_of_runs = 3L
  )

  # Get result from runner, using future seeding
  futureseed_res <- runner(param, use_future_seeding = TRUE)[["occupancy"]]

  # Get results from runner - with run numbers as seeds (future seed = FALSE)
  runnumber_res <- runner(param, use_future_seeding = FALSE)[["occupancy"]]

  # Get results from model run in a loop
  model_res <- bind_rows(lapply(1L:param$number_of_runs, function(i) {
    model(run_number = i, param = param, set_seed = TRUE)[["occupancy"]]
  }))

  # Expect model to differ from runner with future seeding, but match other
  expect_failure(expect_identical(futureseed_res, model_res))
  expect_identical(runnumber_res, model_res)
})


# -----------------------------------------------------------------------------
# 4. Warm-up
# -----------------------------------------------------------------------------

test_that("results are as expected if model runs with only a warm-up", {

  # Run with only warm-up and no data collection period
  param <- parameters(
    warm_up_period = 100L, data_collection_period = 0L,
    cores = 1L, number_of_runs = 1L
  )
  result <- runner(param = param)

  # Arrivals should be empty
  expect_identical(nrow(result[["arrivals"]]), 0L)

  # Occupancy will have one record for each unit, from the final time of
  # warm-up (which would be the start of data collection, if existing)
  expect_identical(nrow(result[["occupancy"]]), 2L)
  expect_identical(nrow(result[["occupancy_stats"]][["asu_bed"]]), 1L)
  expect_identical(nrow(result[["occupancy_stats"]][["rehab_bed"]]), 1L)
})


test_that("running with warm-up leads to different results than without", {
  # Run without warm-up, expect first audit to have time and occupancy of 0
  param <- parameters(
    warm_up_period = 0L, data_collection_period = 20L,
    cores = 1L, number_of_runs = 1L
  )
  result <- runner(param = param)
  first_audit <- result[["occupancy"]] |>
    dplyr::arrange(time) |>
    dplyr::slice(1L:2L)
  expect_true(all(first_audit[["time"]] == 0L))
  expect_true(all(first_audit[["occupancy"]] == 0L))

  # Run with warm-up, expect first audit to have time and occupancy > 0
  param <- parameters(
    warm_up_period = 50L, data_collection_period = 20L,
    cores = 1L, number_of_runs = 1L
  )
  result <- runner(param = param)
  first_audit <- result[["occupancy"]] |>
    dplyr::arrange(time) |>
    dplyr::slice(1L:2L)
  expect_true(all(first_audit[["time"]] > 0L))
  expect_true(all(first_audit[["occupancy"]] > 0L))
})


# -----------------------------------------------------------------------------
# 5. Logs
# -----------------------------------------------------------------------------

test_that("log to console and file work correctly", {
  # Set parameters and create temporary file for log
  log_file <- tempfile(fileext = ".log")
  param <- parameters(
    warm_up_period = 0L,
    data_collection_period = 20L,
    log_to_console = TRUE,
    log_to_file = TRUE,
    file_path = log_file
  )

  # Check if "Parameters:" and "Log:" are in the console output
  expect_output(model(run_number = 1L, param = param),
                "Parameters:.*Log:", fixed = FALSE)

  # Check if "Parameters:" and "Log:" are in the file output
  expect_true(file.exists(log_file))
  expect_match(readLines(log_file), "Parameters:", all = FALSE)
  expect_match(readLines(log_file), "Log:", all = FALSE)
})
