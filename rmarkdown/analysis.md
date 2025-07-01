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
    ##   0.447345 |   arrival: asu_other0       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##   0.447345 |    source: asu_other        |       new: asu_other1       | 3.50836
    ##   0.447345 |   arrival: asu_other0       |  activity: Timeout          | function()
    ##   0.524544 |   arrival: asu_neuro0       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##   0.524544 |    source: asu_neuro        |       new: asu_neuro1       | 5.53119
    ##   0.524544 |   arrival: asu_neuro0       |  activity: Timeout          | function()
    ##   0.906218 |   arrival: asu_stroke0      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##   0.906218 |    source: asu_stroke       |       new: asu_stroke1      | 2.37346
    ##   0.906218 |   arrival: asu_stroke0      |  activity: Timeout          | function()
    ##    2.37346 |   arrival: asu_stroke1      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    2.37346 |    source: asu_stroke       |       new: asu_stroke2      | 2.61241
    ##    2.37346 |   arrival: asu_stroke1      |  activity: Timeout          | function()
    ##    2.61241 |   arrival: asu_stroke2      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    2.61241 |    source: asu_stroke       |       new: asu_stroke3      | 3.01674
    ##    2.61241 |   arrival: asu_stroke2      |  activity: Timeout          | function()
    ##    3.01674 |   arrival: asu_stroke3      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    3.01674 |    source: asu_stroke       |       new: asu_stroke4      | 4.62263
    ##    3.01674 |   arrival: asu_stroke3      |  activity: Timeout          | function()
    ##    3.50836 |   arrival: asu_other1       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    3.50836 |    source: asu_other        |       new: asu_other2       | 3.84779
    ##    3.50836 |   arrival: asu_other1       |  activity: Timeout          | function()
    ##    3.84779 |   arrival: asu_other2       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    3.84779 |    source: asu_other        |       new: asu_other3       | 7.60239
    ##    3.84779 |   arrival: asu_other2       |  activity: Timeout          | function()
    ##    4.62263 |   arrival: asu_stroke4      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    4.62263 |    source: asu_stroke       |       new: asu_stroke5      | 6.34497
    ##    4.62263 |   arrival: asu_stroke4      |  activity: Timeout          | function()
    ##    5.53119 |   arrival: asu_neuro1       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    5.53119 |    source: asu_neuro        |       new: asu_neuro2       | 6.26383
    ##    5.53119 |   arrival: asu_neuro1       |  activity: Timeout          | function()
    ##    6.26383 |   arrival: asu_neuro2       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    6.26383 |    source: asu_neuro        |       new: asu_neuro3       | 8.96938
    ##    6.26383 |   arrival: asu_neuro2       |  activity: Timeout          | function()
    ##    6.34497 |   arrival: asu_stroke5      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    6.34497 |    source: asu_stroke       |       new: asu_stroke6      | 7.64083
    ##    6.34497 |   arrival: asu_stroke5      |  activity: Timeout          | function()
    ##    7.60239 |   arrival: asu_other3       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    7.60239 |    source: asu_other        |       new: asu_other4       | 8.46742
    ##    7.60239 |   arrival: asu_other3       |  activity: Timeout          | function()
    ##    7.64083 |   arrival: asu_stroke6      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    7.64083 |    source: asu_stroke       |       new: asu_stroke7      | 9.19258
    ##    7.64083 |   arrival: asu_stroke6      |  activity: Timeout          | function()
    ##    8.46742 |   arrival: asu_other4       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    8.46742 |    source: asu_other        |       new: asu_other5       | 9.81859
    ##    8.46742 |   arrival: asu_other4       |  activity: Timeout          | function()
    ##    8.96938 |   arrival: asu_neuro3       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    8.96938 |    source: asu_neuro        |       new: asu_neuro4       | 14.1071
    ##    8.96938 |   arrival: asu_neuro3       |  activity: Timeout          | function()
    ##    9.19258 |   arrival: asu_stroke7      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    9.19258 |    source: asu_stroke       |       new: asu_stroke8      | 10.3655
    ##    9.19258 |   arrival: asu_stroke7      |  activity: Timeout          | function()
    ##     9.5063 |   arrival: rehab_stroke0    |  activity: Timeout          | 1
    ##     9.5063 |    source: rehab_stroke     |       new: rehab_stroke1    | 33.6157
    ##    9.81859 |   arrival: asu_other5       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    9.81859 |    source: asu_other        |       new: asu_other6       | 10.1055
    ##    9.81859 |   arrival: asu_other5       |  activity: Timeout          | function()
    ##    10.1055 |   arrival: asu_other6       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    10.1055 |    source: asu_other        |       new: asu_other7       | 10.8968
    ##    10.1055 |   arrival: asu_other6       |  activity: Timeout          | function()
    ##    10.3655 |   arrival: asu_stroke8      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    10.3655 |    source: asu_stroke       |       new: asu_stroke9      | 13.6419
    ##    10.3655 |   arrival: asu_stroke8      |  activity: Timeout          | function()
    ##    10.8968 |   arrival: asu_other7       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    10.8968 |    source: asu_other        |       new: asu_other8       | 13.4996
    ##    10.8968 |   arrival: asu_other7       |  activity: Timeout          | function()
    ##    10.9893 |   arrival: asu_tia0         |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    10.9893 |    source: asu_tia          |       new: asu_tia1         | 27.5876
    ##    10.9893 |   arrival: asu_tia0         |  activity: Timeout          | function()
    ##    13.4996 |   arrival: asu_other8       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    13.4996 |    source: asu_other        |       new: asu_other9       | 14.7437
    ##    13.4996 |   arrival: asu_other8       |  activity: Timeout          | function()
    ##    13.6419 |   arrival: asu_stroke9      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    13.6419 |    source: asu_stroke       |       new: asu_stroke10     | 14.0806
    ##    13.6419 |   arrival: asu_stroke9      |  activity: Timeout          | function()
    ##    14.0806 |   arrival: asu_stroke10     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.0806 |    source: asu_stroke       |       new: asu_stroke11     | 14.631
    ##    14.0806 |   arrival: asu_stroke10     |  activity: Timeout          | function()
    ##    14.1071 |   arrival: asu_neuro4       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.1071 |    source: asu_neuro        |       new: asu_neuro5       | 24.0404
    ##    14.1071 |   arrival: asu_neuro4       |  activity: Timeout          | function()
    ##     14.631 |   arrival: asu_stroke11     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##     14.631 |    source: asu_stroke       |       new: asu_stroke12     | 15.8409
    ##     14.631 |   arrival: asu_stroke11     |  activity: Timeout          | function()
    ##    14.7437 |   arrival: asu_other9       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.7437 |    source: asu_other        |       new: asu_other10      | 14.9333
    ##    14.7437 |   arrival: asu_other9       |  activity: Timeout          | function()
    ##    14.9333 |   arrival: asu_other10      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.9333 |    source: asu_other        |       new: asu_other11      | 17.5967
    ##    14.9333 |   arrival: asu_other10      |  activity: Timeout          | function()
    ##    15.8409 |   arrival: asu_stroke12     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    15.8409 |    source: asu_stroke       |       new: asu_stroke13     | 15.8939
    ##    15.8409 |   arrival: asu_stroke12     |  activity: Timeout          | function()
    ##    15.8939 |   arrival: asu_stroke13     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    15.8939 |    source: asu_stroke       |       new: asu_stroke14     | 16.2069
    ##    15.8939 |   arrival: asu_stroke13     |  activity: Timeout          | function()
    ##    16.2069 |   arrival: asu_stroke14     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    16.2069 |    source: asu_stroke       |       new: asu_stroke15     | 17.6651
    ##    16.2069 |   arrival: asu_stroke14     |  activity: Timeout          | function()
    ##    17.5967 |   arrival: asu_other11      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    17.5967 |    source: asu_other        |       new: asu_other12      | 18.2707
    ##    17.5967 |   arrival: asu_other11      |  activity: Timeout          | function()
    ##    17.6651 |   arrival: asu_stroke15     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    17.6651 |    source: asu_stroke       |       new: asu_stroke16     | 18.0837
    ##    17.6651 |   arrival: asu_stroke15     |  activity: Timeout          | function()
    ##    18.0837 |   arrival: asu_stroke16     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.0837 |    source: asu_stroke       |       new: asu_stroke17     | 18.5393
    ##    18.0837 |   arrival: asu_stroke16     |  activity: Timeout          | function()
    ##    18.2707 |   arrival: asu_other12      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.2707 |    source: asu_other        |       new: asu_other13      | 20.9141
    ##    18.2707 |   arrival: asu_other12      |  activity: Timeout          | function()
    ##    18.5393 |   arrival: asu_stroke17     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.5393 |    source: asu_stroke       |       new: asu_stroke18     | 19.6973
    ##    18.5393 |   arrival: asu_stroke17     |  activity: Timeout          | function()
    ##    19.6973 |   arrival: asu_stroke18     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    19.6973 |    source: asu_stroke       |       new: asu_stroke19     | 19.7376
    ##    19.6973 |   arrival: asu_stroke18     |  activity: Timeout          | function()
    ##    19.7376 |   arrival: asu_stroke19     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    19.7376 |    source: asu_stroke       |       new: asu_stroke20     | 19.8883
    ##    19.7376 |   arrival: asu_stroke19     |  activity: Timeout          | function()
    ##    19.8883 |   arrival: asu_stroke20     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    19.8883 |    source: asu_stroke       |       new: asu_stroke21     | 19.9716
    ##    19.8883 |   arrival: asu_stroke20     |  activity: Timeout          | function()
    ##    19.9716 |   arrival: asu_stroke21     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    19.9716 |    source: asu_stroke       |       new: asu_stroke22     | 20.3305
    ##    19.9716 |   arrival: asu_stroke21     |  activity: Timeout          | function()

    ## $arrivals
    ## [1] name          start_time    end_time      activity_time resource     
    ## <0 rows> (or 0-length row.names)
    ## 
    ## $resources
    ## [1] resource   time       server     queue      capacity   queue_size system    
    ## [8] limit     
    ## <0 rows> (or 0-length row.names)
