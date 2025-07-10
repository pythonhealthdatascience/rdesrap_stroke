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
  param$asu_arrivals$stroke <- -1
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_arrivals" must be greater than 0.'
  )
  # Zero value for neuro
  param <- create_parameters()
  param$asu_arrivals$neuro <- 0
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_arrivals" must be greater than 0.'
  )
})


test_that("model errors for invalid asu_los values", {
  param <- create_parameters()
  # Negative mean for stroke_noesd
  param$asu_los$stroke_noesd$mean <- -5
  expect_error(
    model(param = param, run_number = 1L),
    'All values in "asu_los" must be greater than 0.'
  )
  # Zero sd for tia
  param <- create_parameters()
  param$asu_los$tia$sd <- 0
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
    'All values in routing vector "asu_routing$stroke" must be between 0 and 1.',
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
  # Probability > 1
  param$rehab_routing$other$esd <- 1.5
  expect_error(
    model(param = param, run_number = 1L),
    'All values in routing vector "rehab_routing$other" must be between 0 and 1.',
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
  param$asu_arrivals$extra <- 5  # Add unexpected key
  expect_error(
    model(param = param, run_number = 1L),
    "Extra keys: extra."
  )
})
