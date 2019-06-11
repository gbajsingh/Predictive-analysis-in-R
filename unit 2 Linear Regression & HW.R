
# From predicting wine price
> wine = read.csv("wine.csv")

> str(wine)
'data.frame':	25 obs. of  7 variables:
$ Year       : int  1952 1953 1955 1957 1958 1959 1960 1961 1962 1963 ...
$ Price      : num  7.5 8.04 7.69 6.98 6.78 ...
$ WinterRain : int  600 690 502 420 582 485 763 830 697 608 ...
$ AGST       : num  17.1 16.7 17.1 16.1 16.4 ...
$ HarvestRain: int  160 80 130 110 187 187 290 38 52 155 ...
$ Age        : int  31 30 28 26 25 24 23 22 21 20 ...
$ FrancePop  : num  43184 43495 44218 45152 45654 ...

> summary(wine)
Year          Price         WinterRain         AGST      
Min.   :1952   Min.   :6.205   Min.   :376.0   Min.   :14.98  
1st Qu.:1960   1st Qu.:6.519   1st Qu.:536.0   1st Qu.:16.20  
Median :1966   Median :7.121   Median :600.0   Median :16.53  
Mean   :1966   Mean   :7.067   Mean   :605.3   Mean   :16.51  
3rd Qu.:1972   3rd Qu.:7.495   3rd Qu.:697.0   3rd Qu.:17.07  
Max.   :1978   Max.   :8.494   Max.   :830.0   Max.   :17.65  
HarvestRain         Age         FrancePop    
Min.   : 38.0   Min.   : 5.0   Min.   :43184  
1st Qu.: 89.0   1st Qu.:11.0   1st Qu.:46584  
Median :130.0   Median :17.0   Median :50255  
Mean   :148.6   Mean   :17.2   Mean   :49694  
3rd Qu.:187.0   3rd Qu.:23.0   3rd Qu.:52894  
Max.   :292.0   Max.   :31.0   Max.   :54602  

# to create a linear model of linear regression use lm(Dependent/Predictive Variable ~ Independent Variable, data=df)
> model1 = lm(Price ~ AGST, data=wine)

# to view the summary of linear model use summary()
> summary(model1)

Call:
  lm(formula = Price ~ AGST, data = wine)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.78450 -0.23882 -0.03727  0.38992  0.90318 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -3.4178     2.4935  -1.371 0.183710    
AGST          0.6351     0.1509   4.208 0.000335 ***
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.4993 on 23 degrees of freedom
Multiple R-squared:  0.435,	Adjusted R-squared:  0.4105 
F-statistic: 17.71 on 1 and 23 DF,  p-value: 0.000335
# Estimate Column is coef of intercept and coef of independent variable(slope of regression line)
# Std.Error Column is coef of std.deviation(varied) of intercept and independent variable(std.dev. of slope of regression line)
# t-value column is estimate/std.Error or how many std.deviation away is the estimate from 0
# Pr(>|t|) column is probability of how likely t or greater value. if its very unlikely(For e.g. 0.00035) its's significant
# Multiple R-squared is R^2
# Adjusted R-squared is to account for the number of independent variables used relative to the number of data points.
# (Notice, Multiple R-Squared will always increase if you add more independent variables 
# whereas Adjusted R-squared will decrease if you add the independent variable that doesn't help the model or not significant)

# to view all the residuals
> model1$residuals
1           2           3           4           5           6           7           8           9 
0.04204258  0.82983774  0.21169394  0.15609432 -0.23119140  0.38991701 -0.48959140  0.90318115  0.45372410 
10          11          12          13          14          15          16          17          18 
0.14887461 -0.23882157 -0.08974238  0.66185660 -0.05211511 -0.62726647 -0.74714947  0.42113502 -0.03727441 
19          20          21          22          23          24          25 
0.10685278 -0.78450270 -0.64017590 -0.05508720 -0.67055321 -0.22040381  0.55866518 

# sum of squared error(SSE) or Squared error of regression line(SE_line i.e. mentiones in statistic notes)
> ssE = sum(model1$residuals^2)
> ssE
[1] 5.734875

# to create a linear model of multi-linear regression use lm(Dependent/Predictive Variable ~ Independent Variable1 + Independent Variable2, data=df)
> model2 = lm(Price ~ AGST + HarvestRain, data=wine)
> summary(model2)

Call:
  lm(formula = Price ~ AGST + HarvestRain, data = wine)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.88321 -0.19600  0.06178  0.15379  0.59722 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -2.20265    1.85443  -1.188 0.247585    
AGST         0.60262    0.11128   5.415 1.94e-05 ***
HarvestRain -0.00457    0.00101  -4.525 0.000167 ***
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3674 on 22 degrees of freedom
Multiple R-squared:  0.7074,	Adjusted R-squared:  0.6808 
F-statistic: 26.59 on 2 and 22 DF,  p-value: 1.347e-06

> SSE = sum(model2$residuals^2)
> SSE
[1] 2.970373

# addidng all the Independent variables to the model and notice Multiple R-squared went up
# but Adjusted R-Squared went down since insignificant Ind.variable such as FrancePop is added
> model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data=wine)
> summary(model3)

Call:
  lm(formula = Price ~ AGST + HarvestRain + WinterRain + Age + 
       FrancePop, data = wine)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.48179 -0.24662 -0.00726  0.22012  0.51987 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -4.504e-01  1.019e+01  -0.044 0.965202    
AGST         6.012e-01  1.030e-01   5.836 1.27e-05 ***
HarvestRain -3.958e-03  8.751e-04  -4.523 0.000233 ***
WinterRain   1.043e-03  5.310e-04   1.963 0.064416 .  
Age          5.847e-04  7.900e-02   0.007 0.994172    
FrancePop   -4.953e-05  1.667e-04  -0.297 0.769578    
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.3019 on 19 degrees of freedom
Multiple R-squared:  0.8294,	Adjusted R-squared:  0.7845 
F-statistic: 18.47 on 5 and 19 DF,  p-value: 1.044e-06

> SSE = sum(model3$residuals^2)
> SSE
[1] 1.732113

# removing both Age and FrancePop Independent Variables from the model and notice Multiple R-squared and Adjusted R-squared went down.
> summary(model5)

Call:
  lm(formula = Price ~ AGST + HarvestRain + WinterRain, data = wine)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.67472 -0.12958  0.01973  0.20751  0.63846 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept) -4.3016263  2.0366743  -2.112 0.046831 *  
  AGST         0.6810242  0.1117011   6.097 4.75e-06 ***
  HarvestRain -0.0039481  0.0009987  -3.953 0.000726 ***
  WinterRain   0.0011765  0.0005920   1.987 0.060097 .  
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.345 on 21 degrees of freedom
Multiple R-squared:  0.7537,	Adjusted R-squared:  0.7185 
F-statistic: 21.42 on 3 and 21 DF,  p-value: 1.359e-06


# adding Age Ind.Variable to the model.
# Notice Age is significant now and Adjusted R-squared went up compare to Adjusted R_squared when all Ind.variables were added to the model
# This seems like a best model
> model4 = lm(Price ~ AGST + HarvestRain + WinterRain + Age, data=wine)
> summary(model4)

Call:
  lm(formula = Price ~ AGST + HarvestRain + WinterRain + Age, data = wine)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.45470 -0.24273  0.00752  0.19773  0.53637 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -3.4299802  1.7658975  -1.942 0.066311 .  
AGST         0.6072093  0.0987022   6.152  5.2e-06 ***
  HarvestRain -0.0039715  0.0008538  -4.652 0.000154 ***
  WinterRain   0.0010755  0.0005073   2.120 0.046694 *  
  Age          0.0239308  0.0080969   2.956 0.007819 ** 
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.295 on 20 degrees of freedom
Multiple R-squared:  0.8286,	Adjusted R-squared:  0.7943 
F-statistic: 24.17 on 4 and 20 DF,  p-value: 2.036e-07


# Adding FrancePop but removing Age Ind.Variable from the model gives us almost same Adjusted R-squared as the model where Age is kept and FrancePop Ind.variable is removed
# Notice though FrancePop Ind.Variable is unintuitive means there is no actual relation between France popuplation and price of wine but there is a realtion between Age of wine and  price of wine
> model6 = lm(Price ~ AGST + HarvestRain + WinterRain + FrancePop, data=wine)
> summary(model6)

Call:
  lm(formula = Price ~ AGST + HarvestRain + WinterRain + FrancePop, 
     data = wine)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.48252 -0.24636 -0.00699  0.22089  0.51949 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -3.768e-01  2.180e+00  -0.173 0.864529    
AGST         6.011e-01  9.898e-02   6.073 6.17e-06 ***
HarvestRain -3.958e-03  8.518e-04  -4.646 0.000156 ***
WinterRain   1.042e-03  5.070e-04   2.055 0.053202 .  
FrancePop   -5.075e-05  1.704e-05  -2.978 0.007434 ** 
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.2943 on 20 degrees of freedom
Multiple R-squared:  0.8294,	Adjusted R-squared:  0.7952 
F-statistic:  24.3 on 4 and 20 DF,  p-value: 1.945e-07

# so why is keeping one of the Ind.Variables(Age & FrancePop) shows the variable with significance(two stars) but no significance when added both and hence better Adjusted R-squared?
# Because there is a multicollinearity isssue(i.e. two variables are highly correlated)
# to view the correlation coef between two variables use cor(df$variable1, df$variable2)
> cor(wine$WinterRain, wine$Price)
[1] 0.1366505
> cor(wine$Age, wine$FrancePop)
[1] -0.9944851

# to view the correlation coef betweeen every variable use cor(df)
> cor(wine)
                   Year      Price   WinterRain        AGST HarvestRain         Age    FrancePop
Year         1.00000000 -0.4477679  0.016970024 -0.24691585  0.02800907 -1.00000000  0.994485097
Price       -0.44776786  1.0000000  0.136650547  0.65956286 -0.56332190  0.44776786 -0.466861641
WinterRain   0.01697002  0.1366505  1.000000000 -0.32109061 -0.27544085 -0.01697002 -0.001621627
AGST        -0.24691585  0.6595629 -0.321090611  1.00000000 -0.06449593  0.24691585 -0.259162274
HarvestRain  0.02800907 -0.5633219 -0.275440854 -0.06449593  1.00000000 -0.02800907  0.041264394
Age         -1.00000000  0.4477679 -0.016970024  0.24691585 -0.02800907  1.00000000 -0.994485097
FrancePop    0.99448510 -0.4668616 -0.001621627 -0.25916227  0.04126439 -0.99448510  1.000000000

# now for the prediction test read test data
> wineTest = read.csv("wine_test.csv")
> str(wineTest)
'data.frame':	2 obs. of  7 variables:
  $ Year       : int  1979 1980
$ Price      : num  6.95 6.5
$ WinterRain : int  717 578
$ AGST       : num  16.2 16
$ HarvestRain: int  122 74
$ Age        : int  4 3
$ FrancePop  : num  54836 55110

# to predict the dependent variable(i.e. price of wine) based on best model(i.e. model4) use predict(model, newdata=)
> predictTest = predict(model4, newdata = wineTest)
> predictTest
       1        2 
6.768925 6.684910 

# to compute R-squared(i.e. 1 -  SSE/SST) compute the sum of squared error(i.e.====> SSE = sum((actual-predicted)^2) <====)
# and total sum of squares(i.e.====> SST = sum((actual-average of dependent variable)^2) <====)
> SSE =sum((wineTest$Price - predictTest)^2)
> SST =sum((wineTest$Price - mean(wine$Price))^2)
> 1 - SSE/SST
[1] 0.7944278







# From moneyball baseball
> baseball = read.csv("baseball.csv")
> str(baseball)
'data.frame':	1232 obs. of  15 variables:
  $ Team        : Factor w/ 39 levels "ANA","ARI","ATL",..: 2 3 4 5 7 8 9 10 11 12 ...
$ League      : Factor w/ 2 levels "AL","NL": 2 2 1 1 2 1 2 1 2 1 ...
$ Year        : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
$ RS          : int  734 700 712 734 613 748 669 667 758 726 ...
$ RA          : int  688 600 705 806 759 676 588 845 890 670 ...
$ W           : int  81 94 93 69 61 85 97 68 64 88 ...
$ OBP         : num  0.328 0.32 0.311 0.315 0.302 0.318 0.315 0.324 0.33 0.335 ...
$ SLG         : num  0.418 0.389 0.417 0.415 0.378 0.422 0.411 0.381 0.436 0.422 ...
$ BA          : num  0.259 0.247 0.247 0.26 0.24 0.255 0.251 0.251 0.274 0.268 ...
$ Playoffs    : int  0 1 1 0 0 0 1 0 0 1 ...
$ RankSeason  : int  NA 4 5 NA NA NA 2 NA NA 6 ...
$ RankPlayoffs: int  NA 5 4 NA NA NA 4 NA NA 2 ...
$ G           : int  162 162 162 162 162 162 162 162 162 162 ...
$ OOBP        : num  0.317 0.306 0.315 0.331 0.335 0.319 0.305 0.336 0.357 0.314 ...
$ OSLG        : num  0.415 0.378 0.403 0.428 0.424 0.405 0.39 0.43 0.47 0.402 ...
> moneyball = subset(baseball, year < 2002)

# since we're trying to confirm Paul DePodesta's claim, we'll use the data prior to 2002
> moneyball = subset(baseball, Year < 2002)

# creating a new independent variable RD(Run difference) to measure the difference between Run Scored and Run allowed
> moneyball$RD = moneyball$RS - moneyball$RA
> str(moneyball)
'data.frame':	902 obs. of  16 variables:
  $ Team        : Factor w/ 39 levels "ANA","ARI","ATL",..: 1 2 3 4 5 7 8 9 10 11 ...
$ League      : Factor w/ 2 levels "AL","NL": 1 2 2 1 1 2 1 2 1 2 ...
$ Year        : int  2001 2001 2001 2001 2001 2001 2001 2001 2001 2001 ...
$ RS          : int  691 818 729 687 772 777 798 735 897 923 ...
$ RA          : int  730 677 643 829 745 701 795 850 821 906 ...
$ W           : int  75 92 88 63 82 88 83 66 91 73 ...
$ OBP         : num  0.327 0.341 0.324 0.319 0.334 0.336 0.334 0.324 0.35 0.354 ...
$ SLG         : num  0.405 0.442 0.412 0.38 0.439 0.43 0.451 0.419 0.458 0.483 ...
$ BA          : num  0.261 0.267 0.26 0.248 0.266 0.261 0.268 0.262 0.278 0.292 ...
$ Playoffs    : int  0 1 1 0 0 0 0 0 1 0 ...
$ RankSeason  : int  NA 5 7 NA NA NA NA NA 6 NA ...
$ RankPlayoffs: int  NA 1 3 NA NA NA NA NA 4 NA ...
$ G           : int  162 162 162 162 161 162 162 162 162 162 ...
$ OOBP        : num  0.331 0.311 0.314 0.337 0.329 0.321 0.334 0.341 0.341 0.35 ...
$ OSLG        : num  0.412 0.404 0.384 0.439 0.393 0.398 0.427 0.455 0.417 0.48 ...
$ RD          : int  -39 141 86 -142 27 76 3 -115 76 17 ...

# checking the relationship between Wins and RD by creating a scatter plot
> plot(moneyball$RD, moneyball$W)

# creating a linear model to predict Wins based on Run difference 
> WinsReg = lm(W ~ RD, data=moneyball)
> summary(WinsReg)

Call:
  lm(formula = W ~ RD, data = moneyball)

Residuals:
  Min       1Q   Median       3Q      Max 
-14.2662  -2.6509   0.1234   2.9364  11.6570 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 80.881375   0.131157  616.67   <2e-16 ***
RD           0.105766   0.001297   81.55   <2e-16 ***
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.939 on 900 degrees of freedom
Multiple R-squared:  0.8808,	Adjusted R-squared:  0.8807 
F-statistic:  6651 on 1 and 900 DF,  p-value: < 2.2e-16

# since in the claim Paul suggested that they need to win 95 or more games in order to make the playoffs
# we want to see how much RD (i.e.  how many more runs need to be scored) to win 95 games?
# From our linear model(WinsReg) Intercept + (coef)RD = W
# 80.881375 + (0.105766)RD >= 95
# RD >= (95 - 80.881375)/(0.105766)  
# RD >= 133.4

# creating a linear model to predict Runs scored(RS) of a team based on following Independent variables:
# On-base Percentage(OBP i.e. Percentage of times a player gets on Base including walks)
# Slugging Percentage(SLG i.e. How far a player gets around the bases on his turns(measures Power))
# Batting Average(BA i.e. How often a hitter gets on base by hitting the ball)
> RunsReg = lm(RS ~ OBP + SLG + BA, data=moneyball)
> summary(RunsReg)

Call:
  lm(formula = RS ~ OBP + SLG + BA, data = moneyball)

Residuals:
  Min      1Q  Median      3Q     Max 
-70.941 -17.247  -0.621  16.754  90.998 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -788.46      19.70 -40.029  < 2e-16 ***
  OBP          2917.42     110.47  26.410  < 2e-16 ***
  SLG          1637.93      45.99  35.612  < 2e-16 ***
  BA           -368.97     130.58  -2.826  0.00482 ** 
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 24.69 on 898 degrees of freedom
Multiple R-squared:  0.9302,	Adjusted R-squared:   0.93 
F-statistic:  3989 on 3 and 898 DF,  p-value: < 2.2e-16
# ^ Notice coef of BA is negative which implies a team with the lower BA will score more runs which is counterintuitive.
# This is because of thse three vraiables are higly correlated(Multicollinearity)

# lets create a new linear model with only OBP and SLG
> RunsReg = lm(RS ~ OBP + SLG, data=moneyball)
> summary(RunsReg)

Call:
  lm(formula = RS ~ OBP + SLG, data = moneyball)

Residuals:
  Min      1Q  Median      3Q     Max 
-70.838 -17.174  -1.108  16.770  90.036 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -804.63      18.92  -42.53   <2e-16 ***
  OBP          2737.77      90.68   30.19   <2e-16 ***
  SLG          1584.91      42.16   37.60   <2e-16 ***
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 24.79 on 899 degrees of freedom
Multiple R-squared:  0.9296,	Adjusted R-squared:  0.9294 
F-statistic:  5934 on 2 and 899 DF,  p-value: < 2.2e-16

# Now creating a linear model to predict Runs allowed to opponent's team by a team using OOBP & OSLG independent variables
> RunsAllowedReg = lm(RA ~ OOBP + OSLG, data=moneyball)
> summary(RunsAllowedReg)

Call:
  lm(formula = RA ~ OOBP + OSLG, data = moneyball)

Residuals:
  Min      1Q  Median      3Q     Max 
-82.397 -15.178  -0.129  17.679  60.955 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)  -837.38      60.26 -13.897  < 2e-16 ***
  OOBP         2913.60     291.97   9.979 4.46e-16 ***
  OSLG         1514.29     175.43   8.632 2.55e-13 ***
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 25.67 on 87 degrees of freedom
(812 observations deleted due to missingness)
Multiple R-squared:  0.9073,	Adjusted R-squared:  0.9052 
F-statistic: 425.8 on 2 and 87 DF,  p-value: < 2.2e-16






# From Recitation NBA
> NBA = read.csv("NBA_train.csv")
> str(NBA) # in FGA, X2PA & X3PA "A" stands for attempted and "X" is by default since R doesn't like the variable starts with number
'data.frame':	835 obs. of  20 variables:
  $ SeasonEnd: int  1980 1980 1980 1980 1980 1980 1980 1980 1980 1980 ...
$ Team     : Factor w/ 37 levels "Atlanta Hawks",..: 1 2 5 6 8 9 10 11 12 13 ...
$ Playoffs : int  1 1 0 0 0 0 0 1 0 1 ...
$ W        : int  50 61 30 37 30 16 24 41 37 47 ...
$ PTS      : int  8573 9303 8813 9360 8878 8933 8493 9084 9119 8860 ...
$ oppPTS   : int  8334 8664 9035 9332 9240 9609 8853 9070 9176 8603 ...
$ FG       : int  3261 3617 3362 3811 3462 3643 3527 3599 3639 3582 ...
$ FGA      : int  7027 7387 6943 8041 7470 7596 7318 7496 7689 7489 ...
$ X2P      : int  3248 3455 3292 3775 3379 3586 3500 3495 3551 3557 ...
$ X2PA     : int  6952 6965 6668 7854 7215 7377 7197 7117 7375 7375 ...
$ X3P      : int  13 162 70 36 83 57 27 104 88 25 ...
$ X3PA     : int  75 422 275 187 255 219 121 379 314 114 ...
$ FT       : int  2038 1907 2019 1702 1871 1590 1412 1782 1753 1671 ...
$ FTA      : int  2645 2449 2592 2205 2539 2149 1914 2326 2333 2250 ...
$ ORB      : int  1369 1227 1115 1307 1311 1226 1155 1394 1398 1187 ...
$ DRB      : int  2406 2457 2465 2381 2524 2415 2437 2217 2326 2429 ...
$ AST      : int  1913 2198 2152 2108 2079 1950 2028 2149 2148 2123 ...
$ STL      : int  782 809 704 764 746 783 779 782 900 863 ...
$ BLK      : int  539 308 392 342 404 562 339 373 530 356 ...
$ TOV      : int  1495 1539 1684 1370 1533 1742 1492 1565 1517 1439 ...

# to see whats the typical number of game wins to get the team in play-offs use table() to compare number of  wins with number of times made it to play-offs/not(where made it to play-offs is 1 & not made it is 0)
> table(NBA$W, NBA$Playoffs)
    0  1
11  2  0
12  2  0
13  2  0
14  2  0
15 10  0
16  2  0
17 11  0
18  5  0
19 10  0
20 10  0
21 12  0
22 11  0
23 11  0
24 18  0
25 11  0
26 17  0
27 10  0
28 18  0
29 12  0
30 19  1
31 15  1
32 12  0
33 17  0
34 16  0
35 13  3
36 17  4
37 15  4
38  8  7
39 10 10
40  9 13
41 11 26
42  8 29
43  2 18
44  2 27
45  3 22
46  1 15
47  0 28
48  1 14
49  0 17
50  0 32
51  0 12
52  0 20
53  0 17
54  0 18
55  0 24
56  0 16
57  0 23
58  0 13
59  0 14
60  0  8
61  0 10
62  0 13
63  0  7
64  0  3
65  0  3
66  0  2
67  0  4
69  0  1
72  0  1
# ^so it takes about 42 games to win to make it in play-offs definitely or more likely
# But how many more points the team needs to score in a season to win 42 games?

# creating a variable to measure difference between team points and opponent points in a season(i.e. how many more points?)
> NBA$PTSdiff = NBA$PTS - NBA$oppPTS

# checking if there is strong relationship between Pointsdiff and Wins by plotting
> plot(NBA$PTSdiff, NBA$W)
# ^ yes thers is indeeed strong positive linear relationship

# creating a linear model to make the equation by obtaing coef and intercept to determine how many  more points(PTSdiff) to win 42 games
> WinsReg = lm(W ~ PTSdiff, data=NBA)
> summary(WinsReg)

Call:
  lm(formula = W ~ PTSdiff, data = NBA)

Residuals:
  Min      1Q  Median      3Q     Max 
-9.7393 -2.1018 -0.0672  2.0265 10.6026 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 4.100e+01  1.059e-01   387.0   <2e-16 ***
PTSdiff     3.259e-02  2.793e-04   116.7   <2e-16 ***
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.061 on 833 degrees of freedom
Multiple R-squared:  0.9423,	Adjusted R-squared:  0.9423 
F-statistic: 1.361e+04 on 1 and 833 DF,  p-value: < 2.2e-16
# W = 41 + (0.03259)PTSdiff
# 41 + (0.03259)PTSdiff >= 42
# PTSdiff >= (42 - 41)/0.03259
# PTSdiff >= 30.68

# cretaing a linear model to determine PTS 
> PointsReg = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + TOV + STL +BLK, data=NBA)
> summary(PointsReg)

Call:
  lm(formula = PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + TOV + 
       STL + BLK, data = NBA)

Residuals:
  Min      1Q  Median      3Q     Max 
-527.40 -119.83    7.83  120.67  564.71 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -2.051e+03  2.035e+02 -10.078   <2e-16 ***
X2PA         1.043e+00  2.957e-02  35.274   <2e-16 ***
X3PA         1.259e+00  3.843e-02  32.747   <2e-16 ***
FTA          1.128e+00  3.373e-02  33.440   <2e-16 ***
AST          8.858e-01  4.396e-02  20.150   <2e-16 ***
ORB         -9.554e-01  7.792e-02 -12.261   <2e-16 ***
DRB          3.883e-02  6.157e-02   0.631   0.5285    
TOV         -2.475e-02  6.118e-02  -0.405   0.6859    
STL         -1.992e-01  9.181e-02  -2.169   0.0303 *  
BLK         -5.576e-02  8.782e-02  -0.635   0.5256    
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 185.5 on 825 degrees of freedom
Multiple R-squared:  0.8992,	Adjusted R-squared:  0.8981 
F-statistic: 817.3 on 9 and 825 DF,  p-value: < 2.2e-16
# ^notice, lots of insignificant variables(such as DRB, TOV, BLK)

# checking SSE(Sum of Squared Error or  Sum of squared residuals) & RMSE(Root Mean Squared Error or std. deviation of residuals)
> SSE = sum(PointsReg$residuals^2)
> SSE
[1] 28394314
# ^since SSE is not interpetable because it's size depends on number of observations, we take the std. deviation of SSE(i.e. RMSE)

> RMSE = sqrt(SSE/nrow(NBA))
#or
> RMSE = sqrt(mean(PointsReg$residuals^2))
> RMSE
[1] 184.4049


# creating another linear model by removing insignificant variables intialy by one by one but in this case removing all of them
# to get more Adjusted R-squared 
> PointsReg2 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL, data=NBA)
> summary(PointsReg2)

Call:
  lm(formula = PTS ~ X2PA + X3PA + FTA + AST + ORB + STL, data = NBA)

Residuals:
  Min      1Q  Median      3Q     Max 
-523.33 -122.02    6.93  120.68  568.26 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept) -2.033e+03  1.629e+02 -12.475  < 2e-16 ***
  X2PA         1.050e+00  2.829e-02  37.117  < 2e-16 ***
  X3PA         1.273e+00  3.441e-02  37.001  < 2e-16 ***
  FTA          1.127e+00  3.260e-02  34.581  < 2e-16 ***
  AST          8.884e-01  4.292e-02  20.701  < 2e-16 ***
  ORB         -9.743e-01  7.465e-02 -13.051  < 2e-16 ***
  STL         -2.268e-01  8.350e-02  -2.717  0.00673 ** 
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 185.3 on 828 degrees of freedom
Multiple R-squared:  0.8991,	Adjusted R-squared:  0.8983 
F-statistic:  1229 on 6 and 828 DF,  p-value: < 2.2e-16

# checking if almost same SSE(Sum of Squared Error or  Sum of squared residuals) & RMSE(Root Mean Squared Error or std. deviation of residuals) to make sure we didn't inflate these too much
> SSE_2 = sum(PointsReg2$residuals^2)
> SSE_2
[1] 28421465

> RMSE_2 = sqrt(SSE_2/nrow(NBA))
> RMSE_2
[1]184.493
# so it seems we've narrowed down a much better model because it'simpler and more interpretable




# From HW2 Reading Test scores
> pisaTrain = read.csv("pisa2009train.csv")
> pisaTest = read.csv("pisa2009test.csv")
> str(pisaTrain)
'data.frame':	3663 obs. of  24 variables:
  $ grade                : int  11 11 9 10 10 10 10 10 9 10 ...
$ male                 : int  1 1 1 0 1 1 0 0 0 1 ...
$ raceeth              : Factor w/ 7 levels "American Indian/Alaska Native",..: NA 7 7 3 4 3 2 7 7 5 ...
$ preschool            : int  NA 0 1 1 1 1 0 1 1 1 ...
$ expectBachelors      : int  0 0 1 1 0 1 1 1 0 1 ...
$ motherHS             : int  NA 1 1 0 1 NA 1 1 1 1 ...
$ motherBachelors      : int  NA 1 1 0 0 NA 0 0 NA 1 ...
$ motherWork           : int  1 1 1 1 1 1 1 0 1 1 ...
$ fatherHS             : int  NA 1 1 1 1 1 NA 1 0 0 ...
$ fatherBachelors      : int  NA 0 NA 0 0 0 NA 0 NA 0 ...
$ fatherWork           : int  1 1 1 1 0 1 NA 1 1 1 ...
$ selfBornUS           : int  1 1 1 1 1 1 0 1 1 1 ...
$ motherBornUS         : int  0 1 1 1 1 1 1 1 1 1 ...
$ fatherBornUS         : int  0 1 1 1 0 1 NA 1 1 1 ...
$ englishAtHome        : int  0 1 1 1 1 1 1 1 1 1 ...
$ computerForSchoolwork: int  1 1 1 1 1 1 1 1 1 1 ...
$ read30MinsADay       : int  0 1 0 1 1 0 0 1 0 0 ...
$ minutesPerWeekEnglish: int  225 450 250 200 250 300 250 300 378 294 ...
$ studentsInEnglish    : int  NA 25 28 23 35 20 28 30 20 24 ...
$ schoolHasLibrary     : int  1 1 1 1 1 1 1 1 0 1 ...
$ publicSchool         : int  1 1 1 1 1 1 1 1 1 1 ...
$ urban                : int  1 0 0 1 1 0 1 0 1 0 ...
$ schoolSize           : int  673 1173 1233 2640 1095 227 2080 1913 502 899 ...
$ readingScore         : num  476 575 555 458 614 ...

# to find out the mean of male's reading score
> tapply(pisaTrain$readingScore, pisaTrain$male, mean)
0        1 
512.9406 483.5325 

# to omit out all the NA observations
> pisaTrain = na.omit(pisaTrain)
> pisaTest = na.omit(pisaTest)
# checking the number observations after omitting NA observations
> nrow(pisaTrain)
[1] 2414
> nrow(pisaTest)
[1] 990

# Factor variables are variables that take on a discrete set of values, like the "Region" variable in the WHO dataset from 
# the second lecture of Unit 1. This is an unordered factor because there isn't any natural ordering between the levels. 
# An ordered factor has a natural ordering between the levels (an example would be the classifications "large," "medium," and "small").

# To include unordered factors in a linear regression model, we define one level as the "reference level" and add a binary variable for each of the remaining levels.
# by default R selects the first level alphabetically ("American Indian/Alaska Native") as the reference level of our factor instead of the most common level ("White").
# Set the reference level of the factor by using relevel(df$variable, "name of category")
> pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")
> pisaTest$raceeth = relevel(pisaTest$raceeth, "White")

# to build a linear regression model using the training set to predict readingScore using all the remaining variables use the notation: 
# LinReg = lm(Y ~ ., data = Train) where"." means all the reaming variables
> lmScore = lm(readingScore ~., data=pisaTrain)
> summary(lmScore)

Call:
  lm(formula = readingScore ~ ., data = pisaTrain)

Residuals:
  Min      1Q  Median      3Q     Max 
-247.44  -48.86    1.86   49.77  217.18 

Coefficients:
                                                Estimate Std. Error t value Pr(>|t|)    
(Intercept)                                   143.766333  33.841226   4.248 2.24e-05 ***
grade                                          29.542707   2.937399  10.057  < 2e-16 ***
male                                          -14.521653   3.155926  -4.601 4.42e-06 ***
raceethAmerican Indian/Alaska Native          -67.277327  16.786935  -4.008 6.32e-05 ***
raceethAsian                                   -4.110325   9.220071  -0.446  0.65578    
raceethBlack                                  -67.012347   5.460883 -12.271  < 2e-16 ***
raceethHispanic                               -38.975486   5.177743  -7.528 7.29e-14 ***
raceethMore than one race                     -16.922522   8.496268  -1.992  0.04651 *  
raceethNative Hawaiian/Other Pacific Islander  -5.101601  17.005696  -0.300  0.76421    
preschool                                      -4.463670   3.486055  -1.280  0.20052    
expectBachelors                                55.267080   4.293893  12.871  < 2e-16 ***
motherHS                                        6.058774   6.091423   0.995  0.32001    
motherBachelors                                12.638068   3.861457   3.273  0.00108 ** 
motherWork                                     -2.809101   3.521827  -0.798  0.42517    
fatherHS                                        4.018214   5.579269   0.720  0.47147    
fatherBachelors                                16.929755   3.995253   4.237 2.35e-05 ***
fatherWork                                      5.842798   4.395978   1.329  0.18393    
selfBornUS                                     -3.806278   7.323718  -0.520  0.60331    
motherBornUS                                   -8.798153   6.587621  -1.336  0.18182    
fatherBornUS                                    4.306994   6.263875   0.688  0.49178    
englishAtHome                                   8.035685   6.859492   1.171  0.24153    
computerForSchoolwork                          22.500232   5.702562   3.946 8.19e-05 ***
read30MinsADay                                 34.871924   3.408447  10.231  < 2e-16 ***
minutesPerWeekEnglish                           0.012788   0.010712   1.194  0.23264    
studentsInEnglish                              -0.286631   0.227819  -1.258  0.20846    
schoolHasLibrary                               12.215085   9.264884   1.318  0.18749    
publicSchool                                  -16.857475   6.725614  -2.506  0.01226 *  
urban                                          -0.110132   3.962724  -0.028  0.97783    
schoolSize                                      0.006540   0.002197   2.977  0.00294 ** 
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 73.81 on 2385 degrees of freedom
Multiple R-squared:  0.3251,	Adjusted R-squared:  0.3172 
F-statistic: 41.04 on 28 and 2385 DF,  p-value: < 2.2e-16
# ^Comparing predictions for similar students
# Consider two students A and B. They have all variable values the same, except that student A is in grade 11 and student B is in grade 9. 
# "Question" ===> What is the predicted reading score of student A minus the predicted reading score of student B?
# "Answer" 59.09
# "Explaination" ===> The coefficient 29.54 on grade is the difference in reading score between two students who are identical other than having a difference in grade of 1. 
#                     Because A and B have a difference in grade of 2, the model predicts that student A has a reading score that is 2*29.54 larger.


# ^Interpreting model coefficients
# "Question" ===> What is the meaning of the coefficient associated with variable raceethAsian?
# "Answer"===> Predicted difference in the reading score between an Asian student and a white student who is otherwise identical
# "Explanation" ===> The only difference between an Asian student and white student with otherwise identical variables is that the former has raceethAsian=1 and the latter has raceethAsian=0.
#                    The predicted reading score for these two students will differ by the coefficient on the variable raceethAsian.

# calculate SSE(sum of square errors or sum of square residuals) and RMSE(Root Mean Squared Error or std dev. of residuals) of training data to compare it with prediction on test data later
> SSE = sum(lmScore$residuals^2)
> SSE
[1] 12993365
# ^since SSE is not interpetable because it's size depends on number of observations, we take the std. deviation of SSE(i.e. RMSE)
> RMSE = sqrt(mean(lmScore$residuals^2))
# or
> RMSE = sqrt(SSE/nrow(pisaTrain))
> RMSE
[1] 73.36555

# Predicting on unseen data
> predTest = predict(lmScore, newdata = pisaTest)

# checking SSE and RMSE of prediction on test data
> SSE_2 = sum((pisaTest$readingScore - predTest)^2)
> SSE_2
[1] 5762082 # Notice, SSE here is way smaller than SSE of train data(i.e. 12993365)
# ^since SSE is not interpetable because it's size depends on number of observations, we take the std. deviation of SSE(i.e. RMSE)
> RMSE_2 = sqrt(mean((pisaTest$readingScore - predTest)^2))
# or
> RMSE_2 = sqrt(SSE_2/nrow(pisaTest))
> RMSE_2
[1] 76.29079

# Calculate R-squared of prediction on test data by 1 - SSE/SST
> SST = sum((pisaTest$readingScore - mean(pisaTrain$readingScore))^2)
> R2_testData = 1-SSE/SST
> R2_testData
[1] 0.2614944




# From hw 4 state data(R built in data)

# to load the R built-in data use the function data(name of data frame)
> data(state)

# to convert to a data frame
> statedata = cbind(data.frame(state.x77), state.abb, state.area, state.center,  state.division, state.name, state.region)
> str(statedata)
'data.frame':	50 obs. of  15 variables:
  $ Population    : num  3615 365 2212 2110 21198 ...
$ Income        : num  3624 6315 4530 3378 5114 ...
$ Illiteracy    : num  2.1 1.5 1.8 1.9 1.1 0.7 1.1 0.9 1.3 2 ...
$ Life.Exp      : num  69 69.3 70.5 70.7 71.7 ...
$ Murder        : num  15.1 11.3 7.8 10.1 10.3 6.8 3.1 6.2 10.7 13.9 ...
$ HS.Grad       : num  41.3 66.7 58.1 39.9 62.6 63.9 56 54.6 52.6 40.6 ...
$ Frost         : num  20 152 15 65 20 166 139 103 11 60 ...
$ Area          : num  50708 566432 113417 51945 156361 ...
$ state.abb     : Factor w/ 50 levels "AK","AL","AR",..: 2 1 4 3 5 6 7 8 9 10 ...
$ state.area    : num  51609 589757 113909 53104 158693 ...
$ x             : num  -86.8 -127.2 -111.6 -92.3 -119.8 ...
$ y             : num  32.6 49.2 34.2 34.7 36.5 ...
$ state.division: Factor w/ 9 levels "New England",..: 4 9 8 5 9 8 1 3 3 3 ...
$ state.name    : Factor w/ 50 levels "Alabama","Alaska",..: 1 2 3 4 5 6 7 8 9 10 ...
$ state.region  : Factor w/ 4 levels "Northeast","South",..: 2 4 4 2 4 4 1 2 2 2 ...

# to plot the longitude(x-axis) vs latitude(y-axis)
> plot(statedata$x, statedata$y)

# determine which region of the US has the highest average high school graduation rate
> tapply(statedata$HS.Grad, statedata$state.region, mean)
Northeast     South   North Central          West 
53.96667      44.34375      54.51667      62.00000 

# to make a boxplot of the murder rate by region
> boxplot(statedata$Murder ~ statedata$state.region)

# creating a linear model to predict Life.Exp with potential variables
> LinReg = lm(Life.Exp ~ Population + Income + Illiteracy + Murder + HS.Grad + Frost + Area, data=statedata)
> summary(LinReg)

Call:
  lm(formula = Life.Exp ~ Population + Income + Illiteracy + Murder + 
       HS.Grad + Frost + Area, data = statedata)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.48895 -0.51232 -0.02747  0.57002  1.49447 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  7.094e+01  1.748e+00  40.586  < 2e-16 ***
Population   5.180e-05  2.919e-05   1.775   0.0832 .  
Income      -2.180e-05  2.444e-04  -0.089   0.9293    
Illiteracy   3.382e-02  3.663e-01   0.092   0.9269    
Murder      -3.011e-01  4.662e-02  -6.459 8.68e-08 ***
HS.Grad      4.893e-02  2.332e-02   2.098   0.0420 *  
Frost       -5.735e-03  3.143e-03  -1.825   0.0752 .  
Area        -7.383e-08  1.668e-06  -0.044   0.9649    
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.7448 on 42 degrees of freedom
Multiple R-squared:  0.7362,	Adjusted R-squared:  0.6922 
F-statistic: 16.74 on 7 and 42 DF,  p-value: 2.534e-10

# removing insignificant variables one by one based on highest insignificance level
> LinReg = lm(Life.Exp ~ Population + Income + Illiteracy + Murder + HS.Grad + Frost, data=statedata)
> summary(LinReg)

Call:
  lm(formula = Life.Exp ~ Population + Income + Illiteracy + Murder + 
       HS.Grad + Frost, data = statedata)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.49047 -0.52533 -0.02546  0.57160  1.50374 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  7.099e+01  1.387e+00  51.165  < 2e-16 ***
Population   5.188e-05  2.879e-05   1.802   0.0785 .  
Income      -2.444e-05  2.343e-04  -0.104   0.9174    
Illiteracy   2.846e-02  3.416e-01   0.083   0.9340    
Murder      -3.018e-01  4.334e-02  -6.963 1.45e-08 ***
HS.Grad      4.847e-02  2.067e-02   2.345   0.0237 *  
Frost       -5.776e-03  2.970e-03  -1.945   0.0584 .  
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.7361 on 43 degrees of freedom
Multiple R-squared:  0.7361,	Adjusted R-squared:  0.6993 
F-statistic: 19.99 on 6 and 43 DF,  p-value: 5.362e-11

> LinReg = lm(Life.Exp ~ Population + Income + Murder + HS.Grad + Frost, data=statedata)
> summary(LinReg)

Call:
  lm(formula = Life.Exp ~ Population + Income + Murder + HS.Grad + 
       Frost, data = statedata)

Residuals:
  Min      1Q  Median      3Q     Max 
-1.4892 -0.5122 -0.0329  0.5645  1.5166 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  7.107e+01  1.029e+00  69.067  < 2e-16 ***
Population   5.115e-05  2.709e-05   1.888   0.0657 .  
Income      -2.477e-05  2.316e-04  -0.107   0.9153    
Murder      -3.000e-01  3.704e-02  -8.099 2.91e-10 ***
HS.Grad      4.776e-02  1.859e-02   2.569   0.0137 *  
Frost       -5.910e-03  2.468e-03  -2.395   0.0210 *  
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.7277 on 44 degrees of freedom
Multiple R-squared:  0.7361,	Adjusted R-squared:  0.7061 
F-statistic: 24.55 on 5 and 44 DF,  p-value: 1.019e-11

# final model
> LinReg = lm(Life.Exp ~ Population + Murder + HS.Grad + Frost, data=statedata)
> summary(LinReg)

Call:
  lm(formula = Life.Exp ~ Population + Murder + HS.Grad + Frost, 
     data = statedata)

Residuals:
  Min       1Q   Median       3Q      Max 
-1.47095 -0.53464 -0.03701  0.57621  1.50683 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)  7.103e+01  9.529e-01  74.542  < 2e-16 ***
  Population   5.014e-05  2.512e-05   1.996  0.05201 .  
Murder      -3.001e-01  3.661e-02  -8.199 1.77e-10 ***
  HS.Grad      4.658e-02  1.483e-02   3.142  0.00297 ** 
  Frost       -5.943e-03  2.421e-03  -2.455  0.01802 *  
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.7197 on 45 degrees of freedom
Multiple R-squared:  0.736,	Adjusted R-squared:  0.7126 
F-statistic: 31.37 on 4 and 45 DF,  p-value: 1.696e-12

# predict Life.Exp on training data
#(since we are just looking at predictions on the training set, you don't need to pass a "newdata" argument to the predict function)
> predict(LinReg)
 Alabama         Alaska        Arizona       Arkansas     California       Colorado    Connecticut 
68.48112       69.85740       71.41416       69.57374       71.79565       71.10354       72.03459 
Delaware        Florida        Georgia         Hawaii          Idaho       Illinois        Indiana 
71.12647       70.61539       68.63694       72.09317       71.49989       70.19244       70.90159 
    Iowa         Kansas       Kentucky      Louisiana          Maine       Maryland  Massachusetts 
72.39653       71.90352       69.24418       69.15045       71.86095       70.51852       72.44105 
Michigan      Minnesota    Mississippi       Missouri        Montana       Nebraska         Nevada 
69.86893       72.26560       69.00535       70.10610       71.40025       72.17032       69.52482 
NewHampshire New Jersey     New Mexico       New York North Carolina   North Dakota           Ohio 
71.72636       71.59612       70.03119       70.62937       69.28624       71.87649       71.08549 
Oklahoma         Oregon   Pennsylvania   Rhode Island South Carolina   South Dakota      Tennessee 
71.15860       72.41445       71.38046       71.76007       69.06109       72.01161       69.46583 
   Texas           Utah        Vermont       Virginia     Washington  West Virginia      Wisconsin 
69.97886       72.05753       71.06135       70.14691       72.68272       70.44983       72.00996 
 Wyoming 
70.87679 
# ^Notice predict function spit-out the state names instead of numbers beacuse in our statedata we've named the rows by row.names





# From Hw 5 Predicting Elantra Sales
> Elantra = read.csv("elantra.csv")
> str(Elantra)
'data.frame':	50 obs. of  7 variables:
$ Month       : int  1 1 1 1 1 2 2 2 2 2 ...
$ Year        : int  2010 2011 2012 2013 2014 2010 2011 2012 2013 2014 ...
$ ElantraSales: int  7690 9659 10900 12174 15326 7966 12289 13820 16219 16393 ...
$ Unemployment: num  9.7 9.1 8.2 7.9 6.6 9.8 9 8.3 7.7 6.7 ...
$ Queries     : int  153 259 354 230 232 130 266 296 239 240 ...
$ CPI_energy  : num  213 229 244 243 248 ...
$ CPI_all     : num  217 221 228 231 235 ...

# spliting the dat into training and test
> ElantraTrain = subset(Elantra, Year <= 2012)
> ElantraTest = subset(Elantra, Year > 2012)

# creating a linear Model to predict sales
> ElantraLM = lm(ElantraSales ~ Unemployment + Queries + CPI_energy + CPI_all, data=ElantraTrain)
> summary(SalesReg)

Call:
  lm(formula = ElantraSales ~ Unemployment + Queries + CPI_energy + 
       CPI_all, data = ElantraTrain)

Residuals:
  Min      1Q  Median      3Q     Max 
-6785.2 -2101.8  -562.5  2901.7  7021.0 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)
(Intercept)   95385.36  170663.81   0.559    0.580
Unemployment  -3179.90    3610.26  -0.881    0.385
Queries          19.03      11.26   1.690    0.101
CPI_energy       38.51     109.60   0.351    0.728
CPI_all        -297.65     704.84  -0.422    0.676

Residual standard error: 3295 on 31 degrees of freedom
Multiple R-squared:  0.4282,	Adjusted R-squared:  0.3544 
F-statistic: 5.803 on 4 and 31 DF,  p-value: 0.00132

# creating a seasonal linear model by adding the month variable
> ElantraLM = lm(ElantraSales ~ Month + Unemployment + Queries + CPI_energy + CPI_all, data=ElantraTrain)
> summary(SeasonalSalesReg)

Call:
  lm(formula = ElantraSales ~ Month + Unemployment + Queries + 
       CPI_energy + CPI_all, data = ElantraTrain)

Residuals:
  Min      1Q  Median      3Q     Max 
-6416.6 -2068.7  -597.1  2616.3  7183.2 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)  
(Intercept)  148330.49  195373.51   0.759   0.4536  
Month           110.69     191.66   0.578   0.5679  
Unemployment  -4137.28    4008.56  -1.032   0.3103  
Queries          21.19      11.98   1.769   0.0871 .
CPI_energy       54.18     114.08   0.475   0.6382  
CPI_all        -517.99     808.26  -0.641   0.5265  
---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3331 on 30 degrees of freedom
Multiple R-squared:  0.4344,	Adjusted R-squared:  0.3402 
F-statistic: 4.609 on 5 and 30 DF,  p-value: 0.003078

# improving the seasonal Linear model by converting the month variable from numeric variable to factor variable use the function as.factor(df$variable)
> ElantraTrain$MonthFactor = as.factor(ElantraTrain$Month)
> ElantraTest$MonthFactor = as.factor(ElantraTest$Month) # changing in Test data as well
> ElantraLM = lm(ElantraSales ~ MonthFactor + Unemployment + Queries + CPI_energy + CPI_all, data=ElantraTrain)
> summary(ElantraLM)
Call:
  lm(formula = ElantraSales ~ MonthFactor + Unemployment + Queries + 
       CPI_energy + CPI_all, data = ElantraTrain)

Residuals:
  Min      1Q  Median      3Q     Max 
-3865.1 -1211.7   -77.1  1207.5  3562.2 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)   312509.280 144061.867   2.169 0.042288 *  
MonthFactor2    2254.998   1943.249   1.160 0.259540    
MonthFactor3    6696.557   1991.635   3.362 0.003099 ** 
MonthFactor4    7556.607   2038.022   3.708 0.001392 ** 
MonthFactor5    7420.249   1950.139   3.805 0.001110 ** 
MonthFactor6    9215.833   1995.230   4.619 0.000166 ***
MonthFactor7    9929.464   2238.800   4.435 0.000254 ***
MonthFactor8    7939.447   2064.629   3.845 0.001010 ** 
MonthFactor9    5013.287   2010.745   2.493 0.021542 *  
MonthFactor10   2500.184   2084.057   1.200 0.244286    
MonthFactor11   3238.932   2397.231   1.351 0.191747    
MonthFactor12   5293.911   2228.310   2.376 0.027621 *  
Unemployment   -7739.381   2968.747  -2.607 0.016871 *  
Queries           -4.764     12.938  -0.368 0.716598    
CPI_energy       288.631     97.974   2.946 0.007988 ** 
CPI_all        -1343.307    592.919  -2.266 0.034732 *  
  ---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 2306 on 20 degrees of freedom
Multiple R-squared:  0.8193,	Adjusted R-squared:  0.6837 
F-statistic: 6.044 on 15 and 20 DF,  p-value: 0.0001469

# refining the model more by removing the insignificant varaiable(i.e. variable Queries with highest insignificance)
> ElantraLM = lm(ElantraSales ~ MonthFactor + Unemployment + CPI_energy + CPI_all, data=ElantraTrain)
> summary(ElantraLM)

Call:
  lm(formula = ElantraSales ~ MonthFactor + Unemployment + CPI_energy + 
       CPI_all, data = ElantraTrain)

Residuals:
  Min      1Q  Median      3Q     Max 
-3866.0 -1283.3  -107.2  1098.3  3650.1 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)   325709.15  136627.85   2.384 0.026644 *  
MonthFactor2    2410.91    1857.10   1.298 0.208292    
MonthFactor3    6880.09    1888.15   3.644 0.001517 ** 
MonthFactor4    7697.36    1960.21   3.927 0.000774 ***
MonthFactor5    7444.64    1908.48   3.901 0.000823 ***
MonthFactor6    9223.13    1953.64   4.721 0.000116 ***
MonthFactor7    9602.72    2012.66   4.771 0.000103 ***
MonthFactor8    7919.50    2020.99   3.919 0.000789 ***
MonthFactor9    5074.29    1962.23   2.586 0.017237 *  
MonthFactor10   2724.24    1951.78   1.396 0.177366    
MonthFactor11   3665.08    2055.66   1.783 0.089062 .  
MonthFactor12   5643.19    1974.36   2.858 0.009413 ** 
Unemployment   -7971.34    2840.79  -2.806 0.010586 *  
CPI_energy       268.03      78.75   3.403 0.002676 ** 
CPI_all        -1377.58     573.39  -2.403 0.025610 *  
  ---
  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 2258 on 21 degrees of freedom
Multiple R-squared:  0.818,	Adjusted R-squared:  0.6967 
F-statistic: 6.744 on 14 and 21 DF,  p-value: 5.73e-05

# predicting on Test data with this new improved model
> PredTest = predict(ElantraLM, newdata=ElantraTest)

# calculating SSE, SST and R-squared
> SSE = sum((ElantraTest$ElantraSales - PredTest)^2)
> SSE
[1] 190757747
> SST = sum((ElantraTest$ElantraSales-mean(ElantraTrain$ElantraSales))^2)
> SST
[1] 701375142
> R2 = 1 - SSE/SST
> R2
[1] 0.7280232

# What is the largest absolute error that we make in our test set predictions?
> max(abs(ElantraTest$ElantraSales - PredTest))
[1] 7491.488

# In which period (Month,Year pair) do we make the largest absolute error in our prediction?
> which.max(abs(ElantraTest$ElantraSales - PredTest))
14 # this number "14" is the row number of orginal data before splitting into train and test 
5 
> ElantraTest$Month[5]
[1] 3
> ElantraTest$Year[5]
[1] 2013
# or put it in one line code
> ElantraTest$Month[which.max(abs(ElantraTest$ElantraSales - PredTest))]
[1] 3
> ElantraTest$Year[which.max(abs(ElantraTest$ElantraSales - PredTest))]
[1] 2013


