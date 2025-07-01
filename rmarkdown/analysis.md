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
    ##   0.447345 |   arrival: asu_other0       |  activity: Timeout          | 1
    ##   0.524544 |   arrival: asu_neuro0       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##   0.524544 |    source: asu_neuro        |       new: asu_neuro1       | 5.82851
    ##   0.524544 |   arrival: asu_neuro0       |  activity: Timeout          | 1
    ##   0.906218 |   arrival: asu_stroke0      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##   0.906218 |    source: asu_stroke       |       new: asu_stroke1      | 2.39134
    ##   0.906218 |   arrival: asu_stroke0      |  activity: Timeout          | 1
    ##    2.39134 |   arrival: asu_stroke1      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    2.39134 |    source: asu_stroke       |       new: asu_stroke2      | 3.85858
    ##    2.39134 |   arrival: asu_stroke1      |  activity: Timeout          | 1
    ##    3.50836 |   arrival: asu_other1       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    3.50836 |    source: asu_other        |       new: asu_other2       | 6.8829
    ##    3.50836 |   arrival: asu_other1       |  activity: Timeout          | 1
    ##    3.85858 |   arrival: asu_stroke2      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    3.85858 |    source: asu_stroke       |       new: asu_stroke3      | 4.09754
    ##    3.85858 |   arrival: asu_stroke2      |  activity: Timeout          | 1
    ##    4.09754 |   arrival: asu_stroke3      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    4.09754 |    source: asu_stroke       |       new: asu_stroke4      | 6.34878
    ##    4.09754 |   arrival: asu_stroke3      |  activity: Timeout          | 1
    ##    5.82851 |   arrival: asu_neuro1       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    5.82851 |    source: asu_neuro        |       new: asu_neuro2       | 7.04147
    ##    5.82851 |   arrival: asu_neuro1       |  activity: Timeout          | 1
    ##    6.34878 |   arrival: asu_stroke4      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    6.34878 |    source: asu_stroke       |       new: asu_stroke5      | 9.1862
    ##    6.34878 |   arrival: asu_stroke4      |  activity: Timeout          | 1
    ##     6.8829 |   arrival: asu_other2       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##     6.8829 |    source: asu_other        |       new: asu_other3       | 7.82408
    ##     6.8829 |   arrival: asu_other2       |  activity: Timeout          | 1
    ##    7.04147 |   arrival: asu_neuro2       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    7.04147 |    source: asu_neuro        |       new: asu_neuro3       | 7.42333
    ##    7.04147 |   arrival: asu_neuro2       |  activity: Timeout          | 1
    ##    7.42333 |   arrival: asu_neuro3       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    7.42333 |    source: asu_neuro        |       new: asu_neuro4       | 9.50669
    ##    7.42333 |   arrival: asu_neuro3       |  activity: Timeout          | 1
    ##    7.82408 |   arrival: asu_other3       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    7.82408 |    source: asu_other        |       new: asu_other4       | 11.5787
    ##    7.82408 |   arrival: asu_other3       |  activity: Timeout          | 1
    ##     9.1862 |   arrival: asu_stroke5      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##     9.1862 |    source: asu_stroke       |       new: asu_stroke6      | 9.38982
    ##     9.1862 |   arrival: asu_stroke5      |  activity: Timeout          | 1
    ##    9.38982 |   arrival: asu_stroke6      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    9.38982 |    source: asu_stroke       |       new: asu_stroke7      | 12.5949
    ##    9.38982 |   arrival: asu_stroke6      |  activity: Timeout          | 1
    ##     9.5063 |   arrival: rehab_stroke0    |  activity: Timeout          | 1
    ##     9.5063 |    source: rehab_stroke     |       new: rehab_stroke1    | 30.3958
    ##    9.50669 |   arrival: asu_neuro4       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    9.50669 |    source: asu_neuro        |       new: asu_neuro5       | 10.6731
    ##    9.50669 |   arrival: asu_neuro4       |  activity: Timeout          | 1
    ##    10.6731 |   arrival: asu_neuro5       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    10.6731 |    source: asu_neuro        |       new: asu_neuro6       | 11.4058
    ##    10.6731 |   arrival: asu_neuro5       |  activity: Timeout          | 1
    ##    10.9893 |   arrival: asu_tia0         |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    10.9893 |    source: asu_tia          |       new: asu_tia1         | 13.7955
    ##    10.9893 |   arrival: asu_tia0         |  activity: Timeout          | 1
    ##    11.4058 |   arrival: asu_neuro6       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    11.4058 |    source: asu_neuro        |       new: asu_neuro7       | 14.1113
    ##    11.4058 |   arrival: asu_neuro6       |  activity: Timeout          | 1
    ##    11.5787 |   arrival: asu_other4       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    11.5787 |    source: asu_other        |       new: asu_other5       | 14.9369
    ##    11.5787 |   arrival: asu_other4       |  activity: Timeout          | 1
    ##    12.5949 |   arrival: asu_stroke7      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    12.5949 |    source: asu_stroke       |       new: asu_stroke8      | 13.8908
    ##    12.5949 |   arrival: asu_stroke7      |  activity: Timeout          | 1
    ##    13.7955 |   arrival: asu_tia1         |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    13.7955 |    source: asu_tia          |       new: asu_tia2         | 25.8135
    ##    13.7955 |   arrival: asu_tia1         |  activity: Timeout          | 1
    ##    13.8908 |   arrival: asu_stroke8      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    13.8908 |    source: asu_stroke       |       new: asu_stroke9      | 14.5563
    ##    13.8908 |   arrival: asu_stroke8      |  activity: Timeout          | 1
    ##    14.1113 |   arrival: asu_neuro7       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.1113 |    source: asu_neuro        |       new: asu_neuro8       | 17.6048
    ##    14.1113 |   arrival: asu_neuro7       |  activity: Timeout          | 1
    ##    14.5563 |   arrival: asu_stroke9      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.5563 |    source: asu_stroke       |       new: asu_stroke10     | 15.1733
    ##    14.5563 |   arrival: asu_stroke9      |  activity: Timeout          | 1
    ##    14.9369 |   arrival: asu_other5       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    14.9369 |    source: asu_other        |       new: asu_other6       | 16.2881
    ##    14.9369 |   arrival: asu_other5       |  activity: Timeout          | 1
    ##    15.1733 |   arrival: asu_stroke10     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    15.1733 |    source: asu_stroke       |       new: asu_stroke11     | 16.8859
    ##    15.1733 |   arrival: asu_stroke10     |  activity: Timeout          | 1
    ##    16.2881 |   arrival: asu_other6       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    16.2881 |    source: asu_other        |       new: asu_other7       | 18.0158
    ##    16.2881 |   arrival: asu_other6       |  activity: Timeout          | 1
    ##    16.8859 |   arrival: asu_stroke11     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    16.8859 |    source: asu_stroke       |       new: asu_stroke12     | 18.4861
    ##    16.8859 |   arrival: asu_stroke11     |  activity: Timeout          | 1
    ##    17.6048 |   arrival: asu_neuro8       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    17.6048 |    source: asu_neuro        |       new: asu_neuro9       | 18.3603
    ##    17.6048 |   arrival: asu_neuro8       |  activity: Timeout          | 1
    ##    18.0158 |   arrival: asu_other7       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.0158 |    source: asu_other        |       new: asu_other8       | 21.5547
    ##    18.0158 |   arrival: asu_other7       |  activity: Timeout          | 1
    ##    18.3603 |   arrival: asu_neuro9       |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.3603 |    source: asu_neuro        |       new: asu_neuro10      | 18.6831
    ##    18.3603 |   arrival: asu_neuro9       |  activity: Timeout          | 1
    ##    18.4861 |   arrival: asu_stroke12     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.4861 |    source: asu_stroke       |       new: asu_stroke13     | 18.9841
    ##    18.4861 |   arrival: asu_stroke12     |  activity: Timeout          | 1
    ##    18.6831 |   arrival: asu_neuro10      |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.6831 |    source: asu_neuro        |       new: asu_neuro11      | 22.7153
    ##    18.6831 |   arrival: asu_neuro10      |  activity: Timeout          | 1
    ##    18.9841 |   arrival: asu_stroke13     |  activity: SetAttribute     | [post_asu_destination], function(), 0, N, 0
    ##    18.9841 |    source: asu_stroke       |       new: asu_stroke14     | 20.8705
    ##    18.9841 |   arrival: asu_stroke13     |  activity: Timeout          | 1

    ## $arrivals
    ## [1] name          start_time    end_time      activity_time resource     
    ## <0 rows> (or 0-length row.names)
    ## 
    ## $resources
    ## [1] resource   time       server     queue      capacity   queue_size system    
    ## [8] limit     
    ## <0 rows> (or 0-length row.names)
