#     Example of splitted subsets in which predictions decided by majority of whatever outcome(i.e. (.) or (*))
#               Notice number of splits depend on size of minbucket/subset       
# 
#   y     predict(.)        predict(*)
#   |                     |   *       *
# 30|             *   .   |*    * *
#   |        .    .    .  |________________ 
# 20|          .     .   .|pred(.)| pred(*) 
#   |       .   .   .     | ..    | * *
# 10|                 .   |. .   .|*    *
#   |______________________________________x
#     10  20  30  40  50  60  70  80  90  100 
#
#
#         Example of classification regression tree           Another example of multiple Ind. vars
#                     x < 60                                                          x_1 < 60
#                      / \                                                           /        \  
#                    yes  No                                                      yes          No
#                   /       \                                                     /              \
#                 (.)        y < 20                                       x_2 = 5,20            x_2 = 70,75
#                             / \                                             / \                   /    \    
#                           yes  No                                        yes   No               yes     No
#                          /       \                                       /       \             /          \
#                       x < 80      (*)                                   0    x_3 = a,c    x_4 = 1st,3rd    1
#                        / \                                                     / \              /   \
#                      yes  No                                                yes   No          yes     No
#                     /       \                                               /       \         /         \
#                   (.)        (*)                                           0         1   x_5 = c1,c21    1
#                                                                                              / \
#                                                                                           yes   No
#                                                                                           /       \
#                                                                                          0         1

install.packages("caTools")
install.packages("rpart")
install.packages("caret")
install.packages("e1071")
library(caTools)
library(rpart)
library(caret)
library(e1071)

# reading supereme court's Judge Stevens Data csv file
stevens = read.csv("stevens.csv")

# to view structure of the data
str(stevens)

# spliting the data randomly into test and train
split = sample.split(stevens$Reverse, SplitRatio = 0.7)
Train =  subset(stevens, split == TRUE)
Test =  subset(stevens, split == FALSE)

# creating a tree regression model based on 6 ind.variables
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class", minbucket=25)
# ^argument method="class" tells rpart() to build a classification tree instead of regression tree[you'll see how a regression tree can br created in recitation later]
# ^argument minbucket is how many minimum data points in each subset: if smaller minbucket limit then it means more subsets/buckets(too small limit can also overfit the predictions on test data)
#                                                                     if larger minbucket limit then it means fewer subsets/buckets(too large limit can have poor accuracy on test data)

# to view the tree plot
prp(StevensTree)

# predicting on test data using rpart() classification tree model we build
predictCART = predict(StevensTree, newdata=Test, type="class") # type="class" is basically saying we want the output of each leaf (i.e. predictions) in "0" or "1"; "TRUE" or "FALSE" based on majority/average of outcome of subset/bucket/leaf
#                                                                  In oher words, threshhold is set to 0.5 
#                                                                  Compare to type="response" where the output(i.e. predictions) in probability of "1"

# we can create a confusion matrix using table(), Remember threshhold is already set in the predict() above(i.e type="class" i.e. 0.5)
table(Test$Reverse, predictCART)

# accuracy of this CART model
(41+71)/(41+36+22+71)

# accuracy of baseline model where it always predict most frequent outcome(in this case value of "1" or "decision is reversed")
(22+71)/(41+36+22+71)




# Random Forest

# The method was designed to improve prediction accuracy of CART(classification And Regression Tree) model by building many CART trees though less interpretable.
# To make a prediction on a new observation, each tree votes on the outcome and we pick the outcome that receives the majority of votes
# How does random Forest method build many different trees and not the same trees?
#     - First, random Forest method only allows each tree to split on random subset of available ind. vars
#     - Second, Each tree is built from a "bagged"/"bootstrapped" sample of data(i.e. data used for each tree is random selected with replacement)
#                                                                               [For example, original data has 5 data points: 1,2,3,4,5]
#                                                                               [randomly selected data points for 1st tree: 2,4,5,2,1]
#                                                                               [randomly selected data points for 2nd tree: 3,5,1,5,2]

# Hence, each tree sees a different set of variables and a different set of data, we get what's called a forest of many different trees.

# Let's buid a randomForest for our training data
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, nodesize=25, ntree=200) # argument nodesize= is like a minbucket(i.e. size of subset or number of data-points in each subset) from CART model;
                                                                                                                                               # argument ntree= is number of trees we want to build                                                                             
# notice running the randomForest() will give a warning because just like in CART model(i.e. rpart()) where we used an argument method="class" to specify the classification tree instead of regression tree, we need to specify that we want to do classification problem.
# Since, randomForest() doesn't have a method argument, we want to make sure our dep.var(i.e. Reverse) outcome is a factor.
  
# convert dep.var(i.e. Reverse) of Train & Test data from an integer var. to factor var. by using as.factor()
Train$Reverse = as.factor(Train$Reverse)
Test$Reverse = as.factor(Test$Reverse)

# Build randomForest model after the dep.var has been converted to factor var. 
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, nodesize=25, ntree=200)

# predict on the test data using randomForest model
PredictForest = predict(StevensForest, newdata=Test)

# to view the confusion matrix to see the accuracy of randomForest model
table(Test$Reverse, PredictForest)
  
# accuracy of this model
(43+73)/(43+34+20+73)





#                                                        CART model with cross-validation to pick the optimal value for "Complexity Parameter"

# How to set/decide on the value of the parameter "minbucket=" in CART model?
# Cross-validation technique(k-folds)
#
# For example, split tthe training data into k folds and let's say k=5
#
#                           1st-fold     2nd-fold     3rd-fold    4th-fold    5th-fold
#
# Then we select k-1 folds(i.e.1st-4th folds) to estimate the data and compute predictions on the remaining one fold(i.e. 5th-fold aka validation set)
# Then we repeat the same process for each fold. For e.g. next we select 1st,2nd,3rd,5th folds to estimate data and compute predictions on 4th fold.

# We build models for each fold using all the possible parameter(for eg. minbucket size) values and compute the accuracy of the model 
#
#                                 1   |                _
#                                 0.9 |          __  /   \_
#                                 0.8 |       _/   /\       \                  1st-fold  
#                                 0.7 |     /    /    \       \_               2nd-fold
#                                 0.6 |   /    /        \        \_               .
#                       Accuracy  0.5 |~/ ___/            \__       \             .
#                                 0.4 |~/                     \_____  \        5th-fold
#                                 0.3 |                              \  \ 
#                                 0.2 |                                \  \__________
#                                 0.1 |                                  \____________\_
#                                   0 |_________________________________________________\__
#                                     0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
#                                           Possible Parameters(for eg. minbucket size)
#
# Finally, you take the average of accuracy of each fold and select the parameter for maximum average accuracy


# But in R when we build CART model we do the cross validation on cp(Complexity Parameter) instead of minbucket parameter
# cp Parameter is like Adjusted-R^2 of linear regression or AIC value for logistic regression model
# ==> A smaller cp value leads to bigger tree(i.e. more splits) just like smaller minbucket size
# ==> A larger cp value leads to smaller tree(i.e. less splits)

# Let's use cross-validation to select the value for our cp parameter in the CART model. To do that Install and load "caret" & "e1071" packages

# setting number of folds
numFolds = trainControl(method="cv",number=10)# how to decide on number = 10?  (1) low enough so your have enough data in each fold to be able to train your model and to test it. 
#                                                                                (2) high enough so you have enough iterations to get the desired averaging effect.

# setting possible values(grid) for cp
cpGrid = expand.grid(.cp=seq(0.01,0.5,0.01))

# Now we're readY to perform cross-validation using train()[which is just like any model function]
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)
# ^argument method="rpart" tells train() that we we want to do cross validate using CART model


# Accuracy was used to select the optimal model using the largest value.
# The final value used for the model was cp = 0.17.

# We use cp = 0.17 for our CART model
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class", cp=0.17)

# Now let's again predict on test data to see the accuracy with the cross-validation CART model
PredictCV = predict(StevensTreeCV, newdata = Test, type="class") # argument type="class" is basically a threshhold at 0.5 which spits output of leaf(i.e. TRUE or False; or value of "0" or "1") based on majority/average of outcome of subset/bucket/leaf

# to view the confusion matrix
table(Test$Reverse, PredictCV)


# accuracy of the CART model with cross-validation
(59+64)/(59+18+29+64)


# Lastly to view the plot of this cross-validation CART model tree
prp(StevensTreeCV)
# Turns out that the model with best accuracy only had one split(i.e. lower court decision is liberal or no?) which reminds us that somethimes simplest models are the best

#                                                           Lower court = liberal
#                                                                     / \
#                                                                  yes   No
#                                                                 /        \
#                                                                0          1

