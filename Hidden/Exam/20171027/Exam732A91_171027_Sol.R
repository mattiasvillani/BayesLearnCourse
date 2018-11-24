# SOLUTION TO COMPUTER EXAM IN BAYESIAN LEARNING - 2017-10-27
# Mattias Villani, http://mattiasvillani.com

# First load all the data into memory by running the R-file given at the exam
ExamData

###############################
########## Problem 1 ########## 
############################### 

# 1 a)

# Reading the data vector yProp from file
load(file = 'yProportions.RData')
  
logPostSymmetricBeta <- function(theta, yProp){
  sum(log(dbeta(yProp, shape1 = theta, shape2 = theta))) + dexp(theta, rate = 1, log = TRUE)
} 

thetaGrid = seq(0.01, 15, length = 1000)
logPostEvals <- rep(0, 1000)
i = 0
for (theta in thetaGrid){
  i = i + 1
  logPostEvals[i] <- logPostSymmetricBeta(theta, yProp)
}
binWidth = thetaGrid[2]-thetaGrid[1] 
plot(thetaGrid, exp(logPostEvals)/(sum(exp(logPostEvals))*binWidth), type = "l", ylab = 'Posterior density', xlab = expression(theta))
# It is ok also to plot the unnormalized density.
postMode = thetaGrid[which.max(logPostEvals)]

# 1b)

logPostBeta <- function(param, yProp){
  theta1 = param[1]
  theta2 = param[2]
  logPost =   sum(log(dbeta(yProp, shape1 = theta1, shape2 = theta2))) + 
    dexp(theta1, rate = 1, log = TRUE) + 
    dexp(theta2, rate = 1, log = TRUE)
  return(logPost)
}

initVal = c(1,1) # Start with uniform distribution, or whatever
optRes <- optim(par = initVal, fn  = logPostBeta, gr = NULL, yProp, method = c("L-BFGS-B"),
      lower = c(0.0001,0.0001), upper = c(Inf,Inf), control = list(fnscale = -1), hessian = TRUE)
postMean <- optRes$par # This is the mean vector
postCov <- -solve(optRes$hessian) # This is posterior covariance matrix

# The posterior is approximately c(theta1,theta2) ~ N(postMean, postCov).

# 1c)
# - Bayesian model comparison, Bayes factor (marginal likelihood) or posterior model probabilities for comparing the model in 1a to 1b. 
# - Log predictive score is another possibility, but data is limited here so we don't want to waste much of it for training the prior.
      
###############################
########## Problem 2 ########## 
############################### 

# 2a)

# Prior
nCovs = dim(X)[2]
mu_0 = rep(0,nCovs)
Omega_0 = (1/100)*diag(nCovs)
v_0 = 1
sigma2_0 = 6^2  

BostonRes <-  BayesLinReg(y, X, mu_0, Omega_0, v_0, sigma2_0, nIter = 10000)

# The marginal posterior of beta is student t. This distribution is unimodal and 
# symmetric so HPD is the same a equal-tail interval:
quantile(BostonRes$betaSample[,14],c(0.02,0.975))

# 2b)

# A 30% reduction of lstat for house no. 9 means that lstat is 29.93*0.7=20.951 after the policy

par(mfrow=c(1,2))
# First, lets predict before the change
xPred = X[9,]

nSim <- dim(BostonRes$betaSample)[1] # One predictive draw for each posterior parameter draw
yPredBefore <- matrix(0,nSim,1)
for (i in 1:nSim){
  yPredBefore[i] <- xPred%*%BostonRes$betaSample[i,] + rnorm(n = 1, mean = 0, sd = sqrt(BostonRes$sigma2Sample[i]))
}
hist(yPredBefore,50)

# First, lets predict after the change
xPred[14] = xPred[14]*0.7 # 30 reduction

yPredAfter <- matrix(0,nSim,1)
for (i in 1:nSim){
  yPredAfter[i] <- xPred%*%BostonRes$betaSample[i,] + rnorm(n = 1, mean = 0, sd = sqrt(BostonRes$sigma2Sample[i]))
}
hist(yPredAfter,50)

# To see if the price will increase we should look at the posterior of the beta on lstat
diffPrice = BostonRes$betaSample[,14]*(29.93*0.7-29.93)
hist(diffPrice,50)

# 95% HPD for the price difference
quantile(diffPrice,c(0.02,0.975))

# which does no contain zero, and the expected price increase is 
mean(diffPrice)

# 2c) See paper solution

###############################
########## Problem 3 ########## 
############################### 

# Nothing here to see, the solution does not involve any coding.

###############################
########## Problem 4 ########## 
############################### 

# 4(a)
nSim = 1000
y = c(195, 191, 196, 197, 189)
n = length(y)
sigma2 = 10^2

maxWeightGivenDay = rnorm(nSim, mean = mean(y), sd = sqrt(sigma2/n+sigma2))
hist(maxWeightGivenDay,50)

# 4(b)
maxWeightYear = rep(NA,nSim,1)
for (i in 1:nSim){
  maxWeightYear[i] = max(rnorm(365, mean = mean(y), sd = sqrt(sigma2/n+sigma2)))
}
hist(maxWeightYear,50)
sum(maxWeightYear>230)/nSim

# 4(c)
ExpectedLoss<-function(a, maxWeightYear){
  ProbCollapse = sum(maxWeightYear>10*a)/nSim
  EL = (1-ProbCollapse)*(a) + ProbCollapse*(100+a)
  return(EL)
}

aGrid = seq(20,30,by = 0.01)
EL = rep(NA,length(aGrid),1)
count = 0
for (a in aGrid){
  count = count + 1
  EL[count] = ExpectedLoss(a, maxWeightYear)
}
plot(aGrid, EL, type = "l")
aOpt = aGrid[which.min(EL)] # This is the optimal a
points(x= aOpt, y = ExpectedLoss(a=aOpt, maxWeightYear), col = "red")

