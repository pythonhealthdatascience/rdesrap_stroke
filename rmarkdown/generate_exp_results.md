Generate expected results
================
Amy Heather
2025-07-10

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
library(simulation)
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
    ## $asu_los$stroke_noesd
    ## $asu_los$stroke_noesd$mean
    ## [1] 7.4
    ## 
    ## $asu_los$stroke_noesd$sd
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
    ## $rehab_los$stroke_noesd
    ## $rehab_los$stroke_noesd$mean
    ## [1] 28.4
    ## 
    ## $rehab_los$stroke_noesd$sd
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

    ##          name start_time end_time activity_time resource replication
    ## 1    asu_tia0  1.2840389 3.170685     1.8866462  asu_bed           1
    ## 2  asu_other1  3.9754223 4.184680     0.2092577  asu_bed           1
    ## 3    asu_tia1  4.1671467 4.367036     0.1998889  asu_bed           1
    ## 4 asu_stroke1  4.7009372 6.293953     1.5930162  asu_bed           1
    ## 5  asu_other0  0.8659035 6.436690     5.5707867  asu_bed           1
    ## 6  asu_neuro0  5.7762114 6.743039     0.9668279  asu_bed           1

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
    ## 1 asu_bed       0         0           1
    ## 2 rehab_bed     0         0           1
    ## 3 asu_bed       1         1           1
    ## 4 rehab_bed     1         0           1
    ## 5 asu_bed       2         2           1
    ## 6 rehab_bed     2         0           1

``` r
write.csv(results[["occupancy"]],
          file.path(testdata_dir, "base_occ.csv"),
          row.names = FALSE)

# Occupancy stats (acute stroke unit)
head(results[["occupancy_stats"]][["asu_bed"]])
```

    ##   beds freq          pct        c_pct prob_delay 1_in_n_delay
    ## 1    0    2 0.0003423485 0.0003423485  1.0000000            1
    ## 2    1    8 0.0013693940 0.0017117426  0.8000000            1
    ## 3    2   42 0.0071893187 0.0089010613  0.8076923            1
    ## 4    3  105 0.0179732968 0.0268743581  0.6687898            1
    ## 5    4  312 0.0534063677 0.0802807258  0.6652452            2
    ## 6    5  517 0.0884970900 0.1687778158  0.5243408            2

``` r
write.csv(results[["occupancy_stats"]][["asu_bed"]],
          file.path(testdata_dir, "base_occ_asu.csv"),
          row.names = FALSE)

# Occupancy stats (rehab unit)
head(results[["occupancy_stats"]][["rehab_bed"]])
```

    ##   beds freq         pct       c_pct prob_delay 1_in_n_delay
    ## 1    0   12 0.002054091 0.002054091  1.0000000            1
    ## 2    1   12 0.002054091 0.004108182  0.5000000            2
    ## 3    2    6 0.001027046 0.005135228  0.2000000            5
    ## 4    3   72 0.012324546 0.017459774  0.7058824            1
    ## 5    4  169 0.028928449 0.046388223  0.6236162            2
    ## 6    5  326 0.055802807 0.102191030  0.5460637            2

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

    ## Notebook run time: 0m 1s
