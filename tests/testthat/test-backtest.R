# Back testing for the Discrete-Event Simulation (DES) Model.
#
# These check that the model code produces results consistent with prior code.

library(dplyr)


test_that("results from a new run match those previously generated", {
  # Run the model for 2 replications
  param <- create_parameters(cores = 1L, number_of_runs = 2L)
  results <- runner(param = param)

  # Extract and format the results (e.g. sort, dataframe, column type)
  arrivals <- as.data.frame(arrange(
    results[["arrivals"]], replication, start_time)
  )
  occ <- as.data.frame(results[["occupancy"]])
  occ[["resource"]] <- as.character(occ[["resource"]])
  occ_asu <- results[["occupancy_stats"]][["asu_bed"]]
  occ_rehab <- results[["occupancy_stats"]][["rehab_bed"]]

  # Import the expected results
  exp_arrivals <- read.csv(test_path("testdata", "base_arrivals.csv"))
  exp_occ <- read.csv(test_path("testdata", "base_occ.csv"))
  exp_occ_asu <- read.csv(test_path("testdata", "base_occ_asu.csv"))
  exp_occ_rehab <- read.csv(test_path("testdata", "base_occ_rehab.csv"))

  # Correct column name back to 1_in_n_delay (add X for csv)
  exp_occ_asu <- rename(exp_occ_asu, `1_in_n_delay` = `X1_in_n_delay`)
  exp_occ_rehab <- rename(exp_occ_rehab, `1_in_n_delay` = `X1_in_n_delay`)

  # Compare results
  # nolint start: expect_identical_linter
  expect_equal(arrivals, exp_arrivals)
  expect_equal(occ, exp_occ)
  expect_equal(occ_asu, exp_occ_asu)
  expect_equal(occ_rehab, exp_occ_rehab)
  # nolint end
})
