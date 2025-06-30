# R DES RAP Template 0.4.0

Major changes include: addition of two new metrics (queue length and patients in service); input modelling; and synthetic data. Also, enabled solutions below the defined initial replications for the replications algorithm.

## New features

* Add synthetic data and explanation in `README`.
* Add `input_modelling.Rmd`.
* Add unit tests for `find_position()`.
* Add mock paper with figures mentioned in `.Rmd`/`README`.
* Add `CITATION`.
* Add printing of parameters when running model.
* Add two new metrics: queue length and patients in service.

## Bug fixes

* Add `find_position()` which allows us to find a solution below the initial replications set when using `ReplicationsAlgorithm`.

## Other changes

* Changed desired precision when choosing replications to 0.1.
* Made `README` simpler/clearer, so it focuses on describing the repository, rather than on being a template.
* Add `fitdistrplus`, `lubridate` and `plotly`, and updated some packages.
* Set `renv` snapshot type to implicit (was previously all).
* In `choosing_cores.Rmd`, set `devtools::install(upgrade = "never")` (else would try to update packages).
* GitHub action runs tests on latest mac, windows and ubuntu (but not on development or old ubuntu anymore).

# R DES RAP Template 0.3.0

Major changes include addition of functions/classes for choosing the warm-up length and number of replications. Other changes include tests, possibility to override seeds in runner, a bug fix for the mean wait time and serve length, code refactoring, and others.

## New features

* Add file explaining how `set_attributes()` changes results (`using_set_attributes.Rmd`).
* Add functions for choosing warm-up length (`choose_warmup`) and an example file (`choosing_warmup.Rmd`).
* Add some extra checks in functional tests using the unseen metrics.
* Add classes/functions for automated choice of the number of replications (`choose_replications.R`) and an example file explaining these (`choosing_replications.Rmd`), along with tests for these (`test-backtest-replications.R`, `test-functionaltest-replications.R`, `test-unittest-replications.R`).
* Add options in `runner()` to override future.seed and use the run numbers as seeds (allowing consistency with `model()`) (and add test using it).
* Add unit test for parallel processing.

## Bug fixes

* Corrected calculation of mean wait and serve length (previously dropped all arrivals NA for `end_time` - now bases on `wait_time`, and so includes people who are midway through appointment at end of simulation).

## Other changes

* Split calculations from `get_run_results()` into seperate functions for simplicity, and to make them reusable for other purposes.
* Simplified calculation of utilisation (same output, simpler code).
* Add example of calculating overall results table to `analysis.Rmd`.
* Add "how does model work" and "acknowledgements" sections to README.

# R DES RAP Template 0.2.0

Warm-up period, "unseen" metrics and tests. Note that the alteration to record service duration altered the order of random number generation, so results now differ from before.

## New features

* Add warm-up period (`filter_warmup()`).
* Add measurement of when service starts and its duration during the model run (`set_attribute("nurse_serve_start", ...` and `set_attribute("nurse_serve_length", ...`).
* Add count and wait time for unseen patients in the run results.
* Add tests for warm-up, unseen metrics, and logs.
* Add `arrivals` and `resources` to base case back test.

## Bug fixes

* Include all patients in the run results `arrivals` count (and not only those who completed the service).
* Include patients partway through service in the `mean_waiting_time` and `mean_service_time` (and not only those who completed the service).
* Use `devtools::install()` in `choosing_cores.Rmd` (required to get updated package for parallel processing).

## Other changes

* Simplify scenario back test.
* Add DOI and Zenodo citation to README.

# R DES RAP Template 0.1.0

🌱 First release of the R DES template.
