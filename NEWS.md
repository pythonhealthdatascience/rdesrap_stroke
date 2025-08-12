# Stroke capacity planning model: R DES RAP 0.2.0

Introduces `DistributionRegistry` with JSON-based parameters, replacing individual parameter functions and CSV. Also add test coverage, add file path check, and documentation and dependency management updates.

## New features

* Add `DistributionRegistry` and `inst/extdata/parameters.json` (and accompanying data dictionary). Amended the package, validation, tests and `rmarkdown` to work with the new syntax for sampling and changing values (as have removed the individual parameter functions - and also removed the CSV).
* Add coverage (`covr`, `DT`, coverage command in README, and GitHub action).

## Bug fixes

* Add check for non-null file path when `log_to_file=TRUE` in model validation.

## Other changes

* Switched to "all" `renv` snapshot type.
* Update `docs/stress_des.md`.

# Stroke capacity planning model: R DES RAP 0.1.0

🌱 First release of the R stroke model.

## New features

* Implementation of the stroke model in R as a package (`R/`).
* Reproduction of paper results (`rmarkdown/analysis.Rmd`).
* Other RMarkdown files to generate results for tests, demonstrate logging, and how parameters can be loaded from a csv (`rmarkdown/`).
* Back, functional and unit tests (`tests/`).
* Other features include continuous integration (tests and linting), checklists, R environment, and other metadata.