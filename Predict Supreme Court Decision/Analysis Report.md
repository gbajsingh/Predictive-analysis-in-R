# *Predicting supereme court's judge Stevens decision*
# Structure of data
![str of data](https://user-images.githubusercontent.com/46609482/59403903-7ec5aa80-8d59-11e9-8284-a96d4c3cdaca.PNG)

# Variables/Attributes explained

*__Circuit__*: Circuit court of origin (1st-11th, DC, FED)

*__Issue__*: Issue area of case(e.g. civil rights, federal taxation)

*__Petitioner__*: Type of petitioner(eg. US, an employer)

*__Respondant__*: Type of respondent(eg. US, an employer)

*__LowerCourt__*: Idealogical direction of lower court decison(conservative vs liberal)

*__Unconstitutional__*: Whether petitioner argued that law/practice was onconstitutional. "0" if not & "1" if argued

*__Reverse__*(also the variable to predict): "1" if judge has turned/reverse the lower court's decision, "0" if affirmed.

# Summary of data

![summary of Stevens](https://user-images.githubusercontent.com/46609482/59405675-28a83580-8d60-11e9-9d85-fee4f000ec51.PNG)

*Notice data has been randomally splitted into training and test set by split ratio of 0.7*

# CART(Classification and regression Tree) model(based on 6 predictors/regressors) trained on the training set to predict the variable "Reverse"

Predictors: Circuit, Issue, Petitioner, Respondent, LowerCourt & Unconstitutional


                                                Tree plot

![StevensTree](https://user-images.githubusercontent.com/46609482/59405165-51c7c680-8d5e-11e9-81c0-013d8f01fdbb.PNG)

*Notice the number of splits in the tree depends on the parameter called "minimum bucket size" when building the model.*

*A smaller minbucket size means more splits/subsets(too small limit can also overfit the predictions on test data)*

*A bigger minbucket size means fewer splits/subsets(too large limit can have poor accuracy on test data)*

# Predicting on the test set using the CART model

confusion matrix to asses the accuracy of CART model

![CART on testSet](https://user-images.githubusercontent.com/46609482/59466136-600af680-8de1-11e9-8d07-b3f168151119.PNG)

# Predicting on the test set using Random forest model based on same 6 predictors/regressors

*Notice the random forest method was designed to improve prediction accuracy of CART(classification And Regression Tree) model by building many CART trees though less interpretable. To make a prediction on a new observation, each tree votes on the outcome and we pick the outcome that receives the majority of votes*


Confusion matrix to asses the accuracy of randomForest model

![randomforest on tesSet](https://user-images.githubusercontent.com/46609482/59467393-6c448300-8de4-11e9-92ad-866e2759f25d.PNG)

68% accuracy compare to CART model that had 65% and baseline model that had 54%

# CART model with cross validation(based on same 6 predictors/regressors) trained on training set

*Notice in traditional CART model number of splits in tree depended on the value of parmeter called "minimum bucket size" and was decided by what seemed reasonable.*

*But to build this CART model, cross-validation is performed to slect the optimal value for parameter called "complexity parameter" instead of " minimum bucket size".*

*A smaller cp value leads to bigger tree(i.e. more splits) just like smaller minbucket size.*

*A larger cp value leads to smaller tree(i.e. less splits).*

                                            Tree plot with cross-validation method
![StevensTreeCV](https://user-images.githubusercontent.com/46609482/59469752-9305b800-8dea-11e9-8873-ab6b5c523c96.PNG)

This CART with cross-validation model has only one split. Which is if the lower court decision is liberal or not?

# Predicting on test set with cross-validation CART model

confusion matrix to asses the accuracy

![predictCV](https://user-images.githubusercontent.com/46609482/59470002-4ff81480-8deb-11e9-894e-27b2ef5167eb.PNG)

72% accuracy is a great improvement over randomForest model that had 68% accuracy and CART model(without cross-validation) that had 65% accuracy and baseline model that had 54% accuracy.

In conclusion, the model with best accuracy only had one split(i.e. lower court decision is liberal or no?) which reminds that sometimes simplest models are the best.



