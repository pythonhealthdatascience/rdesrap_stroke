# Functional testing for objects in choose_replications.R

test_that("output from confidence_interval_method is as expected", {
  # Choose a number of replications to run for
  reps <- 20L

  # Run the confidence interval method (ignoring unsolved warnings)
  ci_df <- suppressWarnings(confidence_interval_method(
    replications = reps,
    desired_precision = 0.1,
    metric = "mean_waiting_time_nurse",
    verbose = FALSE
  ))

  # Check that the results dataframe has the right number of rows
  expect_identical(nrow(ci_df), reps)

  # Check that the replications are appropriately numbered
  expect_identical(min(ci_df[["replications"]]), 1L)
  expect_identical(max(ci_df[["replications"]]), reps)
})


test_that(
  paste0("output from confidence_interval_method is consistent with ",
         "ReplicationsAlgorithm"),
  {
    # Choose the number of replications to run for
    reps <- 20L
    desired_precision <- 0.1
    metric <- "mean_serve_time_nurse"

    # Run the manual confidence interval method (ignoring unsolved warnings)
    man_df <- suppressWarnings(confidence_interval_method(
      replications = reps,
      desired_precision = desired_precision,
      metric = metric,
      verbose = FALSE
    ))

    # Run the algorithm (ignoring unsolved warnings)
    alg <- ReplicationsAlgorithm$new(
      param = parameters(),
      metrics = c(metric),
      desired_precision = desired_precision,
      initial_replications = reps,
      look_ahead = 0L,
      replication_budget = reps,
      verbose = FALSE
    )
    suppressWarnings(alg$select())

    # Compare dataframes
    expect_equal(man_df, alg$summary_table) # nolint: expect_identical_linter
  }
)


test_that("ReplicationsAlgorithm initial_replications consistent to without", {

  #' Helper function to run the algorithm (ignoring unsolved warnings)
  helper_alg <- function(initial_replications) {
    alg <- ReplicationsAlgorithm$new(
      param = parameters(),
      metrics = "mean_serve_time_nurse",
      desired_precision = 0.1,
      initial_replications = initial_replications,
      look_ahead = 10L,
      replication_budget = 10L,
      verbose = FALSE
    )
    suppressWarnings(alg$select())
    head(alg$summary_table, 10L)
  }

  # Run with three initial replications
  alg_3 <- helper_alg(initial_replications = 3L)

  # Run with ten initial replications (matches budget)
  alg_10 <- helper_alg(initial_replications = 10L)

  expect_equal(alg_3, alg_10) # nolint: expect_identical_linter
})


test_that("running algorithm with < 3 replications has no solution", {
  alg <- ReplicationsAlgorithm$new(param = parameters(),
                                   initial_replications = 0L,
                                   replication_budget = 2L,
                                   look_ahead = 0L,
                                   verbose = FALSE)
  # Check that it runs with a warning
  expect_warning(alg$select())
  # Check that there is no solution
  expect_true(all(is.na(alg$nreps)))
  # Check that summary table just has 2 rows per metric
  expect_identical(nrow(alg$summary_table), 6L)
})
