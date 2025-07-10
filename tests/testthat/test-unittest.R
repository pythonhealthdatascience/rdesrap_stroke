# Unit testing for the Discrete-Event Simulation (DES) Model.
#
# Unit tests are a type of functional testing that focuses on individual
# components (e.g. functions) and tests them in isolation to ensure they
# work as intended.
#
# In some cases, we check for a specific error message. This is because the
# test could otherwise pass with any error (and not necessarily the specific
# error we are checking for).


# -----------------------------------------------------------------------------
# 1. Parallel processing
# -----------------------------------------------------------------------------

test_that("parallel processing runs successfully", {

  # Mock simulation model function so it can run without other dependencies
  # This will allows us to execute runner, but when it calls model(), instead
  # of attempting to run a simulation, it will just return a list of dataframes
  test_model <- function(run_number, param, set_seed) {
    list(
      arrivals = data.frame(run = run_number, value = rnorm(1L)),
      resources = data.frame(run = run_number, value = rnorm(1L)),
      run_results = data.frame(run = run_number, success = TRUE)
    )
  }
  mockery::stub(runner, "simulation::model", test_model)
  param <- list(cores = 2L, number_of_runs = 2L)

  # Attempt parallel processing
  result <- tryCatch({
    runner(param, use_future_seeding = TRUE)
  }, error = function(e) {
    # Check if this is a parallel processing error
    if (grepl("Failed to find a functional cluster workers|FutureError",
              e$message)) {
      # Skip test on macOS if parallel processing fails
      if (Sys.info()[["sysname"]] == "Darwin") {
        skip(paste("Parallel processing not available on this macOS system",
                   "- this is expected in CI environments"))
      }
      # Else throw an error
      stop(e, call. = FALSE)
    } else {
      # Re-throw if it's a different error
      stop(e, call. = FALSE)
    }
  })

  # Check if results contain expected structure
  expect_true("arrivals" %in% names(result))
  expect_true("occupancy" %in% names(result))
  expect_true("occupancy_stats" %in% names(result))
})


# -----------------------------------------------------------------------------
# 2. Warm-up
# -----------------------------------------------------------------------------

test_that("warm-up filtering works as expected", {
  mock_result <- list(
    arrivals = data.frame(name = c("p1", "p2", "p3"),
                          start_time = c(5L, 10L, 14L),
                          stringsAsFactors = FALSE),
    occupancy = data.frame(name = "asu_bed",
                           time = c(5L, 14L),
                           stringsAsFactors = FALSE)
  )

  # With no warm-up...
  # > Check that no entries are removed
  no_warm_up <- filter_warmup(mock_result, warm_up_period = 0L)
  expect_identical(no_warm_up, mock_result)

  # With warm-up of 10...
  # > Check that two arrivals remain (10 + 14)
  # > Check that one occupancy record remains (14)
  filtered <- filter_warmup(mock_result, warm_up_period = 10L)
  expect_identical(nrow(filtered[["arrivals"]]), 2L)
  expect_identical(filtered[["arrivals"]][["start_time"]], c(10L, 14L))
  expect_identical(nrow(filtered[["occupancy"]]), 1L)
  expect_identical(filtered[["occupancy"]][["time"]], c(14L))

  # Emulating run with no data collection period...
  # > Check that no data remains
  full_length <- filter_warmup(mock_result, warm_up_period = 15L)
  expect_identical(nrow(full_length[["arrivals"]]), 0L)
  expect_identical(nrow(full_length[["occupancy"]]), 0L)
})
