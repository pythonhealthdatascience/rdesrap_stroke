Generate expected results
================
Amy Heather
2025-07-11

- [Set-up](#set-up)
- [Base case](#base-case)
- [Calculate run time](#calculate-run-time)

This notebook is used to run a specific version of the model and save
each results dataframe as a csv. These are used in `test-backtest.R` to
verify that the model produces consistent results.

The `.Rmd` file is provided as it is possible that results may change
due to alterations to the model structure and operations. Once it has
been confirmed that changes are intentional and not any introduced
errors, this script can be run to regenerate the `.csv` files used in
the test.

The run time is provided at the end of this notebook.

## Set-up

Install the latest version of the local simulation package. If running
sequentially, `devtools::load_all()` is sufficient. If running in
parallel, you must use `devtools::install()`.

``` r
devtools::load_all()
```

    ## ℹ Loading simulation

Load required packages.

``` r
# nolint start: undesirable_function_linter.
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following object is masked from 'package:testthat':
    ## 
    ##     matches

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# nolint end
```

Start timer.

``` r
start_time <- Sys.time()
```

Define path to expected results.

``` r
testdata_dir <- file.path("..", "tests", "testthat", "testdata")
```

## Base case

``` r
param <- create_parameters(cores = 1L, number_of_runs = 2L)
print(param)
```

    ## $asu_arrivals
    ## $asu_arrivals$stroke
    ## [1] 1.2
    ## 
    ## $asu_arrivals$tia
    ## [1] 9.3
    ## 
    ## $asu_arrivals$neuro
    ## [1] 3.6
    ## 
    ## $asu_arrivals$other
    ## [1] 3.2
    ## 
    ## 
    ## $rehab_arrivals
    ## $rehab_arrivals$stroke
    ## [1] 21.8
    ## 
    ## $rehab_arrivals$neuro
    ## [1] 31.7
    ## 
    ## $rehab_arrivals$other
    ## [1] 28.6
    ## 
    ## 
    ## $asu_los
    ## $asu_los$stroke_no_esd
    ## $asu_los$stroke_no_esd$mean
    ## [1] 7.4
    ## 
    ## $asu_los$stroke_no_esd$sd
    ## [1] 8.61
    ## 
    ## 
    ## $asu_los$stroke_esd
    ## $asu_los$stroke_esd$mean
    ## [1] 4.6
    ## 
    ## $asu_los$stroke_esd$sd
    ## [1] 4.8
    ## 
    ## 
    ## $asu_los$stroke_mortality
    ## $asu_los$stroke_mortality$mean
    ## [1] 7
    ## 
    ## $asu_los$stroke_mortality$sd
    ## [1] 8.7
    ## 
    ## 
    ## $asu_los$tia
    ## $asu_los$tia$mean
    ## [1] 1.8
    ## 
    ## $asu_los$tia$sd
    ## [1] 2.3
    ## 
    ## 
    ## $asu_los$neuro
    ## $asu_los$neuro$mean
    ## [1] 4
    ## 
    ## $asu_los$neuro$sd
    ## [1] 5
    ## 
    ## 
    ## $asu_los$other
    ## $asu_los$other$mean
    ## [1] 3.8
    ## 
    ## $asu_los$other$sd
    ## [1] 5.2
    ## 
    ## 
    ## 
    ## $rehab_los
    ## $rehab_los$stroke_no_esd
    ## $rehab_los$stroke_no_esd$mean
    ## [1] 28.4
    ## 
    ## $rehab_los$stroke_no_esd$sd
    ## [1] 27.2
    ## 
    ## 
    ## $rehab_los$stroke_esd
    ## $rehab_los$stroke_esd$mean
    ## [1] 30.3
    ## 
    ## $rehab_los$stroke_esd$sd
    ## [1] 23.1
    ## 
    ## 
    ## $rehab_los$tia
    ## $rehab_los$tia$mean
    ## [1] 18.7
    ## 
    ## $rehab_los$tia$sd
    ## [1] 23.5
    ## 
    ## 
    ## $rehab_los$neuro
    ## $rehab_los$neuro$mean
    ## [1] 27.6
    ## 
    ## $rehab_los$neuro$sd
    ## [1] 28.4
    ## 
    ## 
    ## $rehab_los$other
    ## $rehab_los$other$mean
    ## [1] 16.1
    ## 
    ## $rehab_los$other$sd
    ## [1] 14.1
    ## 
    ## 
    ## 
    ## $asu_routing
    ## $asu_routing$stroke
    ## $asu_routing$stroke$rehab
    ## [1] 0.24
    ## 
    ## $asu_routing$stroke$esd
    ## [1] 0.13
    ## 
    ## $asu_routing$stroke$other
    ## [1] 0.63
    ## 
    ## 
    ## $asu_routing$tia
    ## $asu_routing$tia$rehab
    ## [1] 0.01
    ## 
    ## $asu_routing$tia$esd
    ## [1] 0.01
    ## 
    ## $asu_routing$tia$other
    ## [1] 0.98
    ## 
    ## 
    ## $asu_routing$neuro
    ## $asu_routing$neuro$rehab
    ## [1] 0.11
    ## 
    ## $asu_routing$neuro$esd
    ## [1] 0.05
    ## 
    ## $asu_routing$neuro$other
    ## [1] 0.84
    ## 
    ## 
    ## $asu_routing$other
    ## $asu_routing$other$rehab
    ## [1] 0.05
    ## 
    ## $asu_routing$other$esd
    ## [1] 0.1
    ## 
    ## $asu_routing$other$other
    ## [1] 0.85
    ## 
    ## 
    ## 
    ## $rehab_routing
    ## $rehab_routing$stroke
    ## $rehab_routing$stroke$esd
    ## [1] 0.4
    ## 
    ## $rehab_routing$stroke$other
    ## [1] 0.6
    ## 
    ## 
    ## $rehab_routing$tia
    ## $rehab_routing$tia$esd
    ## [1] 0
    ## 
    ## $rehab_routing$tia$other
    ## [1] 1
    ## 
    ## 
    ## $rehab_routing$neuro
    ## $rehab_routing$neuro$esd
    ## [1] 0.09
    ## 
    ## $rehab_routing$neuro$other
    ## [1] 0.91
    ## 
    ## 
    ## $rehab_routing$other
    ## $rehab_routing$other$esd
    ## [1] 0.13
    ## 
    ## $rehab_routing$other$other
    ## [1] 0.88
    ## 
    ## 
    ## 
    ## $warm_up_period
    ## [1] 1095
    ## 
    ## $data_collection_period
    ## [1] 1825
    ## 
    ## $number_of_runs
    ## [1] 2
    ## 
    ## $scenario_name
    ## NULL
    ## 
    ## $cores
    ## [1] 1
    ## 
    ## $log_to_console
    ## [1] FALSE
    ## 
    ## $log_to_file
    ## [1] FALSE
    ## 
    ## $file_path
    ## NULL

``` r
results <- runner(param = param)
```

``` r
# Arrivals
head(results[["arrivals"]])
```

    ## # A tibble: 6 × 6
    ##   name          start_time end_time activity_time resource replication
    ##   <chr>              <dbl>    <dbl>         <dbl> <chr>          <int>
    ## 1 asu_stroke901      1095.    1098.         2.31  asu_bed            1
    ## 2 asu_tia133         1098.    1099.         0.191 asu_bed            1
    ## 3 asu_tia132         1098.    1100.         1.97  asu_bed            1
    ## 4 asu_stroke908      1100.    1100.         0.419 asu_bed            1
    ## 5 asu_tia135         1100.    1100.         0.189 asu_bed            1
    ## 6 asu_tia131         1097.    1100.         3.21  asu_bed            1

``` r
write.csv(arrange(results[["arrivals"]], replication, start_time),
          file.path(testdata_dir, "base_arrivals.csv"),
          row.names = FALSE)

# Occupancy
head(results[["occupancy"]])
```

    ## # A tibble: 6 × 4
    ##   resource   time occupancy replication
    ##   <fct>     <int>     <int>       <int>
    ## 1 asu_bed    1095        12           1
    ## 2 rehab_bed  1095        11           1
    ## 3 asu_bed    1096        13           1
    ## 4 rehab_bed  1096        10           1
    ## 5 asu_bed    1097        10           1
    ## 6 rehab_bed  1097        10           1

``` r
write.csv(results[["occupancy"]],
          file.path(testdata_dir, "base_occ.csv"),
          row.names = FALSE)

# Occupancy stats (acute stroke unit)
head(results[["occupancy_stats"]][["asu_bed"]])
```

    ##   beds freq         pct       c_pct prob_delay 1_in_n_delay
    ## 1    1    5 0.001369113 0.001369113  1.0000000            1
    ## 2    2   26 0.007119387 0.008488499  0.8387097            1
    ## 3    3   76 0.020810515 0.029299014  0.7102804            1
    ## 4    4  225 0.061610077 0.090909091  0.6777108            1
    ## 5    5  360 0.098576123 0.189485214  0.5202312            2
    ## 6    6  466 0.127601314 0.317086528  0.4024180            2

``` r
write.csv(results[["occupancy_stats"]][["asu_bed"]],
          file.path(testdata_dir, "base_occ_asu.csv"),
          row.names = FALSE)

# Occupancy stats (rehab unit)
head(results[["occupancy_stats"]][["rehab_bed"]])
```

    ##   beds freq          pct        c_pct prob_delay 1_in_n_delay
    ## 1    2    2 0.0005476451 0.0005476451  1.0000000            1
    ## 2    3   27 0.0073932092 0.0079408543  0.9310345            1
    ## 3    4   69 0.0188937568 0.0268346112  0.7040816            1
    ## 4    5  161 0.0440854326 0.0709200438  0.6216216            2
    ## 5    6  270 0.0739320920 0.1448521358  0.5103970            2
    ## 6    7  377 0.1032311062 0.2480832421  0.4161148            2

``` r
write.csv(results[["occupancy_stats"]][["rehab_bed"]],
          file.path(testdata_dir, "base_occ_rehab.csv"),
          row.names = FALSE)
```

## Calculate run time

``` r
# Get run time in seconds
end_time <- Sys.time()
runtime <- as.numeric(end_time - start_time, units = "secs")

# Display converted to minutes and seconds
minutes <- as.integer(runtime / 60L)
seconds <- as.integer(runtime %% 60L)
cat(sprintf("Notebook run time: %dm %ds", minutes, seconds))
```

    ## Notebook run time: 0m 3s
