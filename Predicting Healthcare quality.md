# Structure of Data
![structure of healthcare](https://user-images.githubusercontent.com/46609482/59382122-cf191a00-8d11-11e9-9bcd-25e0b7a842e3.PNG)

Poor care is the dependent variable to predict(0 if patient din't recieve poor care & 1 if patient recieved poor care)

# Baseline Model's(i.e. average of most frequent outcome of depenedent variable)

accuracy of baseline model to comapare it with logistic regression model later

![baseline model accuracy](https://user-images.githubusercontent.com/46609482/59383274-6aab8a00-8d14-11e9-9a21-14cf159a60a8.PNG)

Since 75% of 131 patients are value "0" or not received not PoorCare, 25% of 131 patients are value "1" or recieved poor care.
therefore, baseline model has an accuracy of 75% in predicting value "0" and 25% in predicting value "1"

# Logistic regression model with predictors OfficeVisits & Narcotics trained on training set(splitted the data randomly into training and testing set) 
![log model with two predictors](https://user-images.githubusercontent.com/46609482/59384078-35a03700-8d16-11e9-8262-1e2fba9b0aeb.PNG)

Notice, both of the predictors/regressors are significant in the model.

# Logistic regression model does better than Baseline model in predicting value"1" or patient who recieved poor care

Comparing actual outcome of Poor care Variable(i.e. 0 & 1) with predicted probabilities to see the average of all the probalilities in predicting value"1" & "0".

![logistic model predicting power](https://user-images.githubusercontent.com/46609482/59386307-32f41080-8d1b-11e9-8849-cdcc70e88698.PNG)

Therefore this logistic regression model with predictor OfficeVisits & Narcotics predicted the value"1" with 43% power/certainty as compare to baseline method which had 25% accuracy in predicting value "1".

# Assesing the accuracy of the logistic model on training set with different threshold values by creating confusion matrix
![accuracy at different Thresholds](https://user-images.githubusercontent.com/46609482/59387626-83b93880-8d1e-11e9-83c6-d80712feba8d.PNG)

![threshold at 0 2](https://user-images.githubusercontent.com/46609482/59387694-ac413280-8d1e-11e9-85ae-72f24856e40c.PNG)

#  ROC(Receiver Operator Characteristic) Curve to visualize and decide on thresh-hold values
![ROCcurve](https://user-images.githubusercontent.com/46609482/59390123-312f4a80-8d25-11e9-8bb0-fc1a443e8b7f.PNG)

Around the thresh-hold value of 3.0 seems like a good value with reasonable false posituve rate and decent true positive rate

# Computed AUC(Area under the Curve) to asses the strength of the model on training set
![auc predTrain](https://user-images.githubusercontent.com/46609482/59390940-8d936980-8d27-11e9-84fc-74c1d6db9162.PNG)

AUC of 0.77 means the model will predict the right outcome 77% of times as compare to purely guessing which would've AUC of 50%[since "0" & "1" are 2 outcomes, guessing would've 1/2 or 50-50 chance]

# Now predicting "Poor Care"(the dependent variable) on Test set

confusion matrix of predicted values vs actual outcomes of test data at 0.3 thresh-hold value
![pred on testset](https://user-images.githubusercontent.com/46609482/59391520-6342ab80-8d29-11e9-993b-3c7f24f21739.PNG)

# Computed AUC(Area under the Curve) to asses the strength of the model on Test set
![auc on test set](https://user-images.githubusercontent.com/46609482/59391678-ecf27900-8d29-11e9-802b-22172058c9a0.PNG)

AUC of 0.79 means the model will predict the right outcome 79% of times as compare to purely guessing which would've AUC of 50%[since "0" & "1" are 2 outcomes, guessing would've 1/2 or 50-50 chance]









