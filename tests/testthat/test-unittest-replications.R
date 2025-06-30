# Unit testing for objects in choose_replications.R

patrick::with_parameters_test_that(
  "klimit calculations are correct",
  {
    # Calculate klimit
    calc <- ReplicationsAlgorithm$new(param = parameters(),
                                      look_ahead =  look_ahead,
                                      initial_replications = n,
                                      verbose = FALSE)$klimit()
    # Check that it meets our expected value
    expect_identical(calc, exp)
  },
  patrick::cases(
    list(look_ahead = 100L, n = 100L, exp = 100L),
    list(look_ahead = 100L, n = 101L, exp = 101L),
    list(look_ahead = 0L, n = 500L, exp = 0L)
  )
)


patrick::with_parameters_test_that(
  "ReplicationsAlgorithm responds appropriately to invalid parameters",
  {
    inputs <- c(list(param = parameters()), setNames(list(value), arg),
                verbose = FALSE)
    expect_error(do.call(ReplicationsAlgorithm$new, inputs), msg)
  },
  patrick::cases(
    list(arg = "initial_replications", value = -1L,
         msg = paste0("initial_replications must be a non-negative integer, ",
                      "but provided -1.")),
    list(arg = "initial_replications", value = 0.5,
         msg = paste0("initial_replications must be a non-negative integer, ",
                      "but provided 0.5.")),
    list(arg = "look_ahead", value = -1L,
         msg = "look_ahead must be a non-negative integer, but provided -1."),
    list(arg = "look_ahead", value = 0.5,
         msg = "look_ahead must be a non-negative integer, but provided 0.5."),
    list(arg = "desired_precision", value = 0L,
         msg = "desired_precision must be greater than 0.")
  )
)


test_that(
  "ReplicationsAlgorithm errors if replication_budget < initial_replications",
  {
    expect_error(
      ReplicationsAlgorithm$new(param = parameters(),
                                initial_replications = 10L,
                                replication_budget = 9L,
                                verbose = FALSE),
      "replication_budget must be less than initial_replications."
    )
  }
)


test_that("WelfordStats calculations are correct", {

  # Initialise with three values
  values <- c(10L, 20L, 30L)
  stats <- WelfordStats$new(data = values, alpha = 0.05)

  # Check statistics(expected results from online calculators)
  expect_identical(stats$mean, 20.0)
  expect_identical(stats$sq, 200.0)
  expect_identical(stats$variance(), 100.0)
  expect_identical(stats$std(), 10.0)
  expect_identical(round(stats$std_error(), 10L), 5.7735026919)

  # Check that statistics (expected results from python st.t.interval())
  expect_identical(round(stats$lci(), 4L), -4.8414)
  expect_identical(round(stats$uci(), 4L), 44.8414)
  expect_identical(round(stats$deviation(), 4L), 1.2421)
})


test_that("WelfordStats doesn't return some calculations for small samples", {

  # Initialise with two values
  values <- c(10L, 20L)
  stats <- WelfordStats$new(data = values)

  # Check that statistics meet our expectations
  # (expected results based on online calculators)
  expect_identical(stats$mean, 15.0)
  expect_identical(stats$sq, 50.0)
  expect_identical(stats$variance(), 50.0)
  expect_true(is.na(stats$std()))
  expect_true(is.na(stats$std_error()))
  expect_true(is.na(stats$half_width()))
  expect_true(is.na(stats$lci()))
  expect_true(is.na(stats$uci()))
  expect_true(is.na(stats$deviation()))
})


test_that("ReplicationTaubliser's update method appends new data + makes df", {
  # Data to be stored by ReplicationTabuliser
  mock_stats <- list(
    latest_data = 10L,
    mean = 5L,
    std = function() 1.2,
    lci = function() 4.8,
    uci = function() 6.2,
    deviation = function() 0.1
  )

  # Create and add data to the class twice
  tab <- ReplicationTabuliser$new()
  tab$update(mock_stats)
  tab$update(mock_stats)

  # Check stored lists
  expect_identical(tab$data_points, c(10L, 10L))
  expect_identical(tab$cumulative_mean, c(5L, 5L))
  expect_identical(tab$std, c(1.2, 1.2))
  expect_identical(tab$lci, c(4.8, 4.8))
  expect_identical(tab$uci, c(6.2, 6.2))
  expect_identical(tab$deviation, c(0.1, 0.1))

  # Check summary table
  mock_df <- data.frame(
    replications = c(1L, 2L),
    data = rep(mock_stats$latest_data, 2L),
    cumulative_mean = rep(mock_stats$mean, 2L),
    stdev = rep(mock_stats$std(), 2L),
    lower_ci = rep(mock_stats$lci(), 2L),
    upper_ci = rep(mock_stats$uci(), 2L),
    deviation = rep(mock_stats$deviation(), 2L)
  )
  expect_identical(tab$summary_table(), mock_df)
})


patrick::with_parameters_test_that(
  "the find_position() method from ReplicationsAlgorithm is correct",
  {
    # Set threshold to 0.5, with provided look_ahead
    alg <- ReplicationsAlgorithm$new(param = parameters(),
                                     desired_precision = 0.5,
                                     look_ahead = look_ahead,
                                     verbose = FALSE)
    # Get result from algorithm and compare to expected
    result <- alg$find_position(lst)
    expect_identical(result, exp)
  },
  patrick::cases(
    # Normal case
    list(lst = list(NA, NA, 0.8, 0.4, 0.3),
         exp = 4L, look_ahead = 0L),
    # No NA values
    list(lst = list(0.4, 0.3, 0.2, 0.1),
         exp = 1L, look_ahead = 0L),
    # No values below threshold
    list(lst = list(0.8, 0.9, 0.8, 0.7),
         exp = NULL, look_ahead = 0L),
    # No values
    list(lst = list(NA, NA, NA, NA),
         exp = NULL, look_ahead = 0L),
    # Empty list
    list(lst = list(),
         exp = NULL, look_ahead = 0L),
    # Not full lookahead
    list(lst = list(NA, NA, 0.8, 0.8, 0.3, 0.3, 0.3),
         exp = NULL, look_ahead = 3L),
    # Meets lookahead
    list(lst = list(NA, NA, 0.8, 0.8, 0.3, 0.3, 0.3, 0.3),
         exp = 5L, look_ahead = 3L)
  )
)


test_that("find_position() fails if not supplied a list", {
  alg <- ReplicationsAlgorithm$new(param = parameters(), verbose = FALSE)
  expect_error(alg$find_position(c(1L, 2L, 3L)))
})
