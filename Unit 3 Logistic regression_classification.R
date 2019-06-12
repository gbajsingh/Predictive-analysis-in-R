# From healthcare quality logistic regression

# P(y=1) = 1/(1 + e^-(B_0 + B_1x_1 + B_2x_2 +...+ B_kx_k)) which means Positive coef of variable increases the P(y=1) or increases the linear Reg. piece(i.e. B_0 + B_1x_1 + B_2x_2 +...+ B_kx_k)
#                                                                      Negative coef of variable decreases the P(y=1) or decreases the linear Reg. piece
# If P(y=1) are is high then it predicts the value 1 otherwise if P(y=1) is low then it predicts the value 0
# log(ODDS) = B_0 + B_1x_1 + B_2x_2 +...+ B_kx_k
# ODDS = e^(B_0 + B_1x_1 + B_2x_2 +...+ B_kx_k)
# ODDS = P(y=1)/P(y=0) which means ODDS > 1 if P(y=1) is greater
#                                  ODDS < 1 if P(y=0) is greater
# The odds of an event represent the ratio of the (probability that the event will occur) / (probability that the event will not occur).
# - If a race horse runs 100 races and wins 25 times and loses the other 75 times, the probability of winning is 25/100 = 0.25 or 25%, but the odds of the horse
#   winning are 25/75 = 0.333 or 1/3 or 1 win to 3 loses which horse is more likely to loose than win.
# - If the horse runs 100 races and wins 50, the probability of winning is 50/100 = 0.50 or 50%, and the odds of winning are 50/50 = 1/1 or 1 (even odds).
# - If the horse runs 100 races and wins 80, the probability of winning is 80/100 = 0.80 or 80%, and the odds of winning are 80/20 = 4/1 or 4 win to 1 loss.
#   Which means horse is more likely to win than loose.

> setwd("~/Desktop")
> quality = read.csv("quality.csv")
> str(quality)
'data.frame':	131 obs. of  14 variables:
  $ MemberID            : int  1 2 3 4 5 6 7 8 9 10 ...
$ InpatientDays       : int  0 1 0 0 8 2 16 2 2 4 ...
$ ERVisits            : int  0 1 0 1 2 0 1 0 1 2 ...
$ OfficeVisits        : int  18 6 5 19 19 9 8 8 4 0 ...
$ Narcotics           : int  1 1 3 0 3 2 1 0 3 2 ...
$ DaysSinceLastERVisit: num  731 411 731 158 449 ...
$ Pain                : int  10 0 10 34 10 6 4 5 5 2 ...
$ TotalVisits         : int  18 8 5 20 29 11 25 10 7 6 ...
$ ProviderCount       : int  21 27 16 14 24 40 19 11 28 21 ...
$ MedicalClaims       : int  93 19 27 59 51 53 40 28 20 17 ...
$ ClaimLines          : int  222 115 148 242 204 156 261 87 98 66 ...
$ StartedOnCombination: logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ AcuteDrugGapSmall   : int  0 1 5 0 0 4 0 0 0 0 ...
$ PoorCare            : int  0 0 0 0 0 1 0 0 1 0 ...

# to see how many patients received poor(i.e. 1) or good(i.e. 0) care
> table(quality$PoorCare)
 0  1 
98 33

# to compare the accuracy of predictions of baseline model with logistic regression model, we take the average of most frequent outcome of the dependent variable
> 98/(98+33)
[1] 0.748091 # about 0.75 or 75% of 131 members/patients are value "0" or not received not PoorCare;
# ^ so our baseline model has an accuracy of 75%. Meaning this model's prediction will be correct 75% of times

# to randomly split our data to training and test data, caTools package needs to be install and load
> install.packages("caTools")
> library(caTools)

# generally sample.split() will split our data randomally and it could be different from the instructor's example
# To make sure we get the same data when using sample.split() we'll first set our seed by typing set.seed(For e.g. 88)
# This intializes the random generator
> set.seed(88)

# to use sample.split you set it equal to a variable(i.e in our case split)
# sample.split takes 2 arguments as: sample.split(outcome variable, SplitRatio = percentage of data we want in training set)
> split =  sample.split(quality$PoorCare, SplitRatio = 0.75) # sample.split() makes sure the outcome variable is well-balanced in both sets
                                                             # meaning this function makes sure in both training & test set 75% of observations/patients are good care(i.e 1)

# if you take a look at split you'll see TRUE value is for observation in training set and FALSE value is for test set
> split
[1]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
[22]  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE FALSE
[43]  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
[64]  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE
[85]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
[106]  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE
[127] FALSE  TRUE  TRUE  TRUE FALSE

# lets subset the data into training and test set using TRUE & FALSE values from split
> qualityTrain = subset(quality, split == TRUE)
> qualityTest = subset(quality, split == FALSE)

# Now to build a logistic regression model, gml()"generalized linear model" function need to be used
# gml() is just like lm() but with one additional argument called family=
# we'll use independent variables(such as OfficeVisits, Narcotics)
> QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial) # "family=binomial" argument tells the glm function to build a logistic regression
> summary(QualityLog)

Call:
  glm(formula = PoorCare ~ OfficeVisits + Narcotics, family = binomial, 
      data = qualityTrain)

Deviance Residuals: 
  Min        1Q    Median        3Q       Max  
-2.06303  -0.63155  -0.50503  -0.09689   2.16686  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -2.64613    0.52357  -5.054 4.33e-07 ***
  OfficeVisits  0.08212    0.03055   2.688  0.00718 ** 
  Narcotics     0.07630    0.03205   2.381  0.01728 *  
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 111.888  on 98  degrees of freedom
Residual deviance:  89.127  on 96  degrees of freedom
AIC: 95.127

Number of Fisher Scoring iterations: 4

# predicting on the training data
> predictTrain = predict(QualityLog, type = "response") # type = 'response' arguments tells the function that we want probabilities of predicting the value 1(i.e. P(y=1)) 
> summary(predictTrain)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.06623 0.11912 0.15967 0.25253 0.26765 0.98456

# Lets's see if we're predicting actual value 1(i.e. in our case actual poor cases) with higher probability
# we use tapply() to first categorized the predicted probalilities with 1(i.e. actual poor cases) & 0(i.e. actual good cases) and then see the average of each case
> tapply(predictTrain, qualityTrain$PoorCare, mean)
        0         1 
0.1894512 0.4392246
# ^so we predicted value 1(i.e. poor cases) with higher probaility than baseline method(i.e. accuracy of 0.25 or 25% in predicting value 1 or PoorCare)
# meaning we predicted the value 1 with sort of higher power/certainty

# for more explaination have a look at table of prob. of prediction vs dependent variable(i.e. predictTrain vs qualityTrain$PoorCare)
> table(predictTrain, qualityTrain$PoorCare)

predictTrain       0 1
0.0662277251693079 2 0
0.0767244894863637 1 0
0.0827478617783435 1 0
0.0891984232865038 1 0
0.0896722506198528 1 0
0.0955949308830142 2 1
0.0966057480593155 1 0
0.104014091607921  3 0
0.10906109605324   1 0
0.110768761378199  0 1
0.111343164162307  1 0
0.111920170676215  5 0
0.118510830326225  3 0
0.119120002336134  2 1
0.119731880306699  2 0
0.120346471881801  6 0
0.127362170737928  1 0
0.12931480005561   2 1
0.136772025603965  1 0
0.138151737839593  2 0
0.138845966187357  1 0
0.146033093629737  1 0
0.14749026643802   1 1
0.148223351281918  1 0
0.158893842367724  2 0
0.159672991408521  3 0
0.171002257474043  0 1
0.175262044195541  1 0
0.178651577909466  1 0
0.182960350916303  1 0
0.193733259133362  1 0
0.194643711835899  1 3
0.195557405444235  2 0
0.207840551828054  1 0
0.22068356350119   0 1
0.245878540217588  1 0
0.250219437024363  0 1
0.251312604533176  2 0
0.252408940144408  1 0
0.255843566537014  1 0
0.259180940234727  1 0
0.267077435916474  2 0
0.268217906603057  1 0
0.283456781824311  1 1
0.296773151274898  1 0
0.299207453572079  1 0
0.301653158215329  1 0
0.315448035388706  1 0
0.31922938488451   0 1
0.374971332328017  0 1
0.461898843374982  1 1
0.532100064285423  1 0
0.590001917714118  1 0
0.620885435356559  0 1
0.632976648769935  1 0
0.670530158641902  0 1
0.717686069442553  0 1
0.728305681610878  0 2
0.756116058307955  0 1
0.781393362906955  0 1
0.783148699359132  0 1
0.880930426614514  1 0
0.942001278126361  0 1
0.984560132480837  0 1

# Now, to asses the accuracy of our predictions(i.e. value of 0 or 1) by deciding on threshhold

# confusion matrix:
#           Predicted=0  Predicted=1
# Actual=0  True Neg.    False Pos.
# Actual=1  False Neg.   True Pos.

# Sensitivity(i.e. True Pos. rate) = TP/(TP+FP)
# Specificity(i.e. True Neg. rate) = TN/(TN+FN)

# computing confusion matrix from our case "predicting PoorCare" where threshhold is 0.5
> table(qualityTrain$PoorCare, predictTrain > 0.5)
  FALSE TRUE
0    70    4
1    15   10
# Sensitivity(i.e. True Pos. rate)
> 10/(15+10)
[1] 0.4
# Specificity(i.e. True Neg. rate)
> 70/(70+4)
[1] 0.9459459

# computing confusion matrix from our case "predicting PoorCare" where threshhold is large, 0.7
> table(qualityTrain$PoorCare, predictTrain > 0.7)
  FALSE TRUE
0    73    1
1    17    8
# Sensitivity(i.e. True Pos. rate)
> 8/(17+8)
[1] 0.32
# Specificity(i.e. True Neg. rate)
> 73/(73+1)
[1] 0.9864865

# computing confusion matrix from our case "predicting PoorCare" where threshhold is small, 0.2
> table(qualityTrain$PoorCare, predictTrain > 0.2)
  FALSE TRUE
0    54   20
1     9   16
# Sensitivity(i.e. True Pos. rate)
> 16/(9+16)
[1] 0.64
# Specificity(i.e. True Neg. rate)
> 54/(20+54)
[1] 0.7297297

# to visualise the different thresh-hold values we can create ROC(Receiver Operator Characteristic) Curve: 
# Where x-axis is False Pos. rate(i.e.1- specificity) and y-axis is True Pos. rate(i.e.sensitivity)
# Higher Threshhold(i.e closer to (0,0)): low senstivity & high specificity
# Lower Threshhold(i.e. closer to (1,1)): high sensitivity & low specificity

# to add the ROC curve we need to install and load the package called ROCR
> install.packages("ROCR")
> library(ROCR)

# first, just like table(qualityTrain$PoorCare, predictTrain) to compute confusion matrix
# we need to give the prediction() two arguments
# output of predict() we used above(i.e predictTrain) & the true outcomes(i.e. 1 and 0 in our case) of our data points(i.e. data points of our dependent variable PoorCare)
> ROCRpred = prediction(predictTrain, qualityTrain$PoorCare)


# ********************************************************************************************************************************************************************************
# prediction() basically compares the predictions made by predict() with actual outcome of ind.var we're trying to predict.
# Have a look at prediction() output to better understand
> prediction(predictTrain, qualityTrain$PoorCare)
An object of class "prediction"
Slot "predictions":
  [[1]]
1          2          3          4          5          6          7          8          9 
0.20352999 0.12262021 0.14909880 0.18964599 0.26160636 0.15726042 0.13385799 0.11862721 0.14283061 
10         11         12         13         15         17         18         19         20 
0.10608606 0.24497917 0.18199595 0.10729098 0.39313241 0.12398687 0.22032088 0.15397499 0.19749533 
21         24         27         28         29         30         31         32         33 
0.17285407 0.13828321 0.14132389 0.12126653 0.94885584 0.37229551 0.09052588 0.46386575 0.10850792 
34         35         36         38         39         40         41         42         43 
0.16574285 0.54536256 0.43274668 0.12813404 0.18016292 0.11862721 0.16064060 0.12398687 0.08257912 
44         45         48         49         50         51         53         54         55 
0.21180378 0.14753734 0.13239897 0.09052588 0.15559214 0.16064060 0.18203785 0.11346923 0.11346923 
56         57         59         60         61         62         63         65         66 
0.47639255 0.12955308 0.76386165 0.21815680 0.11346923 0.91626981 0.22032088 0.21180378 0.24038387 
67         70         71         72         73         74         75         77         79 
0.10256854 0.28400197 0.15397499 0.20352999 0.09803114 0.17285407 0.13828321 0.12126653 0.11862721 
80         81         82         83         85         89         90         91         93 
0.10373814 0.10850792 0.18579058 0.48564987 0.12398687 0.14909880 0.08257912 0.39299813 0.16064060 
94         95         96         97         98        103        106        107        108 
0.16064060 0.11862721 0.14909880 0.27894512 0.15233526 0.17285407 0.99922012 0.83395632 0.34617748 
110        111        112        113        114        116        117        119        121 
0.69992640 0.25680525 0.98984512 0.21392208 0.85218901 0.14595434 0.89128160 0.48564987 0.13979663 
122        123        124        125        126        128        129        130        131 
0.11862721 0.12813404 0.17466915 0.22250031 0.10850792 0.12126653 0.28652227 0.17285407 0.29177722 # all the probilities of value "1" of 99 observations of training data

Slot "labels":
  [[1]]
[1] 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 1 1 0 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 0 0 1 0
[51] 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 0 1 0 0 0 0 0 1 0 0 0 1 0 # actual outcomes of ind.var. of training data
Levels: 0 < 1

Slot "cutoffs":
  [[1]]
                  106        112         29         62        117        114        107         59 
       Inf 0.99922012 0.98984512 0.94885584 0.91626981 0.89128160 0.85218901 0.83395632 0.76386165 
       110         35        119         56         32         36         15         91         30 
0.69992640 0.54536256 0.48564987 0.47639255 0.46386575 0.43274668 0.39313241 0.39299813 0.37229551 
       108        131        129         70         97          5        111         11         66 
0.34617748 0.29177722 0.28652227 0.28400197 0.27894512 0.26160636 0.25680525 0.24497917 0.24038387 
       125         63         60        113         65         72         20          4         82 
0.22250031 0.22032088 0.21815680 0.21392208 0.21180378 0.20352999 0.19749533 0.18964599 0.18579058 
        53         12         39        124        130         34         94          6         50 
0.18203785 0.18199595 0.18016292 0.17466915 0.17285407 0.16574285 0.16064060 0.15726042 0.15559214 
        71         98         96         45        116          9         27        121         75 
0.15397499 0.15233526 0.14909880 0.14753734 0.14595434 0.14283061 0.14132389 0.13979663 0.13828321 
         7         48         57        123         85          2        128        122         61 
0.13385799 0.13239897 0.12955308 0.12813404 0.12398687 0.12262021 0.12126653 0.11862721 0.11346923 
       126         13         10         80         67         73         49         90 
0.10850792 0.10729098 0.10608606 0.10373814 0.10256854 0.09803114 0.09052588 0.08257912 # all 70 the different cutOffs

Slot "fp":
  [[1]]
[1]  0  0  0  0  0  0  0  0  1  1  1  2  2  3  4  5  6  6  7  8  9 10 11 12 13 14 15 15 16 16 17 19 21
[34] 22 23 24 25 26 27 28 29 30 33 33 34 36 37 40 41 42 42 43 44 45 46 46 47 49 51 52 54 59 62 65 66 67
[67] 68 69 70 72 74 # number of False positive values(i.e. value of "1") predicted at all the 70 different cutOffs and 1 cutOff at 0(i.e.the very first value)

Slot "tp":
  [[1]]
[1]  0  1  2  3  4  5  6  7  7  8  9 10 11 11 11 11 11 12 12 12 12 12 12 12 12 12 12 13 14 15 15 15 15
[34] 15 15 15 15 15 15 15 18 18 19 20 20 20 20 20 20 20 21 21 21 22 22 23 23 23 24 24 25 25 25 25 25 25
[67] 25 25 25 25 25 # number of True positive values(i.e. value of "1") predicted at all the 70 different cutOffs and 1 cutOff at 0(i.e. the very first value)

Slot "tn":
  [[1]]
[1] 74 74 74 74 74 74 74 74 73 73 73 72 72 71 70 69 68 68 67 66 65 64 63 62 61 60 59 59 58 58 57 55 53
[34] 52 51 50 49 48 47 46 45 44 41 41 40 38 37 34 33 32 32 31 30 29 28 28 27 25 23 22 20 15 12  9  8  7
[67]  6  5  4  2  0 # number of True negative values(i.e. value of "0") predicted at all the 70 different cutOffs and 1 cutOff at 0(i.e.the very last value)

Slot "fn":
  [[1]]
[1] 25 24 23 22 21 20 19 18 18 17 16 15 14 14 14 14 14 13 13 13 13 13 13 13 13 13 13 12 11 10 10 10 10
[34] 10 10 10 10 10 10 10  7  7  6  5  5  5  5  5  5  5  4  4  4  3  3  2  2  2  1  1  0  0  0  0  0  0
[67]  0  0  0  0  0 # number of False negative values(i.e. value of "0") predicted at all the 70 different cutOffs and 1 cutOff at 0(i.e. the very last value)

Slot "n.pos":
  [[1]]
[1] 25 # number of True Posituve values or actual positive values(i.e. value of "1")

Slot "n.neg":
  [[1]]
[1] 74 # number of True negative values or actual negative values(i.e. value of "0")

Slot "n.pos.pred":
  [[1]]
[1]  0  1  2  3  4  5  6  7  8  9 10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 30 31 32 34 36
[34] 37 38 39 40 41 42 43 47 48 52 53 54 56 57 60 61 62 63 64 65 67 68 69 70 72 75 76 79 84 87 90 91 92
[67] 93 94 95 97 99 # number of Total positive values(i.e value of "1") predicted at 70 different cutOffs and 1 cutOff at 0(i.e. the very first value)

Slot "n.neg.pred":
  [[1]]
[1] 99 98 97 96 95 94 93 92 91 90 89 87 86 85 84 83 82 81 80 79 78 77 76 75 74 73 72 71 69 68 67 65 63
[34] 62 61 60 59 58 57 56 52 51 47 46 45 43 42 39 38 37 36 35 34 32 31 30 29 27 24 23 20 15 12  9  8  7
[67]  6  5  4  2  0 # number of Total negative values(i.e value of "0") predicted at 70 different cutOffs and 1 cutOff at 0(i.e. the very last value)
# *******************************************************************************************************************************************************************************************************

# Second, use performance() with first argument of output of prediction(), second argument x-axis and third y-axis
> ROCRperf = performance(ROCRpred, "tpr", "fpr") # "tpr"(True Pos. rate or senstivity), "fpr"(False Pos. rate or 1-specificity)

# Finally, we can plot the ROCR curve
> plot(ROCRperf)
# to add color to the curve based on threshhold values add an argument colorize=TRUE
> plot(ROCRperf, colorize=TRUE)
# to add the threshhold labels to the curve, add an argument print.cutoffs.at=seq(start,end,incriment)
# and also to adjust the label's text fitting add an argumet text.adj=c(for.e.g.-0.2,1.7) 
> plot(ROCRperf, colorize=TRUE, print.cuttoffs.at=seq(0,1,0.1))

# Now to asses the stength of our logistic regression model you need to calculate AUC(Area Under the Curve(i.e. ROC curve))
# Basically AUC is to asses how accurate predictions spit by the model are **as compare to purely guessing which would've AUC of 50%**?[since "0" & "1" are 2 outcomes, guessing would've 1/2 or 50-50 chance]?

# first let's predict the dependent varaible(i.e. PoorCare) on the test data
> predictTest = predict(QualityLog, type="response", newdata = qualityTest)
> table(qualityTest$PoorCare, predictTest > 0.3)
  FALSE TRUE
0    19    5
1     2    6
# lets se what would be the accuracy of baseline model that picks the most frequent outcome which is picking value "0"(i.e. threshhold of 1)
> 19+5
[1] 24 # correct
# or
> (19+5)/(19+5+2+6)
[1] 0.75 # 75% accuracy of baseline model

# now let's see  the accuracy of oue logistic regression model with the threshhold of 0.3
> 19+6
[25] # correct
# or
> (19+6)/(19+5+2+6)
[1] 0.78125 # 78% accuracy of our logisitic regression model even with 0.3 threshhold

# to calculate AUC let's set the ROC by using prediction()
> ROCRpredTest = prediction(predictTest, qualityTest$PoorCare)

# to calculate auc you performe "auc" this time instead of "tpr","fpr" and then turn it into numeric value using as.numeric()
> auc = as.numeric(performance(ROCRpredTest,"auc")@y.values)
> auc
[1] 0.7994792 # AUC of 79% means 79% of times it will predict the right outcome as compare to purely guessing which would've AUC of 50%[since "0" & "1" are 2 outcomes, guessing would've 1/2 or 50-50 chance]
# ^The AUC of a model has the following nice interpretation: given a random patient from the dataset 
# who actually received poor care, and a random patient from the dataset who actually received good care, 
# the AUC is the perecentage of time that our model will classify(based on prob.(i.e. high or low) spit by the model) correctly which is which.






# From Framingham heart diesease study -  predicting 10-year CHD risk

> framingham = read.csv("framingham.csv")
> str(framingham)
'data.frame':	4240 obs. of  16 variables:
  $ male           : int  1 0 1 0 0 0 0 0 1 1 ...
$ age            : int  39 46 48 61 46 43 63 45 52 43 ...
$ education      : int  4 2 1 3 3 2 1 2 1 1 ...
$ currentSmoker  : int  0 0 1 1 1 0 0 1 0 1 ...
$ cigsPerDay     : int  0 0 20 30 23 0 0 20 0 30 ...
$ BPMeds         : int  0 0 0 0 0 0 0 0 0 0 ...
$ prevalentStroke: int  0 0 0 0 0 0 0 0 0 0 ...
$ prevalentHyp   : int  0 0 0 1 0 1 0 0 1 1 ...
$ diabetes       : int  0 0 0 0 0 0 0 0 0 0 ...
$ totChol        : int  195 250 245 225 285 228 205 313 260 225 ...
$ sysBP          : num  106 121 128 150 130 ...
$ diaBP          : num  70 81 80 95 84 110 71 71 89 107 ...
$ BMI            : num  27 28.7 25.3 28.6 23.1 ...
$ heartRate      : int  80 95 75 65 85 77 60 79 76 93 ...
$ glucose        : int  77 76 70 103 85 99 85 78 79 88 ...
$ TenYearCHD     : int  0 0 0 1 0 0 1 0 0 0 ...

# loading caTools to to use split function to randomly split the data
> library(caTools)
# setting seed same as instructor in the video
> set.seed(1000)
> split = sample.split(framingham$TenYearCHD, SplitRatio = 0.65)
> train = subset(framingham, split == TRUE)
> test = subset(framingham, split == FALSE)

# creating a logistic regression model with all the variables to predict TenYearCHD risk
> framinghamLog =  glm(TenYearCHD ~ ., data=train, family=binomial)
> summary(framinghamLog)

Call:
  glm(formula = TenYearCHD ~ ., family = binomial, data = train)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-1.8487  -0.6007  -0.4257  -0.2842   2.8369  

Coefficients:
                 Estimate Std. Error z value Pr(>|z|)    
(Intercept)     -7.886574   0.890729  -8.854  < 2e-16 ***
male             0.528457   0.135443   3.902 9.55e-05 ***
age              0.062055   0.008343   7.438 1.02e-13 ***
education       -0.058923   0.062430  -0.944  0.34525    
currentSmoker    0.093240   0.194008   0.481  0.63080    
cigsPerDay       0.015008   0.007826   1.918  0.05514 .  
BPMeds           0.311221   0.287408   1.083  0.27887    
prevalentStroke  1.165794   0.571215   2.041  0.04126 *  
prevalentHyp     0.315818   0.171765   1.839  0.06596 .  
diabetes        -0.421494   0.407990  -1.033  0.30156    
totChol          0.003835   0.001377   2.786  0.00533 ** 
sysBP            0.011344   0.004566   2.485  0.01297 *  
diaBP           -0.004740   0.008001  -0.592  0.55353    
BMI              0.010723   0.016157   0.664  0.50689    
heartRate       -0.008099   0.005313  -1.524  0.12739    
glucose          0.008935   0.002836   3.150  0.00163 ** 
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 2020.7  on 2384  degrees of freedom
Residual deviance: 1792.3  on 2369  degrees of freedom
(371 observations deleted due to missingness)
AIC: 1824.3

Number of Fisher Scoring iterations: 5

# predicting on the test data
> predictTest = predict(framinghamLog, type = "response", newdata = test)

# making a confusion matrix with threshhold of 0.5
> table(test$TenYearCHD, predictTest > 0.5)
  FALSE TRUE
0  1069    6
1   187   11
> (1069+11)/(1069+6+187+11)# accuracy of this logistic regression model with the threshhold of 0.5 = sum of right predictions/total observations
[1] 0.8483896
> (1069+6)/(1069+6+187+11)# accuracy of baseline method that alaways predict most frequent outcome(i.e.threshhold  at 1)
[1] 0.8444619
> #^ our logistic regression model(with threshhold of 0.5) barely beats the baseline model in terms of accuracy

# loading ROCR package to calculate AUC(Area under the curve)
# i.e. to see how accurate/percentage of times our model(based on high or low prob. predicted as an output) will classify a random data point of actual value "0" and a random data point of actual value "1" correctly which is which. 
> library(ROCR)
> ROCRpred = prediction(predictTest, test$TenYearCHD)
> as.numeric(performance(ROCRpred, "auc")@y.values) # calculating auc
[1] 0.7421095 # so 74% accurate in classifying(based on high or low prob. spit by the model) correctly which is which [**compare to purely guessing which would've AUC of 50%**]






# From recitation predicting presidental elections
# Dependent variables: Republican ==> 1 if Republican won state, 0 if Democrat won state
# Independent Variables: Ramussen, SurveyUSA ==> Polled R% - Polled D%
#                        DiffCount ==> Polls with R winner - Polls with D winner
#                        PropR ==> Proportion of all the polls that predicted R as a winner

> polling  = read.csv("PollingData.csv")
> str(polling)
'data.frame':	145 obs. of  7 variables:
  $ State     : Factor w/ 50 levels "Alabama","Alaska",..: 1 1 2 2 3 3 3 4 4 4 ...
$ Year      : int  2004 2008 2004 2008 2004 2008 2012 2004 2008 2012 ...
$ Rasmussen : int  11 21 NA 16 5 5 8 7 10 NA ...
$ SurveyUSA : int  18 25 NA NA 15 NA NA 5 NA NA ...
$ DiffCount : int  5 5 1 6 8 9 4 8 5 2 ...
$ PropR     : num  1 1 1 1 1 ...
$ Republican: int  1 1 1 1 1 1 1 1 1 1 ...
# ^Notice, there're some missing values for the variable Rasmussen and SurveyUSA

# to fill the missing values we can use several approaches:

# One approach is:     to remove the observation with missing values, but, that will take out 50% of our observations from the data set
# second approach is:  to remove the variables with missing values, however, we expect these variables(i.e. Rasmussen & SurveyUSA) to be qualitatively different from aggergate variables(i.e. DiffCount and PropR)
# third approach is:   multiple imputation(In statistics, imputation is the process of replacing missing data with substituted values.). 
#                      For instance, if the Rasmussen variable is reported very negative, then a missing SurveyUSA value would likely be filled in as a negative value as well.

# to fill the missing values using multiple imputation appraoch we need to install and load the package "mice"
> install.packages("mice")
> library(mice)

# to find out the values of missiing values without using the dependent variable, we've to limit our data frame to only indepndent variables
# therefore we create a new data frame called "simple"
> simple = polling[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount")]
> summary(simple)
Rasmussen          SurveyUSA            PropR          DiffCount      
Min.   :-41.0000   Min.   :-33.0000   Min.   :0.0000   Min.   :-19.000  
1st Qu.: -8.0000   1st Qu.:-11.7500   1st Qu.:0.0000   1st Qu.: -6.000  
Median :  1.0000   Median : -2.0000   Median :0.6250   Median :  1.000  
Mean   :  0.0404   Mean   : -0.8243   Mean   :0.5259   Mean   : -1.269  
3rd Qu.:  8.5000   3rd Qu.:  8.0000   3rd Qu.:1.0000   3rd Qu.:  4.000  
Max.   : 39.0000   Max.   : 30.0000   Max.   :1.0000   Max.   : 11.000  
NA's   :46         NA's   :71

# just like in sample.split function, multiple runs of multiple imputations will result in different missing values being filled in based on random seed
# so we set the seed manually to get same imputation as instructor in the video
> set.seed(144)

# Finally, we fill the missing values by calling complete() on mice(). on calling mice() on our limited data set we created(i.e. simple)
# and we call this new data frame with filled values "imputed"
> imputed = complete(mice(simple))

iter imp variable
1   1  Rasmussen  SurveyUSA
1   2  Rasmussen  SurveyUSA
1   3  Rasmussen  SurveyUSA
1   4  Rasmussen  SurveyUSA
1   5  Rasmussen  SurveyUSA
2   1  Rasmussen  SurveyUSA
2   2  Rasmussen  SurveyUSA
2   3  Rasmussen  SurveyUSA
2   4  Rasmussen  SurveyUSA
2   5  Rasmussen  SurveyUSA
3   1  Rasmussen  SurveyUSA
3   2  Rasmussen  SurveyUSA
3   3  Rasmussen  SurveyUSA
3   4  Rasmussen  SurveyUSA
3   5  Rasmussen  SurveyUSA
4   1  Rasmussen  SurveyUSA
4   2  Rasmussen  SurveyUSA
4   3  Rasmussen  SurveyUSA
4   4  Rasmussen  SurveyUSA
4   5  Rasmussen  SurveyUSA
5   1  Rasmussen  SurveyUSA
5   2  Rasmussen  SurveyUSA
5   3  Rasmussen  SurveyUSA
5   4  Rasmussen  SurveyUSA
5   5  Rasmussen  SurveyUSA
# ^ So the output here shows that five runs of imputation have ben run and now all the variables have been filled in

# to check if the all the variables have benn filled we can call summary() on imputed data set
> summary(imputed)
Rasmussen         SurveyUSA           PropR          DiffCount      
Min.   :-41.000   Min.   :-33.000   Min.   :0.0000   Min.   :-19.000  
1st Qu.: -8.000   1st Qu.:-11.000   1st Qu.:0.0000   1st Qu.: -6.000  
Median :  3.000   Median :  1.000   Median :0.6250   Median :  1.000  
Mean   :  1.731   Mean   :  1.517   Mean   :0.5259   Mean   : -1.269  
3rd Qu.: 11.000   3rd Qu.: 18.000   3rd Qu.:1.0000   3rd Qu.:  4.000  
Max.   : 39.000   Max.   : 30.000   Max.   :1.0000   Max.   : 11.000  

# now we add the filled variables back to the original data set
> polling$Rasmussen = imputed$Rasmussen
> polling$SurveyUSA = imputed$SurveyUSA

# lets see the accuracy of baseline model(where the model always predict the most frequent outcome of dep.variable)
> table(Train$Republican)
 0  1 
47 53 
> 53/(53+47)
[1] 0.53 # 53% accuracy of baseline model. Meaning the prediction of this model will be correct 53% of times only
#          This is not a credible model since it will predict Republican even where Democrat has won the state with a landslide like 15%-20%

# Therfore, we need to make a reasonale smart baseline model to compare it's accuracy with the Logistic Regression models accuracy  that we'rre gona develop later.
# One way to make a reasonable smarter baseline model predict based on one indepndent variable(such as Rasmussen variable)
# So This baseline model based on Rasmussen poll variable will predict Republican if the Rasmussen value is positive and Democrat if the Rasmussen value is negative.

# to develop this reasonable smarter baseline model we'll use the sign() which returns 1 if the argument is positive value(i.e. Republican leading in polls), -1 if negative value(i.e. Democrats leading in polls) and 0 if value is 0(i.e. a tie)
> table(sign(Train$Rasmussen))
-1  0  1 
42  2 56 
# let's comapare these predictions with actual dependent variable of Train data
> table(Train$Republican, sign(Train$Rasmussen))
  -1  0  1
0 42  1  4
1  0  1 52

> (42+52)/(42+1+4+1+52)
[1] 0.94 # as you can see with 94% accuaracy this smarter baseline model is doing much better than naive baseline model which always predicted most frequent outcome(i.e.Republican) and got 47 mistakes hence resulting in only 53% accuracy

# now in building a logistic regression model with this data we want to consider multicollinearity issue since all the independent variables are measuring the same thing(i.e. how strong the Republican candidate is performing)
# so lets'check the correlation among the variables
> cor(Train[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount", "Republican")])
Rasmussen SurveyUSA     PropR DiffCount Republican
Rasmussen  1.0000000 0.9365837 0.8431180 0.5109169  0.7929252
SurveyUSA  0.9365837 1.0000000 0.8616478 0.5222585  0.8101645
PropR      0.8431180 0.8616478 1.0000000 0.8273785  0.9484204
DiffCount  0.5109169 0.5222585 0.8273785 1.0000000  0.8092777
Republican 0.7929252 0.8101645 0.9484204 0.8092777  1.0000000
# ^since lots of variables are highly correlated, combining them together isn't going to produce a much working regression model

# Therfore lets first build a model with single independent variable and for this we want to choose an ind. variable that is infact highly correlated with the dependent variable
# we'll choose ind.variable "PropR" since it has the highest correlation with the dep.variable "Republican"
> mod1 =  glm(Republican ~ PropR, data= Train, family=binomial)
> summary(mod1)

Call:
  glm(formula = Republican ~ PropR, family = binomial, data = Train)

Deviance Residuals: 
  Min        1Q    Median        3Q       Max  
-2.22880  -0.06541   0.10260   0.10260   1.37392  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -6.146      1.977  -3.108 0.001882 ** 
  PropR         11.390      3.153   3.613 0.000303 ***
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 138.269  on 99  degrees of freedom
Residual deviance:  15.772  on 98  degrees of freedom
AIC: 19.772

Number of Fisher Scoring iterations: 8

# making predictions on Train data to see the accuracy
> pred1 = predict(mod1, type = "response")
> table(Train$Republican, pred1 > 0.5)

  FALSE TRUE
0    45    2
1     2   51
# checking the accuracy of number of times the model predicted correctly
> (45+51)/(45+2+2+51)
[1] 0.96 # improved a little in comparison with smarter baseline model that has accuracy of 94%

# to improve our model's performance we can have a model with 2 independent variable
# in order to see which 2 variables we need to look at variables with low correlation among because similar variables wouldn't improve our model so much
# we'll choose ind.variables SurveyUSA & DiffCount since (SurveyUSA & DiffCount) & (Rasmussen & DiffCount) have the lowest correlation among them
  > mod2 =  glm(Republican ~ SurveyUSA + DiffCount, data= Train, family=binomial)
> summary(mod2)

Call:
  glm(formula = Republican ~ SurveyUSA + DiffCount, family = binomial, 
      data = Train)

Deviance Residuals: 
  Min        1Q    Median        3Q       Max  
-2.04741  -0.00977   0.00561   0.03751   1.32999  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)  
(Intercept)  -0.6827     1.0468  -0.652   0.5143  
SurveyUSA     0.3309     0.2226   1.487   0.1371  
DiffCount     0.6619     0.3663   1.807   0.0708 .
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 138.269  on 99  degrees of freedom
Residual deviance:  11.154  on 97  degrees of freedom
AIC: 17.154

Number of Fisher Scoring iterations: 9

# making predictions on Train data to see the accuracy of this model which has 2 variables
> pred2 = predict(mod2, type = "response")
> table(Train$Republican, pred2 > 0.5)

  FALSE TRUE
0    45    2
1     1   52
> (45+52)/(45+2+1+52)
[1] 0.97 # improved a little more and we'll use this as a final model to predict on Test data

# Before we predict on Test data let's find out how well our smarter baseline model did on Test data
> table(Test$Republican, sign(Test$Rasmussen))
  -1  0  1
0 18  2  4
1  0  0 21
> (18+21)/(18+2+4+21)
[1] 0.8666667 # 87% accuracy

# making predictions on test data 
> pred3 = predict(mod2, type = "response", newdata = Test)
> table(Test$Republican, pred3 > 0.5)
  FALSE TRUE
0    23    1
1     0   21
> (23+21)/(23+1+21)
[1] 0.9777778 # 98% accuracy

# to find out what's that 1 mistake it made during predictions use subset()
> subset(Test, pred3 >= 0.5 & Republican == 0)
State Year Rasmussen SurveyUSA DiffCount     PropR Republican
24 Florida 2012         2         0         6 0.6666667          0






# From HW 4 Predicting the Baseball world series champion
> baseball = read.csv("baseball.csv")
> str(baseball)
'data.frame':	1232 obs. of  15 variables:
  $ Team        : Factor w/ 39 levels "ANA","ARI","ATL",..: 2 3 4 5 7 8 9 10 11 12 ...
$ League      : Factor w/ 2 levels "AL","NL": 2 2 1 1 2 1 2 1 2 1 ...
$ Year        : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
$ RS          : int  734 700 712 734 613 748 669 667 758 726 ...
$ RA          : int  688 600 705 806 759 676 588 845 890 670 ...
$ W           : int  81 94 93 69 61 85 97 68 64 88 ...
$ OBP         : num  0.328 0.32 0.311 0.315 0.302 0.318 0.315 0.324 0.33 0.335 ...# percentage of time a player gets on base including walks
$ SLG         : num  0.418 0.389 0.417 0.415 0.378 0.422 0.411 0.381 0.436 0.422 ...# percentage of how far player gets around on the bases on his turn. Hence, measure power
$ BA          : num  0.259 0.247 0.247 0.26 0.24 0.255 0.251 0.251 0.274 0.268 ...# percentage of time a batter(hitter) gets on base by hitting the ball excluding walks
$ Playoffs    : int  0 1 1 0 0 0 1 0 0 1 ...
$ RankSeason  : int  NA 4 5 NA NA NA 2 NA NA 6 ...
$ RankPlayoffs: int  NA 5 4 NA NA NA 4 NA NA 2 ...
$ G           : int  162 162 162 162 162 162 162 162 162 162 ...
$ OOBP        : num  0.317 0.306 0.315 0.331 0.335 0.319 0.305 0.336 0.357 0.314 ...
$ OSLG        : num  0.415 0.378 0.403 0.428 0.424 0.405 0.39 0.43 0.47 0.402 ...
> summary(baseball)
Team     League        Year            RS               RA        
BAL    : 47   AL:616   Min.   :1962   Min.   : 463.0   Min.   : 472.0  
BOS    : 47   NL:616   1st Qu.:1977   1st Qu.: 652.0   1st Qu.: 649.8  
CHC    : 47            Median :1989   Median : 711.0   Median : 709.0  
CHW    : 47            Mean   :1989   Mean   : 715.1   Mean   : 715.1  
CIN    : 47            3rd Qu.:2002   3rd Qu.: 775.0   3rd Qu.: 774.2  
CLE    : 47            Max.   :2012   Max.   :1009.0   Max.   :1103.0  
(Other):950                                                            
W              OBP              SLG               BA        
Min.   : 40.0   Min.   :0.2770   Min.   :0.3010   Min.   :0.2140  
1st Qu.: 73.0   1st Qu.:0.3170   1st Qu.:0.3750   1st Qu.:0.2510  
Median : 81.0   Median :0.3260   Median :0.3960   Median :0.2600  
Mean   : 80.9   Mean   :0.3263   Mean   :0.3973   Mean   :0.2593  
3rd Qu.: 89.0   3rd Qu.:0.3370   3rd Qu.:0.4210   3rd Qu.:0.2680  
Max.   :116.0   Max.   :0.3730   Max.   :0.4910   Max.   :0.2940  

Playoffs        RankSeason     RankPlayoffs         G        
Min.   :0.0000   Min.   :1.000   Min.   :1.000   Min.   :158.0  
1st Qu.:0.0000   1st Qu.:2.000   1st Qu.:2.000   1st Qu.:162.0  
Median :0.0000   Median :3.000   Median :3.000   Median :162.0  
Mean   :0.1981   Mean   :3.123   Mean   :2.717   Mean   :161.9  
3rd Qu.:0.0000   3rd Qu.:4.000   3rd Qu.:4.000   3rd Qu.:162.0  
Max.   :1.0000   Max.   :8.000   Max.   :5.000   Max.   :165.0  
NA's   :988     NA's   :988                    
OOBP             OSLG       
Min.   :0.2940   Min.   :0.3460  
1st Qu.:0.3210   1st Qu.:0.4010  
Median :0.3310   Median :0.4190  
Mean   :0.3323   Mean   :0.4197  
3rd Qu.:0.3430   3rd Qu.:0.4380  
Max.   :0.3840   Max.   :0.4990  
NA's   :812      NA's   :812     

# notice each observation is Team/Year pair. We can view by calling the table() on var. Year
> table(baseball$Year)
1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1973 1974 1975 1976 1977 
20   20   20   20   20   20   20   24   24   24   24   24   24   24   26 
1978 1979 1980 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 
26   26   26   26   26   26   26   26   26   26   26   26   26   26   28 
1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 
28   28   30   30   30   30   30   30   30   30   30   30   30   30   30 
2011 2012 
30   30 

# creating a subset of teams that made it to PlayOffs
> baseball = subset(baseball, Playoffs == 1)

# now Team/Year pairs are there? check it by using table() on var. Year
> table(baseball$Year)

1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1973 1974 1975 1976 1977 
2    2    2    2    2    2    2    4    4    4    4    4    4    4    4 
1978 1979 1980 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 
4    4    4    4    4    4    4    4    4    4    4    4    4    4    4 
1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 
8    8    8    8    8    8    8    8    8    8    8    8    8    8    8 
2011 2012 
8   10 
# ^also notice that frequency of Year tells us how many teams/competitors/continders in PlayOff in that particular year.
# For example, in 1962 there were 2 teams in PlayOffs as compare to 1996 there were 8 teams in PlayOffs

# Since more the contenders/teams/competitors are in PlayOffs harder is to win the world series, we'll create a ind.variable called "NumCompetitors" and add to the data frame which will help us predict
# to do that we need to store the output of table(baseball$yYear) in a vector and then to get the particular Year's frequency we have to call the entry/column by it's "name"(i.e. "year" for.eg."1962")
> PlayoffTable = table(baseball$Year) 
# ^notice if you call names(PlayoffTable) it will return the string. To verify you can see structure type by calling str() on names(Playofftable)
> str(names(PlayoffTable))
chr [1:47] "1962" "1963" "1964" "1965" "1966" "1967" "1968" "1969" ...

> baseball$NumCompetitors = PlayoffTable[as.character(baseball$Year)] # as.character() converts the integer value of Year var. to the string

# Now, let's add a variable called "WorldSeries" which will have the value "1" if ind.var.baseball$RankPlayoffs is 1 otherwise value "0"
> baseball$WorldSeries = as.numeric(baseball$RankPlayoffs == 1) # as.numeric() sets the value of 0 or 1 based on the condition

# When we're not sure which of our variables are useful in predicting a particular outcome, it's often helpful to build bivariate models, 
# which are models that predict the outcome using a single independent variable.
summary(glm(WorldSeries ~ RS, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ RS, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.8254  -0.6819  -0.6363  -0.5561   2.0308  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)
(Intercept)  0.661226   1.636494   0.404    0.686
RS          -0.002681   0.002098  -1.278    0.201

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 237.45  on 242  degrees of freedom
AIC: 241.45

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ RA, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ RA, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.9749  -0.6883  -0.6118  -0.4746   2.1577  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)  
(Intercept)  1.888174   1.483831   1.272   0.2032  
RA          -0.005053   0.002273  -2.223   0.0262 *
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 233.88  on 242  degrees of freedom
AIC: 237.88

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ W, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ W, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-1.0623  -0.6777  -0.6117  -0.5367   2.1254  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)  
(Intercept) -6.85568    2.87620  -2.384   0.0171 *
  W            0.05671    0.02988   1.898   0.0577 .
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 235.51  on 242  degrees of freedom
AIC: 239.51

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ OBP, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ OBP, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.8071  -0.6749  -0.6365  -0.5797   1.9753  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)
(Intercept)    2.741      3.989   0.687    0.492
OBP          -12.402     11.865  -1.045    0.296

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 238.02  on 242  degrees of freedom
AIC: 242.02

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ SLG, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ SLG, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.9498  -0.6953  -0.6088  -0.5197   2.1136  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)  
(Intercept)    3.200      2.358   1.357   0.1748  
SLG          -11.130      5.689  -1.956   0.0504 .
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 235.23  on 242  degrees of freedom
AIC: 239.23

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ BA, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ BA, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.6797  -0.6592  -0.6513  -0.6389   1.8431  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)
(Intercept)  -0.6392     3.8988  -0.164    0.870
BA           -2.9765    14.6123  -0.204    0.839

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 239.08  on 242  degrees of freedom
AIC: 243.08

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ RankSeason, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ RankSeason, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.7805  -0.7131  -0.5918  -0.4882   2.1781  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)  
(Intercept)  -0.8256     0.3268  -2.527   0.0115 *
  RankSeason   -0.2069     0.1027  -2.016   0.0438 *
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 234.75  on 242  degrees of freedom
AIC: 238.75

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ OOBP, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ OOBP, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.5318  -0.5176  -0.5106  -0.5023   2.0697  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)
(Intercept)  -0.9306     8.3728  -0.111    0.912
OOBP         -3.2233    26.0587  -0.124    0.902

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 84.926  on 113  degrees of freedom
Residual deviance: 84.910  on 112  degrees of freedom
(130 observations deleted due to missingness)
AIC: 88.91

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ OSLG, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ OSLG, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.5610  -0.5209  -0.5088  -0.4902   2.1268  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)
(Intercept) -0.08725    6.07285  -0.014    0.989
OSLG        -4.65992   15.06881  -0.309    0.757

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 84.926  on 113  degrees of freedom
Residual deviance: 84.830  on 112  degrees of freedom
(130 observations deleted due to missingness)
AIC: 88.83

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ NumCompetitors, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ NumCompetitors, family = binomial, 
      data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.9871  -0.8017  -0.5089  -0.5089   2.2643  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)    
(Intercept)     0.03868    0.43750   0.088 0.929559    
NumCompetitors -0.25220    0.07422  -3.398 0.000678 ***
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 226.96  on 242  degrees of freedom
AIC: 230.96

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ League, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ League, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-0.6772  -0.6772  -0.6306  -0.6306   1.8509  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -1.3558     0.2243  -6.045  1.5e-09 ***
  LeagueNL     -0.1583     0.3252  -0.487    0.626    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 238.88  on 242  degrees of freedom
AIC: 242.88

Number of Fisher Scoring iterations: 4

> summary(glm(WorldSeries ~ Year, data=baseball, family = binomial))

Call:
  glm(formula = WorldSeries ~ Year, family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-1.0297  -0.6797  -0.5435  -0.4648   2.1504  

Coefficients:
  Estimate Std. Error z value Pr(>|z|)   
(Intercept) 72.23602   22.64409    3.19  0.00142 **
  Year        -0.03700    0.01138   -3.25  0.00115 **
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 228.35  on 242  degrees of freedom
AIC: 232.35

Number of Fisher Scoring iterations: 4
# creating a multi-variable logistic reg. model with the significant variables from bivariate models above
> mod = glm(WorldSeries ~ Year + RA + RankSeason + NumCompetitors, data=baseball, family = binomial)
> summary(mod)

Call:
  glm(formula = WorldSeries ~ Year + RA + RankSeason + NumCompetitors, 
      family = binomial, data = baseball)

Deviance Residuals: 
  Min       1Q   Median       3Q      Max  
-1.0336  -0.7689  -0.5139  -0.4583   2.2195  

Coefficients:
                  Estimate Std. Error z value Pr(>|z|)
(Intercept)    12.5874376 53.6474210   0.235    0.814
Year           -0.0061425  0.0274665  -0.224    0.823
RA             -0.0008238  0.0027391  -0.301    0.764
RankSeason     -0.0685046  0.1203459  -0.569    0.569
NumCompetitors -0.1794264  0.1815933  -0.988    0.323

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 239.12  on 243  degrees of freedom
Residual deviance: 226.37  on 239  degrees of freedom
AIC: 236.37

Number of Fisher Scoring iterations: 4
# ^Notice no ind.vars are significant in this multi-variable logistic reg. model this is due to high correlation between variables

# to check the correlation among these variables use cor(df[c("variable1","variable2","variable3" )])
> cor(baseball[c("Year","RA","RankSeason","NumCompetitors")])
                    Year        RA RankSeason NumCompetitors
Year           1.0000000 0.4762422  0.3852191      0.9139548
RA             0.4762422 1.0000000  0.3991413      0.5136769
RankSeason     0.3852191 0.3991413  1.0000000      0.4247393
NumCompetitors 0.9139548 0.5136769  0.4247393      1.0000000
> 

