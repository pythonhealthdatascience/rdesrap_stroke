# Back testing for the Discrete-Event Simulation (DES) Model.
#
# These check that the model code produces results consistent with prior code.


test_that("results from a new run match those previously generated", {
  # Choose a specific set of parameters (ensuring test remains on the same
  # set, regardless of any changes to parameters()) and run replications
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 0L,
    data_collection_period = 80L,
    number_of_runs = 10L,
    cores = 1L
  )
  results <- runner(param)

  # Convert to logical (which is how it imports)
  results[["run_results"]][["mean_waiting_time_unseen_nurse"]] <- as.logical(
    results[["run_results"]][["mean_waiting_time_unseen_nurse"]]
  )

  # Import the expected results
  exp_arrivals <- read.csv(test_path("testdata", "base_arrivals.csv"))
  exp_resources <- read.csv(test_path("testdata", "base_resources.csv"))
  exp_run_results <- read.csv(test_path("testdata", "base_run_results.csv"))

  # Compare results
  # nolint start: expect_identical_linter
  expect_equal(arrange(results[["arrivals"]], name),
               arrange(exp_arrivals, name))
  expect_equal(as.data.frame(results[["resources"]]), exp_resources)
  expect_equal(as.data.frame(results[["run_results"]]), exp_run_results)
  # nolint end: expect_identical_linter
})


test_that("results from a new run match those previously generated", {
  # Choose a specific set of parameters (ensuring test remains on the same
  # set, regardless of any changes to parameters())
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 40L,
    data_collection_period = 80L,
    number_of_runs = 10L,
    cores = 1L
  )

  # Run the replications then get the monitored arrivals and resources
  results <- as.data.frame(runner(param)[["run_results"]])

  # Import the expected results
  exp_results <- read.csv(test_path("testdata", "warm_up_results.csv"))

  # Compare results
  expect_equal(results, exp_results) # nolint: expect_identical_linter
})


test_that("results from scenario analysis match those previously generated", {
  # Choose a specific set of parameters (ensuring test remains on the same
  # set, regardless of any changes to parameters())
  param <- parameters(
    patient_inter = 4L,
    mean_n_consult_time = 10L,
    number_of_nurses = 5L,
    warm_up_period = 0L,
    data_collection_period = 80L,
    number_of_runs = 3L,
    cores = 1L
  )

  # Run scenario analysis
  scenarios <- list(
    patient_inter = c(3L, 4L),
    number_of_nurses = c(6L, 7L)
  )

  scenario_results <- as.data.frame(
    run_scenarios(scenarios, base_list = param, verbose = FALSE)
  )

  # Import the expected results
  exp_results <- read.csv(test_path("testdata", "scenario_results.csv"))

  # Compare results
  expect_equal(scenario_results, exp_results) # nolint: expect_identical_linter
})
