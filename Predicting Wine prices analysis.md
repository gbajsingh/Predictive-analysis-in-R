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

# Linear Model with only FrancePOP ingnificant variable removed and AGE predictor added

