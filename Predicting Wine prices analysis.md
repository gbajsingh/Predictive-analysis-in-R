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

