#' Transform mean/sd on original scale to meanlog/sdlog for
#' lognormal
#'
#' @param params A list with elements `mean` and `sd` (on
#'   original scale).
#' @return A list with elements `meanlog` and `sdlog`.
#' @export

transform_to_lnorm <- function(params) {
  variance <- params$sd^2L
  sigma_sq <- log(variance / (params$mean^2L) + 1L)
  sdlog <- sqrt(sigma_sq)
  meanlog <- log(params$mean) - sigma_sq / 2L
  list(meanlog = meanlog, sdlog = sdlog)
}


#' Validate a single sampler config element
#'
#' @param cfg A list expected to contain `class_name` and `params` elements.
#' @return Invisibly `NULL` on success; stops with an error otherwise.
#' @export

validate_single_config <- function(cfg) {
  if (!is.list(cfg)) {
    stop("Each element of 'config' must be a list.", call. = FALSE)
  }
  if (is.null(cfg$class_name)) {
    stop(
      "Each config element must have a 'class_name' entry.",
      call. = FALSE
    )
  }
  if (is.null(cfg$params) || !is.list(cfg$params)) {
    stop(
      "Each config element must have a 'params' list.",
      call. = FALSE
    )
  }
  invisible(NULL)
}


#' Create a distribution registry
#'
#' @description
#' Creates a distribution registry that manages and generates
#' parameterised samplers for a variety of probability
#' distributions. Common distributions are included by default,
#' and more can be added.
#'
#' Once defined, you can create sampler objects for each
#' distribution - individually (`dist_create`) or in batches
#' (`dist_create_batch`) - and then easily draw random samples
#' from these objects.
#'
#' @return A list containing registry functions and data.
#' @export

create_distribution_registry <- function() {

  # Internal registry storage
  registry <- new.env(parent = emptyenv())

  # ===== Register default distributions =====

  registry[["exponential"]] <- function(mean) {
    function(size = 1L) rexp(size, rate = 1L / mean)
  }

  registry[["uniform"]] <- function(min, max) {
    function(size = 1L) runif(size, min = min, max = max)
  }

  registry[["discrete"]] <- function(values, prob) {
    values <- unlist(values)
    prob <- unlist(prob)

    stopifnot(length(values) == length(prob), prob >= 0L)

    if (round(abs(sum(prob) - 1L), 2L) > 0.01) {
      stop(
        sprintf(
          "'prob' must sum to 1 +- 0.01. Sum: %s",
          abs(sum(unlist(prob)))
        ),
        call. = FALSE
      )
    }

    function(size = 1L) {
      sample(values, size = size, replace = TRUE, prob = prob)
    }
  }

  registry[["normal"]] <- function(mean, sd) {
    function(size = 1L) rnorm(size, mean = mean, sd = sd)
  }

  registry[["lognormal"]] <- function(meanlog = NULL, sdlog = NULL,
                                      mean = NULL, sd = NULL) {
    # If meanlog/sdlog provided, use them directly
    if (!is.null(meanlog) && !is.null(sdlog)) {
      function(size = 1L) {
        rlnorm(size, meanlog = meanlog, sdlog = sdlog)
      }

    } else if (!is.null(mean) && !is.null(sd)) {

      # Transform mean/sd to meanlog/sdlog
      params <- transform_to_lnorm(list(mean = mean, sd = sd))
      function(size = 1L) {
        rlnorm(size,
               meanlog = params$meanlog,
               sdlog  = params$sdlog)
      }

    } else {
      stop(
        "Please supply either 'meanlog' and 'sdlog', or 'mean' and 'sd' ",
        "for a lognormal distribution.",
        call. = FALSE
      )
    }
  }

  registry[["poisson"]] <- function(lambda) {
    function(size = 1L) rpois(size, lambda = lambda)
  }

  registry[["binomial"]] <- function(size_param, prob) {
    function(size = 1L) {
      rbinom(size, size = size_param, prob = prob)
    }
  }

  registry[["geometric"]] <- function(prob) {
    function(size = 1L) rgeom(size, prob = prob)
  }

  registry[["beta"]] <- function(shape1, shape2) {
    function(size = 1L) {
      rbeta(size, shape1 = shape1, shape2 = shape2)
    }
  }

  registry[["gamma"]] <- function(shape, rate) {
    function(size = 1L) {
      rgamma(size, shape = shape, rate = rate)
    }
  }

  registry[["chisq"]] <- function(df) {
    function(size = 1L) rchisq(size, df = df)
  }

  registry[["student_t"]] <- function(df) {
    function(size = 1L) rt(size, df = df)
  }

  # ===== Public API =====

  # Register a new distribution
  register <- function(name, generator, overwrite = FALSE) {
    if (!overwrite && exists(name, envir = registry, inherits = FALSE)) {
      stop(
        sprintf(
          "Distribution '%s' already exists. Set overwrite = TRUE ",
          "to replace it."
        ),
        call. = FALSE
      )
    }
    assign(name, generator, envir = registry)
    invisible(TRUE)
  }

  # Get a registered distribution generator
  get_distribution <- function(name) {
    if (!exists(name, envir = registry, inherits = FALSE)) {
      stop(
        sprintf(
          paste0(
            "Distribution '%s' not found.\n",
            "Available distributions:\n\t%s\n",
            "Use register() to add new distributions."
          ),
          name,
          toString(ls(envir = registry))
        ),
        call. = FALSE
      )
    }
    get(name, envir = registry, inherits = FALSE)
  }

  # Create a parameterised sampler
  create_sampler <- function(name, ...) {
    generator <- get_distribution(name)
    arg_list <- list(...)

    formals_names <- names(formals(generator))
    if (!is.null(formals_names)) {
      extra_args <- setdiff(names(arg_list), formals_names)
      if (length(extra_args) > 0L) {
        warning(
          sprintf(
            "Unused argument(s) for distribution '%s': %s",
            name,
            toString(extra_args)
          ),
          call. = FALSE
        )
      }
    }

    do.call(generator, arg_list)
  }

  # Create multiple samplers from config
  # Each element of `config` is expected to be a list with
  # components:
  #   - class_name: name of the registered distribution
  #   - params: list of parameters to pass to that distribution's
  #     generator
  create_batch <- function(config) {
    if (!is.list(config)) {
      stop("config must be a list (named or unnamed).", call. = FALSE)
    }

    lapply(config, function(cfg) {
      validate_single_config(cfg)
      do.call(create_sampler, c(list(cfg$class_name), cfg$params))
    })
  }

  # Return public API as a list
  list(
    register = register,
    get = get_distribution,
    create = create_sampler,
    create_batch = create_batch,
    transform_to_lnorm = transform_to_lnorm
  )
}
