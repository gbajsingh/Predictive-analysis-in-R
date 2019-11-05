# Objective of the notebook
1. Analyze judge Stevens (1 of the 9 supreme court judges) 1994-2001 decision data.
2. Apply and compare decision tree, CART & random forest machine learning models on data to accurately predict the decison outcome.

# Required libraries

```r
library(caTools)
library(rpart)
library(caret)
library(e1071)
```
# Reading data

```r
stevens = read.csv("stevens.csv")
```
*__Reference__* : http://scdb.wustl.edu/data.php

# Structure of data
```r
str(stevens)
```
![str of data](https://user-images.githubusercontent.com/46609482/59403903-7ec5aa80-8d59-11e9-8284-a96d4c3cdaca.PNG)

# Variables/Attributes explained

*__Circuit__* : Circuit court of origin (1st-11th, DC, FED)

*__Issue__* : Issue area of case(e.g. civil rights, federal taxation)

*__Petitioner__* : Type of petitioner(eg. US, an employer)

*__Respondant__* : Type of respondent(eg. US, an employer)

*__LowerCourt__* : Idealogical direction of lower court decison(conservative vs liberal)

*__Unconstitutional__* : Whether petitioner argued that law/practice was onconstitutional. "0" if not & "1" if argued

*__Reverse__* : "1" if judge has turned/reverse the lower court's decision, "0" if affirmed (also the variable to predict)

# Summary of data
```r
summary(stevens)
```
![summary of Stevens](https://user-images.githubusercontent.com/46609482/59405675-28a83580-8d60-11e9-9d85-fee4f000ec51.PNG)

# Split the data into train and test 
```r
split = sample.split(stevens$Reverse, SplitRatio = 0.7)
Train =  subset(stevens, split == TRUE)
Test =  subset(stevens, split == FALSE)
```

# Training models

Train CART, Random Forest & CART with cross-validation to predict the outcome of variable *Reverse* by using regressors *Circuit*, *Issue*, *Petitioner*, *Respondent*, *LowerCourt* & *Unconstitutional*

*__CART__*

```r
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class", minbucket=25)
```
*The parameter minbucket's size was decided by what seemed reasonable. A smaller size creates more splits/subsets(Notice too small limit can also overfit the predictions on test data). A bigger size creates fewer splits/subsets.(Notice too large limit can have poor accuracy on test data).*


                                                Tree plot

![StevensTree](https://user-images.githubusercontent.com/46609482/59405165-51c7c680-8d5e-11e9-81c0-013d8f01fdbb.PNG)



*__Random Forest__*

```r
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, nodesize=25, ntree=200)
```
*The random forest method improves prediction accuracy by building many CART trees though less interpretable. Number of trees are set set to 200. Furhter each tree votes on the outcome and picks the outcome that receives the majority of votes. Nodesize is equivalent to minbucket.*

*__CART with cross-validation__*

*Cross-validation is performed to select the optimal value of "complexity parameter(cp)" instead of picking reasonable size for the " minbucket size"*

```r
# setting the number of folds and the grid to perform cross-validation
numFolds = trainControl(method="cv",number=10)
cpGrid = expand.grid(.cp=seq(0.01,0.5,0.01))

# performing cross validation
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)
```
![image](https://user-images.githubusercontent.com/46609482/68167620-ee138500-ff1a-11e9-9bb8-ff877749d0c5.png)

```r
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class", cp=0.17)
```
![StevensTreeCV](https://user-images.githubusercontent.com/46609482/59469752-9305b800-8dea-11e9-8873-ab6b5c523c96.PNG)

This CART with cross-validation model has only one split. Which is if the lower court decision is liberal or not?

# Predicting on the test set using above trained models

*__CART__*

```r
predictCART = predict(StevensTree, newdata=Test, type="class")
```

Confusion matrix to asses the accuracy of CART model

![CART on testSet](https://user-images.githubusercontent.com/46609482/59466136-600af680-8de1-11e9-8d07-b3f168151119.PNG)


*__Random Forest__*

```r
PredictForest = predict(StevensForest, newdata=Test)
```

Confusion matrix to asses the accuracy of randomForest model

![randomforest on tesSet](https://user-images.githubusercontent.com/46609482/59467393-6c448300-8de4-11e9-92ad-866e2759f25d.PNG)

68% accuracy compare to CART model that had 65% and baseline model that had 54%

*__CART model with cross validation__*

```r
PredictCV = predict(StevensTreeCV, newdata = Test, type="class")
```

Confusion matrix to asses the accuracy

![predictCV](https://user-images.githubusercontent.com/46609482/59470002-4ff81480-8deb-11e9-894e-27b2ef5167eb.PNG)

# Conclusion
72% accuracy is a great improvement over randomForest model that had 68% accuracy and CART model(without cross-validation) that had 65% accuracy and baseline model that had 54% accuracy.

In conclusion, the model with best accuracy only had one split(i.e. lower court decision is liberal or no?) which reminds that sometimes simplest models are the best.



