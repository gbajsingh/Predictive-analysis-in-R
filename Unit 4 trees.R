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
# From lecture 1 Predicting Supereme Court decision
> stevens = read.csv("stevens.csv")
> str(stevens)
'data.frame':	566 obs. of  9 variables:
  $ Docket    : Factor w/ 566 levels "00-1011","00-1045",..: 63 69 70 145 97 181 242 289 334 436 ...
$ Term      : int  1994 1994 1994 1994 1995 1995 1996 1997 1997 1999 ...
$ Circuit   : Factor w/ 13 levels "10th","11th",..: 4 11 7 3 9 11 13 11 12 2 ...
$ Issue     : Factor w/ 11 levels "Attorneys","CivilRights",..: 5 5 5 5 9 5 5 5 5 3 ...
$ Petitioner: Factor w/ 12 levels "AMERICAN.INDIAN",..: 2 2 2 2 2 2 2 2 2 2 ...
$ Respondent: Factor w/ 12 levels "AMERICAN.INDIAN",..: 2 2 2 2 2 2 2 2 2 2 ...
$ LowerCourt: Factor w/ 2 levels "conser","liberal": 2 2 2 1 1 1 1 1 1 1 ...
$ Unconst   : int  0 0 0 0 0 1 0 1 0 0 ...
$ Reverse   : int  1 1 1 1 1 0 1 1 1 1 ...

# spliting the data randomly into test and train
> library(caTools) # remember to load "caTools" package
> set.seed(3000) # setting seed same as instructor to get same version of split data
> split = sample.split(stevens$Reverse, SplitRatio = 0.7)
> Train =  subset(stevens, split == TRUE)
> Test =  subset(stevens, split == FALSE)

# installing and loading package "rpart" for modeling tree regression model
> install.packages("rpart")
> library(rpart)
# creating a tree regression model based on 6 ind.variables
> StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class", minbucket=25)
# ^argument method="class" tells rpart() to build a classification tree instead of regression tree[you'll see how a regression tree can br created in recitation later]
# ^argument minbucket is how many minimum data points in each subset: if smaller minbucket limit then it means more subsets/buckets(too small limit can also overfit the predictions on test data)
#                                                                     if larger minbucket limit then it means fewer subsets/buckets(too large limit can have poor accuracy on test data)

# to view the tree plot it using prp()
> prp(StevensTree)

# predicting on test data using rpart() classification tree model we build
> predictCART = predict(StevensTree, newdata=Test, type="class") # type="class" is basically saying we want the output of each leaf (i.e. predictions) in "0" or "1"; "TRUE" or "FALSE" based on majority/average of outcome of subset/bucket/leaf
#                                                                  In oher words, threshhold is set to 0.5 
#                                                                  Compare to type="response" where the output(i.e. predictions) in probability of "1"

# we can create a confusion matrix using table(), Remeber threshhold is already set in the predict() above(i.e type="class" i.e. 0.5)
> table(Test$Reverse, predictCART)
predictCART
   0  1
0 41 36
1 22 71
# accuracy of this CART model
> (41+71)/(41+36+22+71)
[1] 0.6588235

# accuracy of baseline model where it always predict most frequent outcome(i.e. value of "1" is most frequent)
> (22+71)/(41+36+22+71)
[1] 0.5470588 # so accuracy of our CART(clasification and regression tree) model is better than this baseline model above

# let's evaluate our classification tree model further by generating ROC Curve
> library(ROCR) # Install and load "ROCR" package
# to create ROC curve we need to generate the probilities of predictions with predict() instead of generation class of prediction(i.e. value of "0" or "1")
> predictROC = predict(StevensTree, newdata=Test)
> predictROC
            0         1
1   0.3035714 0.6964286
3   0.3035714 0.6964286
4   0.4000000 0.6000000
6   0.4000000 0.6000000
8   0.4000000 0.6000000
21  0.3035714 0.6964286
32  0.5517241 0.4482759
36  0.5517241 0.4482759
40  0.3035714 0.6964286
42  0.5517241 0.4482759
46  0.5517241 0.4482759
47  0.4000000 0.6000000
53  0.5517241 0.4482759
#     .         .
#     .         .
#     .         .
# Total 170 observations from Test data. Also notice, each observation is clasified into 8 different subset/probilites/bucket

# Now we'll use second column(i.e. value of "1") of predict() output[since we need only probilities of value "1"] to use in prediction() to create ROC curve
> pred = prediction(predictROC[,2], Test$Reverse)



#     **********************************************************************************************************************************************
# prediction() basically compares the predictions made by predict() with actual outcome of ind.var we're trying to predict.
# Have a look at the output of prediction() to better understand what's goin on under this function
> prediction(predictROC[,2], Test$Reverse)
An object of class "prediction"
Slot "predictions":
  [[1]]
1         3         4         6         8        21        32        36        40        42 
0.6964286 0.6964286 0.6000000 0.6000000 0.6000000 0.6964286 0.4482759 0.4482759 0.6964286 0.4482759 
46        47        53        55        59        60        66        67        68        72 
0.4482759 0.6000000 0.4482759 0.6964286 0.8157895 0.6000000 0.6000000 0.6000000 0.8157895 0.6964286 
79        80        87        88        92        95       102       106       110       112 
0.6964286 0.4482759 0.2400000 0.8157895 0.2089552 0.2089552 0.2089552 0.2089552 0.2089552 0.2089552 
114       125       130       134       138       145       146       148       149       152 
0.2089552 0.2089552 0.2089552 0.2089552 0.2089552 0.2089552 0.2089552 0.6964286 0.6964286 0.6964286 
154       161       164       167       169       171       175       176       177       178 
0.4482759 0.2121212 0.6000000 0.2121212 0.6964286 0.2400000 0.4482759 0.9245283 0.9245283 0.9245283 
180       187       188       190       192       196       197       208       210       216 
0.9245283 0.9245283 0.2121212 0.9245283 0.9245283 0.9245283 0.6964286 0.6964286 0.9245283 0.2089552 
218       220       224       226       227       228       235       239       242       244 
0.2089552 0.9245283 0.6000000 0.2400000 0.6000000 0.2121212 0.6964286 0.2121212 0.2400000 0.2400000 
247       255       260       261       264       265       268       272       273       274 
0.6000000 0.6964286 0.4482759 0.2400000 0.6964286 0.6964286 0.6964286 0.4482759 0.6964286 0.4482759 
275       282       286       291       294       305       306       308       311       313 
0.6964286 0.6000000 0.2121212 0.6000000 0.8157895 0.6000000 0.6964286 0.2121212 0.2121212 0.2121212 
314       315       317       320       321       323       331       335       338       341 
0.2121212 0.2121212 0.2121212 0.2121212 0.2121212 0.6000000 0.6964286 0.6964286 0.2400000 0.4482759 
345       346       350       352       353       355       356       358       359       360 
0.4482759 0.6964286 0.6964286 0.6964286 0.8157895 0.6964286 0.8157895 0.6964286 0.6964286 0.6000000 
361       362       364       368       381       382       384       387       389       390 
0.6000000 0.4482759 0.6964286 0.6964286 0.6000000 0.8157895 0.6964286 0.8157895 0.6964286 0.6000000 
394       400       402       405       408       410       416       422       432       434 
0.6964286 0.2121212 0.6000000 0.2121212 0.6964286 0.6964286 0.6000000 0.2400000 0.9245283 0.2089552 
436       441       444       448       450       451       452       454       456       459 
0.9245283 0.2089552 0.9245283 0.9245283 0.9245283 0.9245283 0.2089552 0.9245283 0.9245283 0.9245283 
462       464       467       468       470       473       476       478       480       482 
0.9245283 0.9245283 0.9245283 0.9245283 0.9245283 0.9245283 0.9245283 0.9245283 0.9245283 0.9245283 
483       484       494       498       504       509       521       527       531       535 
0.9245283 0.9245283 0.2089552 0.8157895 0.6000000 0.6000000 0.2400000 0.6000000 0.6000000 0.6000000 
538       539       540       543       545       546       551       552       556       558 
0.2400000 0.8157895 0.6000000 0.2400000 0.6000000 0.2089552 0.2089552 0.2089552 0.6000000 0.8157895 # all the probilities of value "1" of 170 observations of test data

Slot "labels":
  [[1]]
[1] 1 1 1 0 1 0 0 0 0 1 0 1 0 1 1 1 0 1 1 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 1 1 1
[49] 1 1 1 1 0 0 1 1 1 0 0 0 0 1 1 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 1 0 0 1 0 0 1 1 0 1 1 1 0 1 1
[97] 0 0 1 1 0 1 1 0 1 0 0 1 1 1 1 0 0 0 1 0 1 1 0 0 0 0 1 1 1 0 1 1 1 0 1 1 1 1 1 1 0 1 0 1 1 1 1 0
[145] 1 1 1 1 1 0 1 1 0 1 0 1 1 0 1 1 1 1 1 1 0 0 0 0 1 1 # # actual outcomes of ind.var. of test data
Levels: 0 < 1

Slot "cutoffs":
  [[1]]
          484       558       410       556       362       543       405       552 
Inf 0.9245283 0.8157895 0.6964286 0.6000000 0.4482759 0.2400000 0.2121212 0.2089552 # all 8 the different cutOffs/ prob. of value"1" of 8 subsets

Slot "fp":
  [[1]]
[1]  0  5  7 28 36 47 50 58 77 # number of False positive values(i.e. value of "1") predicted at all the 8 different cutOffs and plus 1 cutOff at 0(i.e. the very first value)

Slot "tp":
  [[1]]
[1]  0 26 35 50 71 74 82 90 93 # number of True positive values(i.e. value of "1") predicted at all the 8 different cutOffs and 1 cutOff at 0(i.e. the very first value)

Slot "tn":
  [[1]]
[1] 77 72 70 49 41 30 27 19  0 # number of True negative values(i.e. value of "0") predicted at all the 8 different cutOffs and 1 cutOff at 0(i.e.the very last value)

Slot "fn":
  [[1]]
[1] 93 67 58 43 22 19 11  3  0 # number of False negative values(i.e. value of "0") predicted at all the 8 different cutOffs and 1 cutOff at 0 (i.e. the very last value)

Slot "n.pos":
  [[1]]
[1] 93 # number of True Posituve values or actual positive values(i.e. value of "1")

Slot "n.neg":
  [[1]]
[1] 77 # number of True negative values or actual negative values(i.e. value of "0")

Slot "n.pos.pred":
  [[1]]
[1]   0  31  42  78 107 121 132 148 170 # number of Total positive values(i.e value of "1") predicted at 8 different cutOffs and 1 cutOff at 0(i.e. the very first value)

Slot "n.neg.pred":
  [[1]]
[1] 170 139 128  92  63  49  38  22   0 # number of Total negative values(i.e value of "0") predicted at 8 different cutOffs and 1 cutOff at 0(i.e. the very last value)
#   **************************************************************************************************************************************************************************

# to plot ROC curve use plot() on performance()
>  plot(performance(pred, "tpr", "fpr"))

# to calculate AUC which is how significant accuracy of the model is compare to purely guessing which would've probability of 50%
> as.numeric(performance(pred, "auc")@y.values)
[1] 0.6927105


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
> StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, nodesize=25, ntree=200) # argument nodesize= is like a minbucket(i.e. size of subset or number of data-points in each subset) from CART model;
                                                                                                                                               # argument ntree= is number of trees we want to build                                                                             
Warning message:
  In randomForest.default(m, y, ...) :
  The response has five or fewer unique values.  Are you sure you want to do regression? # notice this warning appears because just like in CART model(i.e. rpart()) where we used an argument method="class" to specify the classification tree instead of regression tree,
                                                                                         # we need to specify that we want to do classification problem.
                                                                                         # Since, randomForest() doesn't have a method argument, we want to make sure our dep.var(i.e. Reverse) outcome is a factor.
  
# convert dep.var(i.e. Reverse) of Train & Test data from an integer var. to factor var. by using as.factor()
> Train$Reverse = as.factor(Train$Reverse)
> Test$Reverse = as.factor(Test$Reverse)

# now our dep.var has been converted to factor var. let's do compute the randomForest again 
> StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, nodesize=25, ntree=200)

# predict on the test data using randomForest model
> PredictForest = predict(StevensForest, newdata=Test)

# create confusion matrix to see the accuracy of randomForest model
> table(Test$Reverse, PredictForest)
PredictForest
0  1
0 43 34
1 20 73
# accuracy of this model
> (43+73)/(43+34+20+73)
[1] 0.6823529 # so 68% accurate compare to CART model that had 65% and Logistic regression model that had 66% and baseline model that had 54%

#************************************************************************************************************************************************************************************************************************
# Optimal Classification trees
#
#       **randomForest model**                                                                        **CART model**
#
#   -more accuracy over CART model                                                                  -less accuracy
#   -less interpetable                                                                              -more interpetable(i.e. shows variable by variable why the prediction was made)
#   -belongs to class of black models[the inner workings of how input translates to                 -belongs to class of white models[since, it provides insight in understanding the logic of decision making]
#                                     of how input translates to predictions is overly
#                                     is overly complex or unclear]                                                               
#
#                         SO IS THERE A METHOD THAT ACHEIVES BOTH QUALITIES OF MODEL LIKE INTERPETABILITY ANF HIGH ACCURACY?
#                                                       YES, IT'S CALLED OPTIMAL CLASSIFICATION TREES
#                         - CART only learns the splits one step at a time in a greedy fashion, often resulting trees far from optimal.
#                         - Instead the optimal technique train the entire tree in one step
#                         - Because of flexibility, optimization framework provides multiple flavors
#                           ==> OCT: just like CART tree these are trees with parallel split(splits one variable at time)
#                           ==> OCT-H: can train a tree with hyperplane splits(use mutiple variables per split)
#*************************************************************************************************************************************************************************************************************************

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
# ==> A smaller cp value leads to bigger tree(i.e. more splits) just like smaaler minbucket size
# ==> A larger cp value leads to smaller tree(i.e. less splits)

# Let's use cross-validation to select the value for our cp parameter in the CART model. To do that Install and load "caret" & "e1071" packages
> install.packages("caret")
> install.packages("e1071")
> library(caret)
> library(e1071)

# setting number of folds
> numFolds = trainControl(method="cv",number=10)# how to decide on number = 10?  (1) low enough so your have enough data in each fold to be able to train your model and to test it. 
#                                                                                (2) high enough so you have enough iterations to get the desired averaging effect.

# setting possible values(grid) for cp
> cpGrid = expand.grid(.cp=seq(0.01,0.5,0.01))

# Now we're readY to perform cross-validation using train()[which is just like any model function]
> train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)
# ^argument method="rpart" tells train() that we we want to do cross validate using CART model
CART 

396 samples
6 predictor
2 classes: '0', '1' 

No pre-processing
Resampling: Cross-Validated (10 fold) 
Summary of sample sizes: 356, 356, 357, 356, 357, 357, ... 
Resampling results across tuning parameters:
 # Notice the accuracy increases then decreases 
  cp    Accuracy   Kappa      
0.01  0.6161538  0.211104409
0.02  0.6211538  0.225904881
0.03  0.6211538  0.228455455
0.04  0.6388462  0.272088981
0.05  0.6439744  0.284350141
0.06  0.6439744  0.284350141
0.07  0.6439744  0.284350141
0.08  0.6439744  0.284350141
0.09  0.6439744  0.284350141
0.10  0.6439744  0.284350141
0.11  0.6439744  0.284350141
0.12  0.6439744  0.284350141
0.13  0.6439744  0.284350141
0.14  0.6439744  0.284350141
0.15  0.6439744  0.284350141
0.16  0.6439744  0.284350141
0.17  0.6439744  0.284350141
0.18  0.6164744  0.219526020
0.19  0.6164744  0.219526020
0.20  0.5989744  0.174802402
0.21  0.5733333  0.110004565
0.22  0.5630769  0.081658109
0.23  0.5478846  0.035232343
0.24  0.5428846  0.003553299
0.25  0.5453846  0.000000000
0.26  0.5453846  0.000000000
0.27  0.5453846  0.000000000
0.28  0.5453846  0.000000000
0.29  0.5453846  0.000000000
0.30  0.5453846  0.000000000
0.31  0.5453846  0.000000000
0.32  0.5453846  0.000000000
0.33  0.5453846  0.000000000
0.34  0.5453846  0.000000000
0.35  0.5453846  0.000000000
0.36  0.5453846  0.000000000
0.37  0.5453846  0.000000000
0.38  0.5453846  0.000000000
0.39  0.5453846  0.000000000
0.40  0.5453846  0.000000000
0.41  0.5453846  0.000000000
0.42  0.5453846  0.000000000
0.43  0.5453846  0.000000000
0.44  0.5453846  0.000000000
0.45  0.5453846  0.000000000
0.46  0.5453846  0.000000000
0.47  0.5453846  0.000000000
0.48  0.5453846  0.000000000
0.49  0.5453846  0.000000000
0.50  0.5453846  0.000000000

Accuracy was used to select the optimal model using the largest value.
The final value used for the model was cp = 0.17.

# So we use cp = 0.17 for our CART model
> StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class", cp=0.17)

# Now let's again predict on Test data to see the accuracy with the cross-validation CART model
> PredictCV = predict(StevensTreeCV, newdata = Test, type="class") # argument type="class" is basically a threshhold at 0.5 which spits output of leaf(i.e. TRUE or False; or value of "0" or "1") based on majority/average of outcome of subset/bucket/leaf
> table(Test$Reverse, PredictCV)
PredictCV
   0  1
0 59 18
1 29 64
> (59+64)/(59+18+29+64)
[1] 0.7235294 # 72% accuracy is a great improvement over randomForest model that had 68% accuracy and
#                                                        CART model(without cross-validation) that had 65% accuracy and 
#                                                        Logistic regression model that had 66% accuracy and 
#                                                        baseline model that had 54% accuracy

# Lastly if you view the plot of this cross-validation CART model tree,
> prp(StevensTreeCV)
# you'll find out that the model with best accuracy only had one split(i.e. lower court decision is liberal or no?) wich reminds us that somethimes simplest models are the best

#                                                           Lower court = liberal
#                                                                     / \
#                                                                  yes   No
#                                                                 /        \
#                                                                0          1








# From lecture 2 D2-hawkeye predicting health cost via medical claims

> Claims = read.csv("ClaimsData.csv")
> str(Claims)
'data.frame':	458005 obs. of  16 variables:
$ age              : int  85 59 67 52 67 68 75 70 67 67 ...
$ alzheimers       : int  0 0 0 0 0 0 0 0 0 0 ...
$ arthritis        : int  0 0 0 0 0 0 0 0 0 0 ...
$ cancer           : int  0 0 0 0 0 0 0 0 0 0 ...
$ copd             : int  0 0 0 0 0 0 0 0 0 0 ...
$ depression       : int  0 0 0 0 0 0 0 0 0 0 ...
$ diabetes         : int  0 0 0 0 0 0 0 0 0 0 ...
$ heart.failure    : int  0 0 0 0 0 0 0 0 0 0 ...
$ ihd              : int  0 0 0 0 0 0 0 0 0 0 ...
$ kidney           : int  0 0 0 0 0 0 0 0 0 0 ...
$ osteoporosis     : int  0 0 0 0 0 0 0 0 0 0 ...
$ stroke           : int  0 0 0 0 0 0 0 0 0 0 ...
$ reimbursement2008: int  0 0 0 0 0 0 0 0 0 0 ...
$ bucket2008       : int  1 1 1 1 1 1 1 1 1 1 ...
$ reimbursement2009: int  0 0 0 0 0 0 0 0 0 0 ...
$ bucket2009       : int  1 1 1 1 1 1 1 1 1 1 ...

> summary(Claims)
age           alzheimers       arthritis          cancer             copd          depression        diabetes      heart.failure   
Min.   : 26.00   Min.   :0.0000   Min.   :0.0000   Min.   :0.00000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000  
1st Qu.: 67.00   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000  
Median : 73.00   Median :0.0000   Median :0.0000   Median :0.00000   Median :0.0000   Median :0.0000   Median :0.0000   Median :0.0000  
Mean   : 72.63   Mean   :0.1922   Mean   :0.1543   Mean   :0.06411   Mean   :0.1361   Mean   :0.2131   Mean   :0.3805   Mean   :0.2847  
3rd Qu.: 81.00   3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.:0.00000   3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.:1.0000   3rd Qu.:1.0000  
Max.   :100.00   Max.   :1.0000   Max.   :1.0000   Max.   :1.00000   Max.   :1.0000   Max.   :1.0000   Max.   :1.0000   Max.   :1.0000  
ihd             kidney        osteoporosis       stroke        reimbursement2008   bucket2008    reimbursement2009   bucket2009   
Min.   :0.0000   Min.   :0.0000   Min.   :0.000   Min.   :0.00000   Min.   :     0    Min.   :1.000   Min.   :     0    Min.   :1.000  
1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.000   1st Qu.:0.00000   1st Qu.:     0    1st Qu.:1.000   1st Qu.:   130    1st Qu.:1.000  
Median :0.0000   Median :0.0000   Median :0.000   Median :0.00000   Median :   950    Median :1.000   Median :  1540    Median :1.000  
Mean   :0.4201   Mean   :0.1612   Mean   :0.174   Mean   :0.04479   Mean   :  4005    Mean   :1.437   Mean   :  4277    Mean   :1.522  
3rd Qu.:1.0000   3rd Qu.:0.0000   3rd Qu.:0.000   3rd Qu.:0.00000   3rd Qu.:  3110    3rd Qu.:2.000   3rd Qu.:  4220    3rd Qu.:2.000  
Max.   :1.0000   Max.   :1.0000   Max.   :1.000   Max.   :1.00000   Max.   :221640    Max.   :5.000   Max.   :189930    Max.   :5.000  

# spliting the data randomly into train and test
> library(caTools)
> set.seed(88) # setiing the seed to get same data observartions as instructor in the video
> split = sample.split(Claims$bucket2009, SplitRatio = 0.6)# Rember to load "caTools" package
> ClaimsTrain = subset(Claims, split==TRUE)
> ClaimsTest = subset(Claims, split==FALSE)

# using a smarter baseline model that predicts the ind.var.(i.e. cost in 2009/bucket2009) as same as the cost/bucket from last year(i.e. bucket2008),
# let's check the accuracy of it by predicting on test data using confusion matrix
> table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)

       1      2      3      4      5
1 110138   7787   3427   1452    174
2  16000  10721   4629   2931    559
3   7006   4629   2774   1621    360
4   2688   1943   1415   1539    352
5    293    191    160    309    104
> (110138+10721+2774+1539+104)/(nrow(ClaimsTest))
[1] 0.6838135 # so 68% the accuracy of this smarter baseline model 

# Now let's compute penalty error by first creating a penalty matrix
> PenaltyMatrix = matrix(c(0,1,2,3,4,2,0,1,2,3,4,2,0,1,2,6,4,2,0,1,8,6,4,2,0), byrow=TRUE, nrow=5) 
# numbers in vector c() comes from either (actual-predicted higher)*1 or (actual-predicted lower)*2. Look into lecture "Penalty Error" for more info on Penalty Matrix

> PenaltyMatrix
      [,1] [,2] [,3] [,4] [,5]
[1,]    0    1    2    3    4
[2,]    2    0    1    2    3
[3,]    4    2    0    1    2
[4,]    6    4    2    0    1
[5,]    8    6    4    2    0

# to compute the penalty error, first, we need to multiplying the penalty matrix by baseline confusion matrix table
# also you need to convert the baseline model's confusion table into matrix using as.matrix()
> as.marix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008))*PenaltyMatrix
      1     2     3     4     5
1     0  7787  6854  4356   696
2 32000     0  4629  5862  1677
3 28024  9258     0  1621   720
4 16128  7772  2830     0   352
5  2344  1146   640   618     0

# second we need to take the sum of this newly created table/matrix and divide/normalized by number of total observations in the dataset
> sum(as.matrix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008))*PenaltyMatrix)/nrow(ClaimsTest) 
[1] 0.7386055 # so the penalty error for our smarter baseline model is 0.73

# load packages "rpart" and "rpart.plot" to create our CART Model using all the ind.vars except "reimbursement2009"
> library(rpart)
> library(rpart.plot)
> ClaimsTree = rpart(bucket2009 ~ . -reimbursement2009, data=ClaimsTrain, method="class", cp=0.00005) # the cp=0.00005 was decide by the instructor by doing cross-validation seperately because it would take long time as the observations in data are huge
# ^Also notice, we build our tree in same way as binary-classification even though this is multi-classification problem[since outcomes are "1","2","3","4" and "5"]

# Now let's predict on test data
> PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type="class")# argument type="class" is basically spits output of leaf(i.e. in this Claims example, value of "1","2","3","4" or"5") based on majority/average of outcome of the subset/bucket/leaf
# creating result/confusion matrix
> table(ClaimsTest$bucket2009, PredictTest)
PredictTest
       1      2      3      4      5
1 114141   8610    124    103      0
2  18409  16102    187    142      0
3   8027   8146    118     99      0
4   3099   4584     53    201      0
5    351    657      4     45      0

# determine accuracy of our CART model
> (114141+16102+118+201+0)/nrow(ClaimsTest)
[1] 0.7126669 # 71% accuracy of this CART model compare to 68% accuacy of our smarter baseline model above

# determining Penalty error
> as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix
PredictTest
      1     2     3     4     5
1     0  8610   248   309     0
2 36818     0   187   284     0
3 32108 16292     0    99     0
4 18594 18336   106     0     0
5  2808  3942    16    90     0
> sum(as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix)/nrow(ClaimsTest)
[1] 0.7578902 # 0.75 penatly error is higher than our smarter baseline model penalty error of 0.73

# while our accuracy of CART model has increased, the penalyt error also went up. 
# This is because by default rpart() will try to maximize the overall accuracy and every type of error is seen as having a penalty of one

# so to bring down the penalty error rpart() allows us to specify parameter called loss. Basically allows us to put our own loss matrix i.e. our own created "PenaltyMatrix"
> ClaimsTreeLostMatrix = rpart(bucket2009 ~ . -reimbursement2009, data=ClaimsTrain, method="class", cp=0.00005, parms = list(loss=PenaltyMatrix))

# Finally, let's predict on our test data with the CART model with loss matrix i.e. "PenaltyMatrix"
> PredictTest = predict(ClaimsTreeLostMatrix, newdata = ClaimsTest, type="class") # agian argument type="class" is basically spits output of leaf(i.e. in this Claims example, value of "1","2","3","4" or"5") based on majority/average of outcome of the subset/bucket/leaf
> table(ClaimsTest$bucket2009, PredictTest)
PredictTest
      1     2     3     4     5
1 94310 25295  3087   286     0
2  7176 18942  8079   643     0
3  3590  7706  4692   401     1
4  1304  3193  2803   636     1
5   135   356   408   156     2
# accuracy of this new CART model is
> (94310+18942+4692+636+2)/nrow(ClaimsTest)
[1] 0.6472746 # 64% accuracy which has decreased compare to our CART model without lost matrix(71% accuracy) and smarter baseline model(68% accuracy)

# determining the penalty error of this new CART model with loss matrix(i.e. "PenaltyMatrix")
> as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix
PredictTest
      1     2     3     4     5
1     0 25295  6174   858     0
2 14352     0  8079  1286     0
3 14360 15412     0   401     2
4  7824 12772  5606     0     1
5  1080  2136  1632   312     0
> sum(as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix)/nrow(ClaimsTest)
[1] 0.6418161 # 0.641 penalty error has gone lower from a higher penalty error of previous CART model where we didn't specify loss matrix i.e."PenaltyMatrix"


# Result of each model's accuracy by each bucket and penalty error

#                     Accuracy                                            Penalty Error
# Bucket    CART    CART(lostMatrix)   Baseline       |         CART   CART(lostMatrix)    Baseline
# All        71%        64%             68%           |         0.75       0.64              0.73
#   1        93%        77%             89%           |         
#   2        46%        54%             31%           |         
#   3       .07%        29%             17%           |         
#   4       .03%        08%             19%           |         
#   5         0%       .02%             10%           |         

# calculations for CART model's accuracy by each bucket
> 114141/nrow(subset(ClaimsTest, bucket2009==1))
[1] 0.9281416
> 16102/nrow(subset(ClaimsTest, bucket2009==2))
[1] 0.4621699
> 118/nrow(subset(ClaimsTest, bucket2009==3))
[1] 0.007199512
> 201/nrow(subset(ClaimsTest, bucket2009==4))
[1] 0.02532443
> 0/nrow(subset(ClaimsTest, bucket2009==5))
[1] 0

# calculations for CART(lostMatrix) model's accuracy by each model
> 94310/nrow(subset(ClaimsTest, bucket2009==1))
[1] 0.7668851
> 18942/nrow(subset(ClaimsTest, bucket2009==2))
[1] 0.5436854
> 4692/nrow(subset(ClaimsTest, bucket2009==3))
[1] 0.2862721
> 636/nrow(subset(ClaimsTest, bucket2009==4))
[1] 0.08013103
> 2/nrow(subset(ClaimsTest, bucket2009==5))
[1] 0.001892148

# calculations for baseline model's accuracy by each bucket
> 110138/nrow(subset(ClaimsTest, bucket2009==1))
[1] 0.8955911
> 10721/nrow(subset(ClaimsTest, bucket2009==2))
[1] 0.307721
> 2774/nrow(subset(ClaimsTest, bucket2009==3))
[1] 0.1692495
> 1539/nrow(subset(ClaimsTest, bucket2009==4))
[1] 0.193902
> 104/nrow(subset(ClaimsTest, bucket2009==5))
[1] 0.09839167









# From recitaion Boston House Pricing predicting through Linear Reg. vs Regression Tree
> boston = read.csv("boston.csv")
> str(boston)
'data.frame':	506 obs. of  16 variables:
$ TOWN   : Factor w/ 92 levels "Arlington","Ashland",..: 54 77 77 46 46 46 69 69 69 69 ...
$ TRACT  : int  2011 2021 2022 2031 2032 2033 2041 2042 2043 2044 ... # statistical division of the area that is used by researchers to break down towns and cities
$ LON    : num  -71 -71 -70.9 -70.9 -70.9 ... # Longitude of the center of census tract
$ LAT    : num  42.3 42.3 42.3 42.3 42.3 ... # Latitude of the center of census tract
$ MEDV   : num  24 21.6 34.7 33.4 36.2 28.7 22.9 22.1 16.5 18.9 ... # Median-value of owner occupied homes in that tract/area, in thousand of dollars
$ CRIM   : num  0.00632 0.02731 0.02729 0.03237 0.06905 ...# crime rate
$ ZN     : num  18 0 0 0 0 0 12.5 12.5 12.5 12.5 ... # how much of land is zoned for large residential properties
$ INDUS  : num  2.31 7.07 7.07 2.18 2.18 2.18 7.87 7.87 7.87 7.87 ...# proportion of area used for industry
$ CHAS   : int  0 0 0 0 0 0 0 0 0 0 ...# 1 if census tract is next to "Charles river"
$ NOX    : num  0.538 0.469 0.469 0.458 0.458 0.458 0.524 0.524 0.524 0.524 ...# (air pollution)concentration of Nitrous oxides in air
$ RM     : num  6.58 6.42 7.18 7 7.15 ...# average number of rooms per dwelling
$ AGE    : num  65.2 78.9 61.1 45.8 54.2 58.7 66.6 96.1 100 85.9 ...# proportion of owner occupied units built before 1940
$ DIS    : num  4.09 4.97 4.97 6.06 6.06 ...# measure of how far the tract is from the center of employment
$ RAD    : int  1 2 2 3 3 3 5 5 5 5 ...# measure of clossenes to highways
$ TAX    : int  296 242 242 222 222 222 311 311 311 311 ...# property tax rate per 10,000 of value
$ PTRATIO: num  15.3 17.8 17.8 18.7 18.7 18.7 15.2 15.2 15.2 15.2 ...# pupil-teacher ratio by town

# to plot the longitude and latitude cordinates of the center of tract
> plot(boston$LON, boston$LAT)
# to highlight the points that are next to "charles river" or where Variable CHAS is "1"
> points(boston$LON[boston$CHAS==1],boston$LAT[boston$CHAS==1])
# to higlight these above points in specfic color add an argument col="name of the color"
> points(boston$LON[boston$CHAS==1],boston$LAT[boston$CHAS==1], col="blue")
# to higlight these above points in solid dots add argument pch=density
> points(boston$LON[boston$CHAS==1],boston$LAT[boston$CHAS==1], col="blue", pch=19)

# let's check what's the mean of NOX in boston to higlight the points that are above average NOX
> summary(boston$NOX)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.3850  0.4490  0.5380  0.5547  0.6240  0.8710 
# to higlight the points that are above average NOX
> points(boston$LON[boston$NOX>=mean(boston$NOX)], boston$LAT[boston$NOX>=mean(boston$NOX)], col="green", pch=19)

# let's check what's the median of MEDV in boston to higlight the points that are above Median of MEDV
> points(boston$LON[boston$MEDV>=median(boston$MEDV)],boston$LAT[boston$MEDV>=median(boston$MEDV)], col="red", pch=19)

# Now let's see how well a linear regression model based on Longitude and Latitude will predict MEDV by creating a linear model
> lat_lon_lm = lm(MEDV ~ LAT + LON, data = boston)
> summary(lat_lon_lm)

Call:
  lm(formula = MEDV ~ LAT + LON, data = boston)

Residuals:
  Min      1Q  Median      3Q     Max 
-16.460  -5.590  -1.299   3.695  28.129 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) -3178.472    484.937  -6.554 1.39e-10 ***
LAT             8.046      6.327   1.272    0.204    
LON           -40.268      5.184  -7.768 4.50e-14 *** # -40.268 coef means as Longitude increases(i.e. as you go further east near the ocean) MEDV decreases by a factor of -40.268
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 8.693 on 503 degrees of freedom
Multiple R-squared:  0.1072,	Adjusted R-squared:  0.1036 
F-statistic: 30.19 on 2 and 503 DF,  p-value: 4.159e-13

# so what does this linear regression model think/predicts where are the above median MEDV points on LON vs LAT plot?
# first, ploting the LON vs LAT
> plot(boston$LON, boston$LAT)
# second, higlight the actual above median MEDV points
> points(boston$LON[boston$MEDV>=median(boston$MEDV)],boston$LAT[boston$MEDV>=median(boston$MEDV)], col="red", pch=19)
# to see values fitted/predicted by linear reg. model type linearModel$fitted.values
# lastly, higlight the predicted linear regression model's above median points
> points(boston$LON[lat_lon_lm$fitted.values>=median(boston$MEDV)],boston$LAT[lat_lon_lm$fitted.values>=median(boston$MEDV)], col="blue", pch="$")
# ^if you can visualise the plot you'll notice linear regression model didnt do a good job in predicting above meadian MEDV points


# Now let's see how well a regression tree model based on LAT & LON will do in predicting above median MEDV points on a plot

# creating a regression tree model based on LAT & LON variable
> library(rpart) # remember to load "rpart" package to use regression tree model
> library(rpart.plot) # remember to load "rpart.plot" package to plot the regression trees
> lat_lon_tree = rpart(MEDV ~ LAT + LON, data=boston) # Notice, no need to specify the argument method="class" since we're buiding a regression tree model instead of classification tree model

# if you plot the regression tree model using prp() you'll notice all the leave output's are number instead of class/category such as "0" or "1"
> prp(lat_lon_tree) # also you'll notice trees have many splits hence complicated and difficult ot interpret


# Finally let's see how does it do on a LON vs LAT plot
# first plot the LON vs LAT 
> plot(boston$LON, boston$LAT)
# second, higlight the actual above median MEDV points
> points(boston$LON[boston$MEDV>=median(boston$MEDV)],boston$LAT[boston$MEDV>=median(boston$MEDV)], col="red", pch=19)
# store the predicted values by regression tree model under "fittedValues"
> fittedValues = predict(lat_lon_tree)
# lastly, higlight the predicted regression tree model's above median points
> points(boston$LON[fittedValues>=median(boston$MEDV)],boston$LAT[fittedValues>=median(boston$MEDV)], col="red", pch=19)
# ^if you visualize the plot you'll notice that tree regression model did very good job in predicting above median MEDV points as compare to linear regression model

# the regression tree model we just created might be overfitting so maybe we can get the most of this effect by modeling a simpler tree by adding the minbucket size(i.e. minimum amiunt of data points in each subset)
> lat_lon_tree = rpart(MEDV ~ LAT + LON, data=boston, minbucket=50)
> prp(lat_lon_tree) # now if you view the tree plot it has fewer splits and more interptable
> plot(lat_lon_tree) # alternative way to plot the tree
> text(lat_lon_tree) # to add the labels to regression tree

# on the plot LON vs LAT one can plot the lines based on splits in the regression tree model to visualise each subset
# first plot the LON vs LAT
> plot(boston$LON, boston$LAT)

# second add a verticle line based on first split(LON >= -71.07) using abline(v=)
> abline(v=-71.07)
# add a horizontal line  based on split(LAT >= 42.17) using abline(h=)
> abline(h=42.17)
# add another horizontal line  based on split(LAT < 42.21) using abline(h=)
> abline(h=42.21)

# Now if you higlight the points, above median MEDV, on the plot you'll notice subset(where LON >= -71.07, LAT >= 42.17 & LAT < 42.21) corresponds to the area with lowest amount of highlighted above median MEDV points(i.e. points below median price)
> points(boston$LON[boston$MEDV>=median(boston$MEDV)],boston$LAT[boston$MEDV>=median(boston$MEDV)], col="red", pch=19)

# Now we see if regression tree model can predict MEDV price(i.e. Median price of tract/area) better than linear model
# spliting the data into train and test
> library(caTools)
> split = sample.split(boston$MEDV, SplitRatio = 0.7) # rember to load "caTools" package
> Train = subset(boston, split==TRUE)
> Test = subset(boston, split==FALSE)

# let's create a linear model with all the ind.variables except "Town" and "Tract" since those don't make sense to include
#*********************************************************************************************************************************************************
> linreg = lm(MEDV ~.-TOWN -TRACT, data=Train) # Notice doing this way will give you error when using predict() later
> predTest = predict(linreg, newdata = Test)
Error in model.frame.default(Terms, newdata, na.action = na.action, xlev = object$xlevels) : 
  factor TOWN has new levels Hanover, Hull, Lincoln, Middleton, Millis
#***********************************************************************************************************************************************************
> linreg = lm(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data=Train)
> summary(linreg)

Call:
  lm(formula = MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + 
       RM + AGE + DIS + RAD + TAX + PTRATIO, data = Train)

Residuals:
  Min      1Q  Median      3Q     Max 
-14.511  -2.712  -0.676   1.793  36.883 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -2.523e+02  4.367e+02  -0.578   0.5638    
LON         -2.987e+00  4.786e+00  -0.624   0.5329  # LON is not significant  
LAT          1.544e+00  5.192e+00   0.297   0.7664   # LAT is not significant 
CRIM        -1.808e-01  4.390e-02  -4.118 4.77e-05 ***
ZN           3.250e-02  1.877e-02   1.731   0.0843 .  
INDUS       -4.297e-02  8.473e-02  -0.507   0.6124    
CHAS         2.904e+00  1.220e+00   2.380   0.0178 *  
NOX         -2.161e+01  5.414e+00  -3.992 7.98e-05 *** # air pollution) concenteration of NOX is very significant. Negative coef tells us higher the NOX is lower the median price
RM           6.284e+00  4.827e-01  13.019  < 2e-16 *** # avg. number of rooms per dwelling is very significant
AGE         -4.430e-02  1.785e-02  -2.482   0.0135 *  
DIS         -1.577e+00  2.842e-01  -5.551 5.63e-08 ***
RAD          2.451e-01  9.728e-02   2.519   0.0122 *  
TAX         -1.112e-02  5.452e-03  -2.040   0.0421 *  
PTRATIO     -9.835e-01  1.939e-01  -5.072 6.38e-07 ***
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.595 on 350 degrees of freedom
Multiple R-squared:  0.665,	Adjusted R-squared:  0.6525 
F-statistic: 53.43 on 13 and 350 DF,  p-value: < 2.2e-16

# predicting on test data
> predict.linreg = predict(linreg, newdata = Test)

# calculate the SSE(sum of squared errors or sum of squared resuduals) i.e. sum of (actual-predicted)^2
> SSE = sum((Test$MEDV-predict.linreg)^2)
> SSE
[1] 3037.088

# Now let's create a regression tree model to compare with linear model we created above
> regTree = rpart(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data=Train)
# predicting on test dat using regression tree model
> predict.regTree = predict(regTree, newdata = Test)
# calculating SSE
> SSE = sum((Test$MEDV-predict.regTree)^2)
> SSE
[1] 4328.988 # since 4328.988 SSE is greater than linear model SSE(i.e. 3037.088), the regression tree model did worse than linear model in predicting our dep.Var "MEDV prices"


# Let's try our regression tree model with cp(complexity parameter)
# but first we need to perform cross validation on cp to find the optimal cp value[since, smaller cp value leads to bigger and complex trees(i.e. more splits)]
#                                                                                 [ and larger cp value leads to smaller and less complex trees(i.e. fewer splits)]
> library(caret) # remember to load these packages for cross validation
> library(e1071)
> tr.control = trainControl(method="cv", number = 10)# trainControl() to specify the method i.e. cross-validation & number of folds(typically 10 is good amount of folds).   
#                                                 how to decide on number = 10?  (1) low enough so your have enough data in each fold to be able to train your model and to test it. 
#                                                                                (2) high enough so you have enough iterations to get the desired averaging effect. 
# specifying the range of cp
> cp.grid = expand.grid(.cp=seq(0, 0.010, 0.001))
# or
> cp.grid = expand.grid(.cp=(0:10)*0.001)

# now we're ready to perform the cross validation using train()
> tr = train(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data=Train, method="rpart", trControl=tr.control, tuneGrid=cp.grid)
CART 

364 samples
13 predictor

No pre-processing
Resampling: Cross-Validated (10 fold) 
Summary of sample sizes: 327, 329, 327, 328, 328, 328, ... 
Resampling results across tuning parameters:
  
  cp     RMSE      Rsquared   MAE     
0.000  5.003135  0.7204073  3.259608
0.001  5.007608  0.7207227  3.272350
0.002  5.025997  0.7224390  3.319279
0.003  5.068317  0.7171840  3.333234
0.004  5.015624  0.7228843  3.322608
0.005  5.026136  0.7213797  3.352798
0.006  5.001655  0.7209248  3.369382
0.007  5.001781  0.7189620  3.406901
0.008  4.988920  0.7195226  3.391961
0.009  5.003701  0.7179598  3.370678
0.010  5.003701  0.7179598  3.370678

RMSE was used to select the optimal model using the smallest value.
The final value used for the model was cp = 0.008.
# ^so we're gona use the cp=0.008 in our regression tree model

# lets create our final regression tree model with parameter cp whose optimal value we decided by cross-validation
> regTreeCV = rpart(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data=Train, cp=0.008)
# or a shortcut to create the  model with final value of cp
> regTreeCV = tr$finalModel
> prp(regTreeCV)
> predict.regTreeCV = predict(regTreeCV, newdata = Test)
> SSE = sum((Test$MEDV-predict.regTreeCV)^2)
> SSE
[1] 3679.337 # this has improver over out regreession tree model without the parameter cp(SSE=4328.988) but hasn't improved over linear model that has SSE = 3037.088



