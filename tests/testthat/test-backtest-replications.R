# Back testing for objects in choose_replications.R

test_that("results from confidence_interval_method are consistent", {
  # Specify parameters (so consistent even if defaults change)
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 0L,
    data_collection_period = 80L
  )

  # Run the confidence_interval_method()
  rep_results <- suppressWarnings(confidence_interval_method(
    replications = 15L,
    desired_precision = 0.1,
    metric = "mean_serve_time_nurse",
    verbose = FALSE
  ))

  # Import the expected results
  exp_results <- read.csv(test_path("testdata", "choose_rep_results.csv"))

  # Compare to those generated
  expect_equal(rep_results, exp_results) # nolint: expect_identical_linter
})


test_that("results from ReplicationsAlgorithm are consistent", {
  # Specify parameters (so consistent even if defaults change)
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 0L,
    data_collection_period = 80L
  )

  # Run the confidence_interval_method()
  alg <- ReplicationsAlgorithm$new(
    param = param,
    metrics = "mean_serve_time_nurse",
    desired_precision = 0.1,
    initial_replications = 15L,
    look_ahead = 0L,
    replication_budget = 15L,
    verbose = FALSE
  )
  suppressWarnings(alg$select())
  rep_results <- alg$summary_table

  # Import the expected results
  exp_results <- read.csv(test_path("testdata", "choose_rep_results.csv"))

  # Compare to those generated
  expect_equal(rep_results, exp_results) # nolint: expect_identical_linter
})
