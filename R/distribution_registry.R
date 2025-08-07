#' Registry for parametrised probability distributions
#'
#' @description
#' The DistributionRegistry manages and generates parameterized samplers for a
#' variety of probability distributions. Common distributions are included by
#' default, and more can be added.
#'
#' Once defined, you can create sampler objects for each distribution -
#' individually (`create`) or in batches (`create_batch`) - and then easily
#' draw random samples from these objects.
#'
#' To add more built-in distributions, edit `initialize()`. To add custom ones
#' at any time, use `register()`.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export

DistributionRegistry <- R6Class("DistributionRegistry", list( # nolint: object_name_linter

  #' @field registry Named list of registered distribution generator functions.
  registry = list(),

  #' @description
  #' Pre-registers a set of common base R distribution generators.
  initialize = function() {
    self$register("exponential", function(mean) {
      function(size = 1L) rexp(size, rate = 1L / mean)
    })
    self$register("uniform", function(min, max) {
      function(size = 1L) runif(size, min = min, max = max)
    })
    self$register("normal", function(mean, sd) {
      function(size = 1L) rnorm(size, mean = mean, sd = sd)
    })
    self$register("poisson", function(lambda) {
      function(size = 1L) rpois(size, lambda = lambda)
    })
    self$register("binomial", function(size_param, prob) {
      function(size = 1L) rbinom(size, size = size_param, prob = prob)
    })
    self$register("geometric", function(prob) {
      function(size = 1L) rgeom(size, prob = prob)
    })
    self$register("beta", function(shape1, shape2) {
      function(size = 1L) rbeta(size, shape1 = shape1, shape2 = shape2)
    })
    self$register("gamma", function(shape, rate) {
      function(size = 1L) rgamma(size, shape = shape, rate = rate)
    })
    self$register("chisq", function(df) {
      function(size = 1L) rchisq(size, df = df)
    })
    self$register("t", function(df) {
      function(size = 1L) rt(size, df = df)
    })
  },

  #' @description
  #' Register a distribution generator under a name.
  #'
  #' Typically, the generator should be a function that takes
  #' distribution-specific parameters and returns a function of `size` (the
  #' sample size).
  #'
  #' @param name Distribution name (string)
  #' @param generator Function to create a sampler given its parameters.
  register = function(name, generator) {
    self$registry[[name]] <- generator
  },

  #' @description
  #' Get a registered distribution generator by name.
  #'
  #' @param name Distribution name (string)
  #' @return Generator function for the distribution.
  get = function(name) {
    if (!(name %in% names(self$registry)))
      stop(sprintf("Distribution '%s' not found", name), call. = FALSE)
    self$registry[[name]]
  },

  #' @description
  #' Create a parameterised sampler for a distribution.
  #'
  #' The returned function draws random samples of a specified size from
  #' the given distribution with fixed parameters.
  #'
  #' @param name Distribution name
  #' @param ... Parameters for the generator
  #' @return A function that draws samples when called.
  create = function(name, ...) {
    generator <- self$get(name)
    generator(...)
  },

  #' @description
  #' Batch-create samplers from a configuration list.
  #'
  #' The configuration should be a list of lists, each sublist specifying a
  #' `class_name` (distribution) and `params` (parameter list for that
  #' distribution).
  #'
  #' @param config Named or unnamed list. Each entry is a list with
  #'   'class_name' and 'params'.
  #' @return List of parameterised samplers (named if config is named).
  create_batch = function(config) {
    if (is.list(config) && is.null(names(config))) {
      lapply(config, function(cfg) {
        do.call(self$create, c(cfg$class_name, cfg$params))
      })
    } else if (is.list(config)) {
      lapply(config, function(cfg) {
        do.call(self$create, c(cfg$class_name, cfg$params))
      })
    } else {
      stop("config must be a list (named or unnamed)", call. = FALSE)
    }
  }
)
)
