analysis
================
Amy Heather
2025-07-01

``` r
# Load the package from the local directory
devtools::load_all()
```

    ## ℹ Loading simulation

``` r
# Load the package
library(simulation)
```

``` r
model(run_number = 1L, param = create_parameters(), set_seed = TRUE)
```

    ##          0 |    source: asu_stroke       |       new: asu_stroke0      | 0.906218
    ##          0 |    source: asu_tia          |       new: asu_tia0         | 10.9893
    ##          0 |    source: asu_neuro        |       new: asu_neuro0       | 0.524544
    ##          0 |    source: asu_other        |       new: asu_other0       | 0.447345
    ##          0 |    source: rehab_stroke     |       new: rehab_stroke0    | 9.5063
    ##          0 |    source: rehab_neuro      |       new: rehab_neuro0     | 91.7705
    ##          0 |    source: rehab_other      |       new: rehab_other0     | 35.1655
    ##   0.447345 |   arrival: asu_other0       |  activity: Timeout          | 1
    ##   0.447345 |    source: asu_other        |       new: asu_other1       | 2.17433
    ##   0.524544 |   arrival: asu_neuro0       |  activity: Timeout          | 1
    ##   0.524544 |    source: asu_neuro        |       new: asu_neuro1       | 3.96819
    ##   0.906218 |   arrival: asu_stroke0      |  activity: Timeout          | 1
    ##   0.906218 |    source: asu_stroke       |       new: asu_stroke1      | 1.08267
    ##    1.08267 |   arrival: asu_stroke1      |  activity: Timeout          | 1
    ##    1.08267 |    source: asu_stroke       |       new: asu_stroke2      | 2.75156
    ##    2.17433 |   arrival: asu_other1       |  activity: Timeout          | 1
    ##    2.17433 |    source: asu_other        |       new: asu_other2       | 4.61283
    ##    2.75156 |   arrival: asu_stroke2      |  activity: Timeout          | 1
    ##    2.75156 |    source: asu_stroke       |       new: asu_stroke3      | 4.23668
    ##    3.96819 |   arrival: asu_neuro1       |  activity: Timeout          | 1
    ##    3.96819 |    source: asu_neuro        |       new: asu_neuro2       | 19.8944
    ##    4.23668 |   arrival: asu_stroke3      |  activity: Timeout          | 1
    ##    4.23668 |    source: asu_stroke       |       new: asu_stroke4      | 5.50213
    ##    4.61283 |   arrival: asu_other2       |  activity: Timeout          | 1
    ##    4.61283 |    source: asu_other        |       new: asu_other3       | 7.92561
    ##    5.50213 |   arrival: asu_stroke4      |  activity: Timeout          | 1
    ##    5.50213 |    source: asu_stroke       |       new: asu_stroke5      | 7.75337
    ##    7.75337 |   arrival: asu_stroke5      |  activity: Timeout          | 1
    ##    7.75337 |    source: asu_stroke       |       new: asu_stroke6      | 8.53907
    ##    7.92561 |   arrival: asu_other3       |  activity: Timeout          | 1
    ##    7.92561 |    source: asu_other        |       new: asu_other4       | 9.00379
    ##    8.53907 |   arrival: asu_stroke6      |  activity: Timeout          | 1
    ##    8.53907 |    source: asu_stroke       |       new: asu_stroke7      | 9.24525
    ##    9.00379 |   arrival: asu_other4       |  activity: Timeout          | 1
    ##    9.00379 |    source: asu_other        |       new: asu_other5       | 16.5702
    ##    9.24525 |   arrival: asu_stroke7      |  activity: Timeout          | 1
    ##    9.24525 |    source: asu_stroke       |       new: asu_stroke8      | 10.0155
    ##     9.5063 |   arrival: rehab_stroke0    |  activity: Timeout          | 1
    ##     9.5063 |    source: rehab_stroke     |       new: rehab_stroke1    | 15.9181
    ##    10.0155 |   arrival: asu_stroke8      |  activity: Timeout          | 1
    ##    10.0155 |    source: asu_stroke       |       new: asu_stroke9      | 10.6946
    ##    10.6946 |   arrival: asu_stroke9      |  activity: Timeout          | 1
    ##    10.6946 |    source: asu_stroke       |       new: asu_stroke10     | 10.8218
    ##    10.8218 |   arrival: asu_stroke10     |  activity: Timeout          | 1
    ##    10.8218 |    source: asu_stroke       |       new: asu_stroke11     | 10.8932
    ##    10.8932 |   arrival: asu_stroke11     |  activity: Timeout          | 1
    ##    10.8932 |    source: asu_stroke       |       new: asu_stroke12     | 11.5876
    ##    10.9893 |   arrival: asu_tia0         |  activity: Timeout          | 1
    ##    10.9893 |    source: asu_tia          |       new: asu_tia1         | 47.8074
    ##    11.5876 |   arrival: asu_stroke12     |  activity: Timeout          | 1
    ##    11.5876 |    source: asu_stroke       |       new: asu_stroke13     | 12.9956
    ##    12.9956 |   arrival: asu_stroke13     |  activity: Timeout          | 1
    ##    12.9956 |    source: asu_stroke       |       new: asu_stroke14     | 14.1918
    ##    14.1918 |   arrival: asu_stroke14     |  activity: Timeout          | 1
    ##    14.1918 |    source: asu_stroke       |       new: asu_stroke15     | 15.9141
    ##    15.9141 |   arrival: asu_stroke15     |  activity: Timeout          | 1
    ##    15.9141 |    source: asu_stroke       |       new: asu_stroke16     | 15.9588
    ##    15.9181 |   arrival: rehab_stroke1    |  activity: Timeout          | 1
    ##    15.9181 |    source: rehab_stroke     |       new: rehab_stroke2    | 22.9815
    ##    15.9588 |   arrival: asu_stroke16     |  activity: Timeout          | 1
    ##    15.9588 |    source: asu_stroke       |       new: asu_stroke17     | 17.5434
    ##    16.5702 |   arrival: asu_other5       |  activity: Timeout          | 1
    ##    16.5702 |    source: asu_other        |       new: asu_other6       | 17.2215
    ##    17.2215 |   arrival: asu_other6       |  activity: Timeout          | 1
    ##    17.2215 |    source: asu_other        |       new: asu_other7       | 20.4942
    ##    17.5434 |   arrival: asu_stroke17     |  activity: Timeout          | 1
    ##    17.5434 |    source: asu_stroke       |       new: asu_stroke18     | 17.9055
    ##    17.9055 |   arrival: asu_stroke18     |  activity: Timeout          | 1
    ##    17.9055 |    source: asu_stroke       |       new: asu_stroke19     | 18.7757
    ##    18.7757 |   arrival: asu_stroke19     |  activity: Timeout          | 1
    ##    18.7757 |    source: asu_stroke       |       new: asu_stroke20     | 19.6776
    ##    19.6776 |   arrival: asu_stroke20     |  activity: Timeout          | 1
    ##    19.6776 |    source: asu_stroke       |       new: asu_stroke21     | 19.9596
    ##    19.8944 |   arrival: asu_neuro2       |  activity: Timeout          | 1
    ##    19.8944 |    source: asu_neuro        |       new: asu_neuro3       | 23.7819
    ##    19.9596 |   arrival: asu_stroke21     |  activity: Timeout          | 1
    ##    19.9596 |    source: asu_stroke       |       new: asu_stroke22     | 21.1935

    ## $arrivals
    ## [1] name          start_time    end_time      activity_time resource     
    ## <0 rows> (or 0-length row.names)
    ## 
    ## $resources
    ## [1] resource   time       server     queue      capacity   queue_size system    
    ## [8] limit     
    ## <0 rows> (or 0-length row.names)
