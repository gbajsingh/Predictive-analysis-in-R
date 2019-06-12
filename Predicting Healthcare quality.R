install.packages("caTools")
install.packages("ROCR")
library(caTools)
library(ROCR)

# healthcare quality data
quality = read.csv("quality.csv")

# strucuture of data
str(quality)


# to view how many patients received poor(i.e. 1) vs good(i.e. 0) care
table(quality$PoorCare)

# split the data randomally into training & test set by setting the split ratio
split = sample.split(quality$PoorCare, SplitRatio = 0.75)

# subset the data into training and test set using TRUE & FALSE values from split
qualityTrain = subset(quality, split == TRUE)
qualityTest = subset(quality, split == FALSE)

# logistic regression model using predictors OfficeVisits & Narcotics
QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial) # "family=binomial" argument tells the glm function to build a logistic regression

# to view the summary of model
summary(QualityLog)

# predicting on the training data
predictTrain = predict(QualityLog, type = "response") # type = 'response' arguments tells the function that we want probabilities of predicting the value 1(i.e. P(y=1)) 

# to see the average/mean probability in predicting  if we're predicting actual value 1(i.e. in our case actual poor cases) with higher probability
# we use tapply() to first categorized the predicted probalilities with 1(i.e. actual poor cases) & 0(i.e. actual good cases) and then see the average of each case
tapply(predictTrain, qualityTrain$PoorCare, mean)
        0         1 
0.1894512 0.4392246
# ^so we predicted value 1(i.e. poor cases) with higher probaility than baseline method(i.e. accuracy of 0.25 or 25% in predicting value 1 or PoorCare)
# meaning we predicted the value 1 with sort of higher power/certainty



# Assesing the accuracy of predictions by creating confusion matrices at various thresh-hold values
# Sensitivity(i.e. True Pos. rate) = TP/(TP+FP)
# Specificity(i.e. True Neg. rate) = TN/(TN+FN)

# computing confusion matrix where threshhold is 0.5
table(qualityTrain$PoorCare, predictTrain > 0.5)
  
# computing confusion matrix where threshhold is large, 0.7
table(qualityTrain$PoorCare, predictTrain > 0.7)

# computing confusion matrix where threshhold is small, 0.2
table(qualityTrain$PoorCare, predictTrain > 0.2)



# to visualise the different thresh-hold values we can plot ROC(Receiver Operator Characteristic) Curve: 
# Where x-axis is False Pos. rate(i.e.1- specificity) and y-axis is True Pos. rate(i.e.sensitivity)
# Higher Threshhold(i.e closer to (0,0)): low senstivity & high specificity
# Lower Threshhold(i.e. closer to (1,1)): high sensitivity & low specificity

# first, we need to give the prediction() two arguments. Output of predict() we used above(i.e predictTrain) & the true outcomes(i.e. 1 and 0 in our case) of our data points(i.e. data points of our dependent variable PoorCare)
ROCRpredTrain = prediction(predictTrain, qualityTrain$PoorCare)

# Second, use performance() with first argument of output of prediction(), second argument x-axis and third argument y-axis
ROCRperf = performance(ROCRpredTrain, "tpr", "fpr") # "tpr"(True Pos. rate or senstivity), "fpr"(False Pos. rate or 1-specificity)

# Finally, we can plot the ROCR curve
plot(ROCRperf)
# to add color to the curve based on threshhold values add an argument colorize=TRUE
plot(ROCRperf, colorize=TRUE)
# to add the threshhold labels to the curve, add an argument print.cutoffs.at=seq(start,end,incriment)
# and also to adjust the label's text fitting add an argumet text.adj=c(for.e.g.-0.2,1.7) 
plot(ROCRperf, colorize=TRUE, print.cuttoffs.at=seq(0,1,0.1))

# computing AUC(Area under the curve)
auc = as.numeric(performance(ROCRpredTrain, "auc")@y.values)



# Now to predict the dependent varaible(i.e. PoorCare) on the test data
predictTest = predict(QualityLog, type="response", newdata = qualityTest)

# creating confusion matrix at thresh-hold value of 0.3
table(qualityTest$PoorCare, predictTest > 0.3)

# to calculate AUC set the ROC by using prediction()
ROCRpredTest = prediction(predictTest, qualityTest$PoorCare)

# computing AUC on test data
auc = as.numeric(performance(ROCRpredTest,"auc")@y.values)
# for instance AUC of 0.79 means 79% of times the model will predict the right outcome as compare to purely guessing which would've AUC of 50%[since "0" & "1" are 2 outcomes, guessing would've 1/2 or 50-50 chance]


