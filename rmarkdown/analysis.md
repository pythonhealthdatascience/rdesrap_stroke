Analysis
================
Amy Heather
2025-07-02

- [Set-up](#set-up)
- [Base case](#base-case)
  - [Run the model](#run-the-model)
- [Calculate run time](#calculate-run-time)

This analysis reproduces the analysis performed in:

> Monks T, Worthington D, Allen M, Pitt M, Stein K, James MA. A
> modelling tool for capacity planning in acute and community stroke
> services. BMC Health Serv Res. 2016 Sep 29;16(1):530. doi:
> 10.1186/s12913-016-1789-4. PMID: 27688152; PMCID: PMC5043535.

It is organised into:

- Set-up
- Base case
  - Run the model
  - Figure 1
  - Theory: probability of delay
  - Figure 3
- Scenario analysis: altering arrivals
  - Scenario 1
  - Table 2
  - Scenario 4
  - Supplementary table 1
- Scenario analysis: pooling beds
  - Theory: pooling beds
  - Scenario 2

## Set-up

Install the latest version of the local simulation package. If running
sequentially, `devtools::load_all()` is sufficient. If running in
parallel, you must use `devtools::install()`.

``` r
devtools::install(upgrade = "never")
```

    ## ── R CMD build ─────────────────────────────────────────────────────────────────
    ##      checking for file ‘/home/amy/Documents/stars/rdesrap_stroke/DESCRIPTION’ ...  ✔  checking for file ‘/home/amy/Documents/stars/rdesrap_stroke/DESCRIPTION’
    ##   ─  preparing ‘simulation’:
    ##    checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
    ##   ─  checking for LF line-endings in source and make files and shell scripts
    ##   ─  checking for empty or unneeded directories
    ##      Removed empty directory ‘simulation/tests’
    ##      Omitted ‘LazyData’ from DESCRIPTION
    ##   ─  building ‘simulation_0.1.0.tar.gz’
    ##      
    ## Running /opt/R/4.4.1/lib/R/bin/R CMD INSTALL \
    ##   /tmp/RtmpMp1vQU/simulation_0.1.0.tar.gz --install-tests 
    ## * installing to library ‘/home/amy/.cache/R/renv/library/rdesrap_stroke-34041c45/linux-ubuntu-noble/R-4.4/x86_64-pc-linux-gnu’
    ## * installing *source* package ‘simulation’ ...
    ## ** using staged installation
    ## ** R
    ## ** byte-compile and prepare package for lazy loading
    ## ** help
    ## *** installing help indices
    ## ** building package indices
    ## ** testing if installed package can be loaded from temporary location
    ## ** testing if installed package can be loaded from final location
    ## ** testing if installed package keeps a record of temporary installation path
    ## * DONE (simulation)

``` r
# nolint start: undesirable_function_linter
# Import required packages.
library(dplyr, warn.conflicts = FALSE)
library(simulation)
# nolint end
```

``` r
start_time <- Sys.time()
```

``` r
output_dir <- file.path("..", "outputs")
```

## Base case

### Run the model

``` r
# Run 150 replications in parallel with nine cores
param <- create_parameters(cores = 9)
results <- runner(param = param)
```

``` r
get_occupancy_stats(results[["occupancy"]])
```

    ## $asu_bed
    ##    beds  freq          pct        c_pct   prob_delay 1_in_n_delay
    ## 1     0   308 7.029556e-04 0.0007029556 1.000000e+00            1
    ## 2     1  1226 2.798128e-03 0.0035010841 7.992177e-01            1
    ## 3     2  4209 9.606299e-03 0.0131073833 7.328922e-01            1
    ## 4     3 11377 2.596599e-02 0.0390733767 6.645444e-01            2
    ## 5     4 23564 5.378067e-02 0.0928540454 5.791958e-01            2
    ## 6     5 38040 8.681958e-02 0.1796736278 4.832072e-01            2
    ## 7     6 51198 1.168504e-01 0.2965240215 3.940672e-01            3
    ## 8     7 59316 1.353783e-01 0.4319023166 3.134466e-01            3
    ## 9     8 60197 1.373890e-01 0.5692913386 2.413334e-01            4
    ## 10    9 54216 1.237384e-01 0.6930297843 1.785471e-01            6
    ## 11   10 44311 1.011320e-01 0.7941618167 1.273444e-01            8
    ## 12   11 33131 7.561566e-02 0.8697774735 8.693678e-02           12
    ## 13   12 23018 5.253452e-02 0.9223119936 5.695960e-02           18
    ## 14   13 14547 3.320096e-02 0.9555129522 3.474674e-02           29
    ## 15   14  8801 2.008673e-02 0.9755996805 2.058911e-02           49
    ## 16   15  4974 1.135228e-02 0.9869519571 1.150236e-02           87
    ## 17   16  2661 6.073263e-03 0.9930252197 6.115920e-03          164
    ## 18   17  1464 3.341321e-03 0.9963665411 3.353506e-03          298
    ## 19   18   739 1.686637e-03 0.9980531781 1.689927e-03          592
    ## 20   19   387 8.832592e-04 0.9989364373 8.841996e-04         1131
    ## 21   20   193 4.404884e-04 0.9993769257 4.407630e-04         2269
    ## 22   21   115 2.624672e-04 0.9996393929 2.625619e-04         3809
    ## 23   22    60 1.369394e-04 0.9997763323 1.369700e-04         7301
    ## 24   23    49 1.118338e-04 0.9998881662 1.118464e-04         8941
    ## 25   24    22 5.021111e-05 0.9999383773 5.021421e-05        19915
    ## 26   25     5 1.141162e-05 0.9999497889 1.141219e-05        87626
    ## 27   26     5 1.141162e-05 0.9999612005 1.141206e-05        87627
    ## 28   27     8 1.825859e-05 0.9999794591 1.825896e-05        54768
    ## 29   28     3 6.846970e-06 0.9999863061 6.847064e-06       146048
    ## 30   29     1 2.282323e-06 0.9999885884 2.282349e-06       438145
    ## 31   30     3 6.846970e-06 0.9999954354 6.847001e-06       146049
    ## 32   31     2 4.564647e-06 1.0000000000 4.564647e-06       219075
    ## 
    ## $rehab_bed
    ##    beds  freq          pct       c_pct   prob_delay 1_in_n_delay
    ## 1     0   821 1.873788e-03 0.001873788 1.000000e+00            1
    ## 2     1   848 1.935410e-03 0.003809198 5.080887e-01            2
    ## 3     2  1849 4.220016e-03 0.008029214 5.255827e-01            2
    ## 4     3  5023 1.146411e-02 0.019493324 5.881044e-01            2
    ## 5     4 10445 2.383887e-02 0.043332192 5.501422e-01            2
    ## 6     5 19382 4.423599e-02 0.087568184 5.051606e-01            2
    ## 7     6 30817 7.033436e-02 0.157902545 4.454289e-01            2
    ## 8     7 42712 9.748260e-02 0.255385142 3.817082e-01            3
    ## 9     8 52752 1.203971e-01 0.375782266 3.203906e-01            3
    ## 10    9 56620 1.292252e-01 0.505007418 2.558876e-01            4
    ## 11   10 54017 1.232843e-01 0.628291681 1.962214e-01            5
    ## 12   11 46859 1.069474e-01 0.735239073 1.454593e-01            7
    ## 13   12 37876 8.644528e-02 0.821684355 1.052050e-01           10
    ## 14   13 28532 6.511925e-02 0.886803606 7.343142e-02           14
    ## 15   14 19619 4.477690e-02 0.931580509 4.806552e-02           21
    ## 16   15 13015 2.970444e-02 0.961284948 3.090076e-02           32
    ## 17   16  7887 1.800068e-02 0.979285633 1.838144e-02           54
    ## 18   17  4573 1.043706e-02 0.989722698 1.054544e-02           95
    ## 19   18  2334 5.326943e-03 0.995049641 5.353444e-03          187
    ## 20   19  1151 2.626954e-03 0.997676595 2.633072e-03          380
    ## 21   20   574 1.310054e-03 0.998986648 1.311383e-03          763
    ## 22   21   249 5.682985e-04 0.999554947 5.685516e-04         1759
    ## 23   22    97 2.213854e-04 0.999776332 2.214349e-04         4516
    ## 24   23    59 1.346571e-04 0.999910989 1.346691e-04         7426
    ## 25   24    25 5.705809e-05 0.999968047 5.705991e-05        17525
    ## 26   25    11 2.510556e-05 0.999993153 2.510573e-05        39832
    ## 27   26     3 6.846970e-06 1.000000000 6.846970e-06       146050

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

    ## Notebook run time: 1m 22s
