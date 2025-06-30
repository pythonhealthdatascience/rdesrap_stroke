# Functional testing for the Discrete-Event Simulation (DES) Model.
#
# These verify that the system or components perform their intended
# functionality.


test_that("values are non-negative", {
  # Run model with standard parameters
  param <- parameters()
  run_results <- model(run_number = 0L, param)[["run_results"]]

  # Check that at least one patient was processed
  expect_gt(run_results[["arrivals"]], 0L)

  # Check that the wait time is not negative
  expect_gte(run_results[["mean_waiting_time_nurse"]], 0L)

  # Check that the activity time and utilisation are greater than 0
  expect_gt(run_results[["mean_serve_time_nurse"]], 0L)
  expect_gt(run_results[["utilisation_nurse"]], 0L)
})


test_that("under high demand, utilisation is valid and last patient is unseen",
  {
    # Run model with high number of arrivals and only one nurse
    param <- parameters(
      number_of_nurses = 1L,
      patient_inter = 0.1,
      number_of_runs = 1L,
      cores = 1L
    )
    results <- runner(param)

    # Check that utilisation does not exceed 1 or drop below 0
    expect_lte(results[["run_results"]][["utilisation_nurse"]], 1L)
    expect_gte(results[["run_results"]][["utilisation_nurse"]], 0L)

    # Check that final patient is not seen by the nurse
    expect_identical(
      tail(results[["arrivals"]], 1L)[["end_time"]], NA_real_
    )
    expect_identical(
      tail(results[["arrivals"]], 1L)[["activity_time"]], NA_real_
    )
  }
)


test_that("under high demand + warm-up period, metrics are correct", {
  param <- parameters(
    patient_inter = 0.1,
    number_of_nurses = 1L,
    warm_up_period = 100L,
    data_collection_period = 10L
  )
  result <- model(run_number = 1L, param = param)

  # Check that no patients are seen in arrivals
  expect_true(all(is.na(result[["arrivals"]][["end_time"]])))
  expect_true(all(is.na(result[["arrivals"]][["activity_time"]])))
  expect_false(anyNA(result[["arrivals"]][["wait_time_unseen"]]))

  # Check that the first entry for each resource is at start of the data
  # collection period
  first_resources <- result[["resources"]] %>%
    group_by(resource) %>%
    slice(1L)
  expect_true(all(first_resources[["time"]] == param[["warm_up_period"]]))

  # Get the run result
  run_result <- result[["run_results"]][1L, ]

  # Check that count in run_results matches entries in arrivals
  expect_identical(run_result[["arrivals"]], nrow(result[["arrivals"]]))

  # Check that wait time and time with nurse are NaN (as these patients should
  # not have been seen, and we're not interested in warm-up patient times)
  expect_identical(run_result[["mean_waiting_time_nurse"]], NA_real_)
  expect_identical(run_result[["mean_serve_time_nurse"]], NA_real_)

  # Expect this to be 1, as nurses were busy for whole time (doesn't matter
  # what patient type they were busy with - in this case, warm-up patients).
  expect_identical(run_result[["utilisation_nurse"]], 1.0)
})


test_that("runner outputs a named list with length 2 and correct names", {
  # Simple run of the model
  param <- parameters(
    data_collection_period = 50L, number_of_runs = 1L, cores = 1L
  )
  results <- runner(param)

  # Check the structure
  expect_type(results, "list")
  expect_length(results, 4L)
  expect_named(results, c("arrivals", "resources",
                          "patients_in_service", "run_results"))

  # Check that arrivals and resources are dataframes
  expect_s3_class(results[["arrivals"]], "data.frame")
  expect_s3_class(results[["resources"]], "data.frame")
  expect_s3_class(results[["patients_in_service"]], "data.frame")
  expect_s3_class(results[["run_results"]], "data.frame")
})


patrick::with_parameters_test_that(
  "adjusting parameters decreases the wait time and utilisation",
  {
    # Set some defaults which will ensure sufficient arrivals/capacity to see
    # variation in wait time and utilisation
    default_param <- parameters(number_of_nurses = 4L,
                                patient_inter = 3L,
                                mean_n_consult_time = 15L,
                                data_collection_period = 200L,
                                number_of_runs = 1L)

    # Run model with initial value
    init_param <- default_param
    init_param[[param_name]] <- init_value
    init_results <- runner(init_param)[["run_results"]]

    # Run model with adjusted value
    adj_param <- default_param
    adj_param[[param_name]] <- adj_value
    adj_results <- runner(adj_param)[["run_results"]]

    # Check that waiting times in the adjusted model are lower
    expect_lt(adj_results[["mean_waiting_time_nurse"]],
              init_results[["mean_waiting_time_nurse"]])

    # Check that utilisation in the adjusted model is lower
    expect_lt(adj_results[["utilisation_nurse"]],
              init_results[["utilisation_nurse"]])
  },
  patrick::cases(
    list(param_name = "number_of_nurses", init_value = 3L, adj_value = 9L),
    list(param_name = "patient_inter", init_value = 2L, adj_value = 15L),
    list(param_name = "mean_n_consult_time", init_value = 30L, adj_value = 3L)
  )
)


patrick::with_parameters_test_that(
  "adjusting parameters reduces the number of arrivals",
  {
    # Set some default parameters
    default_param <- parameters(data_collection_period = 200L,
                                number_of_runs = 1L)

    # Run model with initial value
    init_param <- default_param
    init_param[[param_name]] <- init_value
    init_result <- model(run_number = 1L, init_param)[["run_results"]]

    # Run model with adjusted value
    adj_param <- default_param
    adj_param[[param_name]] <- adj_value
    adj_result <- model(run_number = 1L, adj_param)[["run_results"]]

    # Check that arrivals in the adjusted model are lower
    expect_lt(adj_result[["arrivals"]], init_result[["arrivals"]])
  },
  patrick::cases(
    list(param_name = "patient_inter", init_value = 2L, adj_value = 15L),
    list(param_name = "data_collection_period", init_value = 2000L,
         adj_value = 500L)
  )
)


test_that("the same seed returns the same result", {
  # Run model twice using same run number (which will set the seed)
  param <- parameters(number_of_runs = 5L)
  raw1 <- model(run_number = 0L, param = param)[["run_results"]]
  raw2 <- model(run_number = 0L, param = param)[["run_results"]]
  expect_identical(raw1, raw2)

  # Conversely, if run with different run number, expect different
  raw1 <- model(run_number = 0L, param = param)[["run_results"]]
  raw2 <- model(run_number = 1L, param = param)[["run_results"]]
  expect_failure(
    expect_identical(raw1, raw2)
  )

  # Repeat experiment, but with multiple replications
  raw1 <- runner(param = param)[["run_results"]]
  raw2 <- runner(param = param)[["run_results"]]
  expect_identical(raw1, raw2)
})


test_that("columns that are expected to be complete have no NA", {
  # Run model with low resources and definite arrivals
  param <- parameters(
    number_of_nurses = 1L,
    data_collection_period = 300L,
    patient_inter = 1L
  )
  results <- model(run_number = 1L, param)

  # Helper function to remove columns where expect NA and then check that
  # remaining dataframe has no NA
  check_no_na <- function(data, exclude = NULL) {
    if (!is.null(exclude)) {
      data <- data[, !names(data) %in% exclude]
    }
    expect_true(all(colSums(is.na(data)) == 0L))
  }

  # Check raw and processed results, excluding columns where expect NA
  check_no_na(results[["arrivals"]],
              exclude = c("end_time", "activity_time", "serve_start",
                          "serve_length", "wait_time", "wait_time_unseen"))
  check_no_na(results[["resources"]])
  check_no_na(results[["run_results"]])
})


test_that("all patients are seen when there are plenty nurses", {
  # Run model with extremely large number of nurses
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 10000000L,
    data_collection_period = 100L,
    number_of_runs = 1L
  )
  result <- runner(param)[["run_results"]]

  # Check that no patients wait
  expect_identical(result[["mean_waiting_time_nurse"]], 0.0)
  expect_identical(result[["count_unseen_nurse"]], 0L)
  expect_true(is.na(result[["mean_waiting_time_unseen_nurse"]]))
})


test_that("the model can cope with having no arrivals", {
  # Run with extremely high inter-arrival time and short length
  param <- parameters(patient_inter = 99999999L, data_collection_period = 10L)
  result <- model(run_number = 1L, param = param)

  # Check that the raw result are two empty dataframes
  expect_identical(nrow(result[["arrivals"]]), 0L)
  expect_identical(nrow(result[["resources"]]), 0L)

  # Check that the processed result is dataframe with one row, two columns,
  # with just the run number and no arrivals
  expected_run_results <- tibble(replication = 1L, arrivals = 0L)
  expect_identical(result[["run_results"]], expected_run_results)
})


test_that("the model can cope with some replications having no arrivals", {
  # Run model with conditions that will ensure some replications see an arrival,
  # and some do not
  param <- parameters(
    patient_inter = 200L,
    data_collection_period = 100L,
    number_of_runs = 5L
  )

  # Run for replications and process results
  run_result <- runner(param)[["run_results"]]

  # Check there are rows for each replication
  expect_identical(nrow(run_result), param[["number_of_runs"]])

  # Check that arrivals is either 0 or 1 (with at least one of each)
  expect_true(all(run_result[["arrivals"]] %in% c(0L, 1L)))
  expect_true(any(run_result[["arrivals"]] == 0L))
  expect_true(any(run_result[["arrivals"]] == 1L))
})


test_that("results are empty if model runs with only a warm-up", {
  # Run model with only a warm-up period and no time for results collection
  param <- parameters(warm_up_period = 50L, data_collection_period = 0L)
  result <- model(run_number = 1L, param = param)

  # Check that arrivals and resources are empty
  expect_identical(nrow(result[["arrivals"]]), 0L)
  expect_identical(nrow(result[["resources"]]), 0L)

  # Check that run results records 0 arrivals
  expected_run_results <- tibble(replication = 1L, arrivals = 0L)
  expect_identical(result[["run_results"]], expected_run_results)
})


test_that("running with warm-up leads to different results than without", {
  # Helper function to run model with high arrivals and specified warm-up
  helper_warmup <- function(warm_up_period) {
    param <- parameters(patient_inter = 1L,
                        mean_n_consult_time = 10L,
                        number_of_nurses = 5L,
                        warm_up_period = warm_up_period,
                        data_collection_period = 80L)
    model(run_number = 1L, param = param)
  }

  # Run model with and without warm-up period
  results_warmup <- helper_warmup(warm_up_period = 50L)
  results_none <- helper_warmup(warm_up_period = 0L)

  # With warm-up, check that first arrival has:
  # > Start time in data collection period
  # > Queue time greater than 0 (as we have run scenario with backlog where
  # expect resources to still be in use by warm-up patients)
  first_patient <- results_warmup[["arrivals"]] %>%
    arrange(start_time) %>%
    mutate(wait_time = end_time - activity_time) %>%
    slice(1L)
  expect_gt(first_patient[["start_time"]], 50L)
  expect_gt(first_patient[["wait_time"]], 0L)

  # Without warm-up, check that first arrival has:
  # > Start time after 0
  # > Queue time equal to 0
  first_patient <- results_none[["arrivals"]] %>%
    arrange(start_time) %>%
    mutate(wait_time = round(end_time - activity_time - start_time, 10L)) %>%
    slice(1L)
  expect_gt(first_patient[["start_time"]], 0L)
  expect_identical(first_patient[["wait_time"]], 0.0)

  # Comparing the results, expect warm-up to have:
  # > Longer mean wait time
  # > Higher utilisation
  # > Higher count unseen
  # > Higher mean wait time unseen
  run_wu <- results_warmup[["run_results"]]
  run_none <- results_none[["run_results"]]
  expect_gt(run_wu[["mean_waiting_time_nurse"]],
            run_none[["mean_waiting_time_nurse"]])
  expect_gt(run_wu[["utilisation_nurse"]],
            run_none[["utilisation_nurse"]])
  expect_gt(run_wu[["count_unseen_nurse"]],
            run_none[["count_unseen_nurse"]])
  expect_gt(run_wu[["mean_waiting_time_unseen_nurse"]],
            run_none[["mean_waiting_time_unseen_nurse"]])
})


test_that("log to console and file work correctly", {
  # Set parameters and create temporary file for log
  log_file <- tempfile(fileext = ".log")
  param <- parameters(
    mean_n_consult_time = 10L,
    patient_inter = 5L,
    number_of_nurses = 1L,
    warm_up_period = 0L,
    data_collection_period = 10L,
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


test_that("check that calculated times are consistent with one another", {
  param <- parameters(
    patient_inter = 1L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 0L,
    data_collection_period = 80L
  )
  result <- model(1L, param)


  # Filter to patients who started service with a nurse but did not complete
  # before the end of the simulation
  incomplete <- result[["arrivals"]] %>%
    filter(is.na(end_time)) %>%
    filter(!is.na(serve_start))

  # Check that they are excluded from wait time unseen
  expect_true(all(is.na(incomplete[["wait_time_unseen"]])))

  # Check that all have a wait time greater than 0
  expect_true(all(incomplete[["wait_time"]] > 0L))

  # Check that their service started after having seized the resource
  expect_true(all(incomplete[["start_time"]] < incomplete[["serve_start"]]))

  # Check that their service ended after the end of the simulation
  expect_true(all(incomplete[["serve_start"]] + incomplete[["serve_length"]]
                  > param[["data_collection_period"]]))


  # Filter to patients who completed a the nurse service before the end
  complete <- result[["arrivals"]] %>%
    filter(!is.na(end_time))

  # Check that they are excluded from wait time unseen
  expect_true(all(is.na(complete[["wait_time_unseen"]])))

  # Check that all have result in wait_time (0+)
  expect_false(anyNA(complete[["wait_time"]]))

  # For those with no wait, check that start_time and activity_time align with
  # the calculated serve times
  complete_no_wait <- filter(complete, wait_time == 0L)
  expect_identical(complete_no_wait[["start_time"]],
                   complete_no_wait[["serve_start"]])
  expect_identical(complete_no_wait[["activity_time"]],
                   complete_no_wait[["serve_length"]])

  # For those with a wait, check that start_time < serve_start
  complete_wait <- filter(complete, wait_time > 0L)
  expect_true(all(complete_wait[["start_time"]] <
                    complete_wait[["serve_start"]]))

  # Filter to patients who are never seen
  unseen <- result[["arrivals"]] %>%
    filter(is.na(serve_start))

  # Check that all have a result for wait_time_unseen
  expect_false(anyNA(unseen[["wait_time_unseen"]]))
})


test_that("the count of unseen patients and mean unseen wait are consistent", {
  # Run the model with parameters that we expect to mean some replications
  # have no unseen patients
  param <- parameters(
    patient_inter = 3L,
    mean_n_consult_time = 10L,
    number_of_nurses = 6L,
    data_collection_period = 80L,
    number_of_runs = 10L,
    cores = 1L
  )
  result <- runner(param)[["run_results"]]

  # Check that replications with no unseen patients have no result for
  # unseen wait time
  no_unseen <- filter(result, count_unseen_nurse == 0L)
  expect_true(all(is.na(no_unseen[["mean_waiting_time_unseen_nurse"]])))

  # Check that replications with some unseen patients have a result for
  # unseen wait time
  some_unseen <- filter(result, count_unseen_nurse > 0L)
  expect_true(all(some_unseen[["mean_waiting_time_unseen_nurse"]] > 0L))
})


test_that("model and runner produce same results if override future.seed", {
  # Specify parameters
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 0L,
    data_collection_period = 80L,
    number_of_runs = 5L
  )

  # Get results from runner - overriding future seeding to use run numbers
  # to use run numbers as seeds
  runner_res <- runner(param, use_future_seeding = FALSE)[["run_results"]]

  # Get results from model run in a loop
  model_res <- bind_rows(lapply(1L:param$number_of_runs, function(i) {
    model(run_number = i, param = param, set_seed = TRUE)[["run_results"]]
  }))

  # Compare the results
  expect_equal(runner_res, model_res) # nolint: expect_identical_linter
})
