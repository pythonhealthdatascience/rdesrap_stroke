# Functional testing for the Discrete-Event Simulation (DES) Model.
#
# These verify that the system or components perform their intended
# functionality.


# -----------------------------------------------------------------------------
# 1. Parameter validation
# -----------------------------------------------------------------------------

test_that("model errors for invalid asu_arrivals values", {
  param <- create_parameters()
  # Negative value for stroke
  param$asu_arrivals$stroke <- -1L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_arrivals" must be greater than 0.'
  )
  # Zero value for neuro
  param <- create_parameters()
  param$asu_arrivals$neuro <- 0L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_arrivals" must be greater than 0.'
  )
})


test_that("model errors for invalid asu_los values", {
  param <- create_parameters()
  # Negative mean for stroke_noesd
  param$asu_los$stroke_noesd$mean <- -5L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_los" must be greater than 0.'
  )
  # Zero sd for tia
  param <- create_parameters()
  param$asu_los$tia$sd <- 0L
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_los" must be greater than 0.'
  )
})


test_that("model errors for invalid asu_routing probabilities", {
  param <- create_parameters()
  # Non-numeric value
  param$asu_routing$stroke$rehab <- "a"
  expect_error(
    model(param = param, run_number = 1L),
    'Routing vector "asu_routing$stroke" must be numeric.',
    fixed = TRUE
  )
  # Probability out of bounds
  param <- create_parameters()
  param$asu_routing$stroke$rehab <- -0.1
  expect_error(
    model(param = param, run_number = 1L),
    'All values in routing vector "asu_routing$stroke" must be between 0 and 1.',  # nolint: line_length_linter
    fixed = TRUE
  )
  # Probabilities do not sum to 1
  param <- create_parameters()
  param$asu_routing$stroke$rehab <- 0.5
  param$asu_routing$stroke$esd <- 0.5
  param$asu_routing$stroke$other <- 0.5
  expect_error(
    model(param = param, run_number = 1L),
    'Values in routing vector "asu_routing$stroke" must sum to 1 (+-0.01).',
    fixed = TRUE
  )
})


test_that("model errors for invalid rehab_routing probabilities", {
  param <- create_parameters()
  param$rehab_routing$other$esd <- 1.5
  expect_error(
    model(param = param, run_number = 1L),
    'All values in routing vector "rehab_routing$other" must be between 0 and 1.',  # nolint: line_length_linter
    fixed = TRUE
  )
  # Probabilities do not sum to 1
  param <- create_parameters()
  param$rehab_routing$stroke$esd <- 0.8
  param$rehab_routing$stroke$other <- 0.3
  expect_error(
    model(param = param, run_number = 1L),
    'Values in routing vector "rehab_routing$stroke" must sum to 1 (+-0.01).',
    fixed = TRUE
  )
})


test_that("model errors for missing keys in asu_los", {
  param <- create_parameters()
  param$asu_los$other <- NULL  # Remove required key
  expect_error(
    model(param = param, run_number = 1L),
    "Missing keys: other."
  )
})


test_that("model errors for extra keys in asu_arrivals", {
  param <- create_parameters()
  param$asu_arrivals$extra <- 5L  # Add unexpected key
  expect_error(
    model(param = param, run_number = 1L),
    "Extra keys: extra."
  )
})


# -----------------------------------------------------------------------------
# 2. Run results
# -----------------------------------------------------------------------------

test_that("values are non-negative and not NA", {
  param <- create_parameters(
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
    default_param <- create_parameters(
      warm_up_period = 100L, data_collection_period = 200L,
      cores = 1L, number_of_runs = 1L
    )

    # Set up parameter sets
    init_param <- default_param
    adj_param <- default_param
    if (is.null(metric)) {
      init_param[[group]][[patient]] <- init_value
      adj_param[[group]][[patient]] <- adj_value
    } else {
      init_param[[group]][[patient]][[metric]] <- init_value
      adj_param[[group]][[patient]][[metric]] <- adj_value
    }

    # Run model and compare number of arrivals
    init_arrivals <- nrow(runner(param = init_param)[["arrivals"]])
    adj_arrivals <- nrow(runner(param = adj_param)[["arrivals"]])
    expect_gt(init_arrivals, adj_arrivals)
  },
  patrick::cases(
    list(group = "asu_arrivals", patient = "stroke", metric = NULL,
         init_value = 2L, adj_value = 6L),
    list(group = "rehab_los", patient = "stroke_noesd", metric = "mean",
         init_value = 30L, adj_value = 10L)
  )
)


# -----------------------------------------------------------------------------
# 3. Seeds
# -----------------------------------------------------------------------------

test_that("the same seed returns the same result", {

  param <- create_parameters(
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

  param <- create_parameters(
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
  param <- create_parameters(
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
  param <- create_parameters(
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
  param <- create_parameters(
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
  param <- create_parameters(
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
