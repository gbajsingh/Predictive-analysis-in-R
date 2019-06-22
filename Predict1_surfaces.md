Predicting floor type
================

libraries
---------

``` r
library(dplyr)
```

``` r
library(ggplot2)
library(rpart)
library(rpart.plot)
```


``` r
library(randomForest)
```

    



Data
----

``` r
train_X = read.csv("X_train.csv")
train_y = read.csv("y_train.csv")
test = read.csv("X_test.csv")
```

Summary and Structure
---------------------

``` r
str(train_X)
```

    ## 'data.frame':    487680 obs. of  13 variables:
    ##  $ row_id               : Factor w/ 487680 levels "0_0","0_1","0_10",..: 1 2 41 52 63 74 85 96 107 118 ...
    ##  $ series_id            : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ measurement_number   : int  0 1 2 3 4 5 6 7 8 9 ...
    ##  $ orientation_X        : num  -0.759 -0.759 -0.759 -0.759 -0.759 ...
    ##  $ orientation_Y        : num  -0.634 -0.634 -0.634 -0.634 -0.634 ...
    ##  $ orientation_Z        : num  -0.105 -0.105 -0.105 -0.105 -0.105 ...
    ##  $ orientation_W        : num  -0.106 -0.106 -0.106 -0.106 -0.106 ...
    ##  $ angular_velocity_X   : num  0.10765 0.06785 0.00727 -0.01305 0.00513 ...
    ##  $ angular_velocity_Y   : num  0.01756 0.02994 0.02893 0.01945 0.00765 ...
    ##  $ angular_velocity_Z   : num  0.000767 0.003386 -0.005978 -0.008974 0.005245 ...
    ##  $ linear_acceleration_X: num  -0.749 0.34 -0.264 0.427 -0.51 ...
    ##  $ linear_acceleration_Y: num  2.1 1.51 1.59 1.1 1.47 ...
    ##  $ linear_acceleration_Z: num  -9.75 -9.41 -8.73 -10.1 -10.44 ...

``` r
summary(train_X)
```

    ##      row_id         series_id    measurement_number orientation_X     
    ##  0_0    :     1   Min.   :   0   Min.   :  0.00     Min.   :-0.98910  
    ##  0_1    :     1   1st Qu.: 952   1st Qu.: 31.75     1st Qu.:-0.70512  
    ##  0_10   :     1   Median :1904   Median : 63.50     Median :-0.10596  
    ##  0_100  :     1   Mean   :1904   Mean   : 63.50     Mean   :-0.01805  
    ##  0_101  :     1   3rd Qu.:2857   3rd Qu.: 95.25     3rd Qu.: 0.65180  
    ##  0_102  :     1   Max.   :3809   Max.   :127.00     Max.   : 0.98910  
    ##  (Other):487674                                                       
    ##  orientation_Y      orientation_Z      orientation_W      
    ##  Min.   :-0.98965   Min.   :-0.16283   Min.   :-0.156620  
    ##  1st Qu.:-0.68898   1st Qu.:-0.08947   1st Qu.:-0.106060  
    ##  Median : 0.23786   Median : 0.03195   Median :-0.018704  
    ##  Mean   : 0.07506   Mean   : 0.01246   Mean   :-0.003804  
    ##  3rd Qu.: 0.80955   3rd Qu.: 0.12287   3rd Qu.: 0.097215  
    ##  Max.   : 0.98898   Max.   : 0.15571   Max.   : 0.154770  
    ##                                                           
    ##  angular_velocity_X   angular_velocity_Y  angular_velocity_Z 
    ##  Min.   :-2.3710000   Min.   :-0.927860   Min.   :-1.268800  
    ##  1st Qu.:-0.0407520   1st Qu.:-0.033191   1st Qu.:-0.090743  
    ##  Median : 0.0000842   Median : 0.005412   Median :-0.005335  
    ##  Mean   : 0.0001775   Mean   : 0.008338   Mean   :-0.019184  
    ##  3rd Qu.: 0.0405272   3rd Qu.: 0.048068   3rd Qu.: 0.064604  
    ##  Max.   : 2.2822000   Max.   : 1.079100   Max.   : 1.387300  
    ##                                                              
    ##  linear_acceleration_X linear_acceleration_Y linear_acceleration_Z
    ##  Min.   :-36.0670      Min.   :-121.490      Min.   :-75.386      
    ##  1st Qu.: -0.5308      1st Qu.:   1.958      1st Qu.:-10.193      
    ##  Median :  0.1250      Median :   2.880      Median : -9.365      
    ##  Mean   :  0.1293      Mean   :   2.886      Mean   : -9.365      
    ##  3rd Qu.:  0.7923      3rd Qu.:   3.799      3rd Qu.: -8.523      
    ##  Max.   : 36.7970      Max.   :  73.008      Max.   : 65.839      
    ## 

``` r
str(train_y)
```

    ## 'data.frame':    3810 obs. of  3 variables:
    ##  $ series_id: int  0 1 2 3 4 5 6 7 8 9 ...
    ##  $ group_id : int  13 31 20 31 22 1 34 31 33 11 ...
    ##  $ surface  : Factor w/ 9 levels "carpet","concrete",..: 3 2 2 2 7 8 6 2 5 8 ...

``` r
summary(train_y)
```

    ##    series_id         group_id                      surface   
    ##  Min.   :   0.0   Min.   : 0.0   concrete              :779  
    ##  1st Qu.: 952.2   1st Qu.:19.0   soft_pvc              :732  
    ##  Median :1904.5   Median :39.0   wood                  :607  
    ##  Mean   :1904.5   Mean   :37.6   tiled                 :514  
    ##  3rd Qu.:2856.8   3rd Qu.:55.0   fine_concrete         :363  
    ##  Max.   :3809.0   Max.   :72.0   hard_tiles_large_space:308  
    ##                                  (Other)               :507

Summary of Predicting Variable
------------------------------

``` r
summary(train_y$surface)
```

    ##                 carpet               concrete          fine_concrete 
    ##                    189                    779                    363 
    ##             hard_tiles hard_tiles_large_space               soft_pvc 
    ##                     21                    308                    732 
    ##             soft_tiles                  tiled                   wood 
    ##                    297                    514                    607

Frequency of predicting variable

``` r
ggplot(data=train_y, aes(x=surface, fill=surface))+ stat_count()+
  labs(title = "Freq. of predicting variable(surfaces)",
       x = "Surface", 
       y = "Count")+ scale_y_continuous(c(0,1000)) + 
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-8-1.png)

Feature Engineering
-------------------

First taking out non regressor/columns/attributes out of training and test set

``` r
train_X = subset(train_X,select=-c(measurement_number,row_id))
test = subset(test,select=-c(row_id,measurement_number))
```

Grouping rows by "series\_id" (since there are 128 measurments for each series) to obtain min, max, mean & standar dev. to use in the model

``` r
train_final <-train_X %>% group_by(series_id) %>% summarise_all(list(min=min,max=max,mean=mean,sd=sd))

test_final<- test %>% group_by(series_id) %>% summarise_all(list(min=min,max=max,mean=mean,sd=sd))
```

Now number of rows and columns in the new training and test dataframes

``` r
dim(train_final)
```

    ## [1] 3810   41

``` r
dim(test_final)
```

    ## [1] 3816   41

Merge "train\_y"" dataset(containing predicting variable i.e. surface) with "train\_final"" to create a model
-------------------------------------------------------------------------------------------------------------

Merging datasets by key " series\_id"

``` r
train_final = merge(train_final, train_y, by.x = "series_id", by.y = "series_id", all = TRUE)
```

Also, setting "group\_id" to NULL since it won't be used in the model

``` r
train_final$group_id = NULL
```

Visualizing mean velocity in X, Y, Z on all the surfaces
--------------------------------------------------------

``` r
ggplot(train_final, aes(x= surface, y=angular_velocity_X_mean, fill = surface)) + coord_cartesian(ylim = c(-0.05, 0.05)) +
geom_boxplot() + theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-14-1.png)

``` r
ggplot(train_final, aes(x= surface, y=angular_velocity_Y_mean, fill = surface)) + coord_cartesian(ylim = c(-0.10, 0.10)) +
geom_boxplot() + theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-15-1.png)

``` r
ggplot(train_final, aes(x= surface, y=angular_velocity_Z_mean, fill = surface)) + coord_cartesian(ylim = c(-0.50, 0.50)) +
geom_boxplot() + theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-16-1.png)

Visualizing acceleration mean in X, Y, Z on all the surfaces
------------------------------------------------------------

``` r
ggplot(train_final, aes(x= surface, y=linear_acceleration_X_mean, fill = surface)) + coord_cartesian(ylim = c(-0.5, 0.5)) +
geom_boxplot() + theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-17-1.png)

``` r
ggplot(train_final, aes(x= surface, y=linear_acceleration_Y_mean, fill = surface)) + coord_cartesian(ylim = c(2, 4)) +
geom_boxplot() + theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-18-1.png)

``` r
ggplot(train_final, aes(x= surface, y=linear_acceleration_Z_mean, fill = surface)) + coord_cartesian(ylim = c(-9.5, -9.25)) +
geom_boxplot() + theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   vjust = 1))
```

![](Predict1_surfaces_files/figure-markdown_github/unnamed-chunk-19-1.png)

Random Forest Model
-------------------

Tried different nodesize values to get the optimal value for highest accuracy of the model. Final nodesize value is 5

``` r
model = randomForest(surface~.-series_id,data=train_final,ntree=200,nodesize=5)
```

Predicting on trainig set

``` r
pred= predict(model, type="class")
table(train_final$surface, pred)
```

    ##                         pred
    ##                          carpet concrete fine_concrete hard_tiles
    ##   carpet                    158       13             0          0
    ##   concrete                    6      692             6          0
    ##   fine_concrete               0       24           289          0
    ##   hard_tiles                  0        0             0         12
    ##   hard_tiles_large_space      4       17             6          0
    ##   soft_pvc                    3       16             6          0
    ##   soft_tiles                  4        5             0          0
    ##   tiled                       5       17             4          1
    ##   wood                        6       14             9          0
    ##                         pred
    ##                          hard_tiles_large_space soft_pvc soft_tiles tiled
    ##   carpet                                      1        2          7     0
    ##   concrete                                   13       18          9    13
    ##   fine_concrete                               2       14          0     8
    ##   hard_tiles                                  0        0          2     0
    ##   hard_tiles_large_space                    270        2          0     0
    ##   soft_pvc                                    4      679          8     2
    ##   soft_tiles                                  0       10        268     4
    ##   tiled                                       4       11          3   460
    ##   wood                                        1       26          2    19
    ##                         pred
    ##                          wood
    ##   carpet                    8
    ##   concrete                 22
    ##   fine_concrete            26
    ##   hard_tiles                7
    ##   hard_tiles_large_space    9
    ##   soft_pvc                 14
    ##   soft_tiles                6
    ##   tiled                     9
    ##   wood                    530

Accuracy of model

``` r
(155+683+293+13+271+678+269+459+532)/nrow(train_final)
```

    ## [1] 0.8800525

Predicitng on Test set
----------------------

``` r
surface = predict(model, newdata = test_final, type = "class")
```

Saving predicted results to a new data frame & changing to appropriate column names

``` r
Submission = data.frame(test_final$series_id, surface)
colnames(Submission)[colnames(Submission)=="test_final.series_id"] <- "series_id"
```

Writing to a csv for Kaggle competition submission

``` r
write.csv(Submission,"Final_submission.csv",row.names = FALSE)
```

Accuracy on test set upon submitting: 0.6873 or 69%
