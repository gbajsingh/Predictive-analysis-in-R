# Structure of data

'data.frame':	25 obs. of  7 variables:

$ Year       : int  1952 1953 1955 1957 1958 1959 1960 1961 1962 1963 ...

$ Price      : num  7.5 8.04 7.69 6.98 6.78 ...

$ WinterRain : int  600 690 502 420 582 485 763 830 697 608 ...

$ AGST       : num  17.1 16.7 17.1 16.1 16.4 ...(Average Growing Season Temperature)

$ HarvestRain: int  160 80 130 110 187 187 290 38 52 155 ...

$ Age        : int  31 30 28 26 25 24 23 22 21 20 ...

$ FrancePop  : num  43184 43495 44218 45152 45654 ...

# Summary of data
![Wine data summary](https://user-images.githubusercontent.com/46609482/59311989-39718200-8c60-11e9-8c59-809b80287d3b.PNG)

# Linear model with one predictor/regressor AGST
![lm with one predictor](https://user-images.githubusercontent.com/46609482/59311893-f57e7d00-8c5f-11e9-99f7-dd2f11459b0e.PNG)

Here regressor/predictor AGST is very significant in predicting depending variable i.e. Price

Computed SSE(Sum of Squared Errors) of this model to compare with other linear models is 5.734875

# Linear model with two regressors/predictors AGST & Harvest Rain
![lm with two predictors](https://user-images.githubusercontent.com/46609482/59312601-9110ed00-8c62-11e9-8f75-22b1ad0523cb.PNG)

Adding another predictor has raised the R^2(i.e. how much variation in dependent variable explained by variation in independent variable/predictor/regressor) and Adjusted R^2 as well as both predictors are still significant.
Computed SSE for this model is reduced to 2.970373 which is another improvement.

# Linear model with all the predictors
![lm with all the predictors](https://user-images.githubusercontent.com/46609482/59312841-696e5480-8c63-11e9-8ca5-f3df2c53b288.PNG)

Both R^2 and Adjuted R^2 has raised again but having most of the predictors not significant. Which suggest the model might be overfitting.
Computed SSE is reduced to 1.732113

# Linear Model without insignificant variables to improve the model
![lm without insignificant predictors](https://user-images.githubusercontent.com/46609482/59313118-8192a380-8c64-11e9-8371-0c3e134b602c.PNG)
Notice Multiple R-squared and Adjusted R-squared went down.

# Linear Model with FrancePop ingnificant variable removed and AGE predictor added
![Lm with AGE variable added](https://user-images.githubusercontent.com/46609482/59313483-092ce200-8c66-11e9-85cc-4dc93cc30e6a.PNG)

Notice Age is significant now and Adjusted R-squared went up compare to Adjusted R_squared when all Ind.variables were added to the model. This will be the final model to predict on test data

# Side Note
Adding one of the predictor from Age & FrancePop makes the predictors in Linear Model significant but adding both makes most of the predictors insignificant. This is because Age & FrancePop are highly correlated. Multicollinearity issue!

Correlation among variables of Wine data
![cor wine data](https://user-images.githubusercontent.com/46609482/59378403-15b64680-8d09-11e9-8ba1-690d9e8c1000.PNG)


# Predicting on Test Data

predicted on 2 observations

       1        2 
6.768925 6.684910 

Computed R^2 by computing SSE(i.e. sum((actual-predicted)^2) & SST(i.e. sum((actual-average of dependent variable)^2)

R^2 = 1 - (SSE/SST) = 0.7944278




