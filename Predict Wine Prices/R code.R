# wine data
wine = read.csv("wine.csv")
# to view structure of data
str(wine)

# to view summary of data
summary(wine)

# linear regression model by one dependent-variable/predictor/regressor AGST
model1 = lm(Price ~ AGST, data=wine)

# summary of linear model1
summary(model1)

# linear model residuals
model1$residuals

# sum of squared error(SSE) or Squared error of regression line
SSE = sum(model1$residuals^2)

# to create a linear model with multiple regressors/predictors
model2 = lm(Price ~ AGST + HarvestRain, data=wine)
summary(model2)
SSE = sum(model2$residuals^2)

# addidng all the Independent variables to the model and notice Multiple R-squared went up
# but Adjusted R-Squared went down since insignificant Ind.variable such as FrancePop is added
model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data=wine)
summary(model3)
SSE = sum(model3$residuals^2)

# removing both Age and FrancePop Independent Variables from the model and notice Multiple R-squared and Adjusted R-squared went down.
model4 = lm(Price ~ AGST + HarvestRain + WinterRain, data=wine)
summary(model4)

# adding Age Ind.Variable to the model.
model5 = lm(Price ~ AGST + HarvestRain + WinterRain + Age, data=wine)
summary(model5)
# Notice Age is significant now and Adjusted R-squared went up compare to Adjusted R_squared when all Ind.variables were added to the model
# This seems like a best model

# to view the correlation coef betweeen every variable
cor(wine)

# now for the prediction test read test data
wineTest = read.csv("wine_test.csv")

# to predict the dependent variable(i.e. price of wine) based on best model(i.e. model4)
predictTest = predict(model4, newdata = wineTest)

# to compute R-squared(i.e. 1 -  SSE/SST) compute the sum of squared error(i.e.====> SSE = sum((actual-predicted)^2) <====)
# and total sum of squares(i.e.====> SST = sum((actual-average of dependent variable)^2) <====)
SSE = sum((wineTest$Price - predictTest)^2)
SST = sum((wineTest$Price - mean(wine$Price))^2)
1 - SSE/SST


