# SOLUTION TO COMPUTER EXAM IN BAYESIAN LEARNING - 2017-08-16
# Mattias Villani, http://mattiasvillani.com

# First load all the data into memory by running the R-file given at the exam
ExamData

###############################
########## Problem 1 ########## 
############################### 

# 1 a)

# Reading the data vector yVect from file
load(file = 'CauchyData.RData')
  
logPostCauchyUnitScale <- function(theta, yVect){
  sum(log(dCauchy(yVect, theta, gamma = 1))) + dnorm(theta, mean = 0, sd = 10, log = TRUE)
} 

thetaGrid <- seq(0, 12, length = 1000)
logPostEvals <- rep(0, 1000)
i = 0
for (theta in thetaGrid){
  i = i + 1
  logPostEvals[i] <- logPostCauchyUnitScale(theta, yVect)
}
binWidth = thetaGrid[2]-thetaGrid[1] 
plot(thetaGrid, exp(logPostEvals)/(sum(exp(logPostEvals))*binWidth), type = "l", ylab = 'Posterior density', xlab = expression(theta))
# It is ok also to plot the unnormalized density.

# 1b)

logPostCauchy <- function(param, yVect){
  theta = param[1]
  gamma = param[2]
  logPost = sum(log(dCauchy(yVect, theta, gamma))) 
    + dnorm(theta, mean = 0, sd = 10, log = TRUE) 
    + log(dlognormal(gamma, mu = 0, sigma2 = 1))
  return(logPost)
}

initVal = c(1,1)
optRes <- optim(par = initVal, fn  = logPostCauchy, gr = NULL, yVect, method = c("L-BFGS-B"),
      lower = c(-Inf,0.0001), upper = c(Inf,Inf), control = list(fnscale = -1), hessian = TRUE)
postMean <- optRes$par # This is the mean vector
postCov <- -solve(optRes$hessian) # This is posterior covariance matrix

# The posterior is approximately c(theta,gamma) ~ N(postMean, postCov).

# 1c)
postSample = rmvnorm(n=10000, mean = postMean, sigma = postCov) # Simulating from the posterior
quant99 = postSample[,1] + postSample[,2]*tan(pi*(0.99-1/2))    # Computing the 99th percentile for each draw
hist(quant99,100, freq = FALSE, col = "yellow", main = "Posterior density for the 99th percentile")  
lines(density(quant99), col = "red", lwd = 2)
      
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


# 2b)

# What we need here is the predictive distibution for the price given the explanatory variables for house 381,
# but where the crim is changed to 10. We can obtain the predictive distribution by simulation.
xPred = X[381,]
xPred[2] <- 10

nSim <- dim(BostonRes$betaSample)[1] # One predictive draw for each posterior parameter draw
yPred <- matrix(0,nSim,1)
for (i in 1:nSim){
  yPred[i] <- xPred%*%BostonRes$betaSample[i,] + rnorm(n = 1, mean = 0, sd = sqrt(BostonRes$sigma2Sample[i]))
}
hist(yPred,50)
mean(yPred)         # The predictive mean is roughly 22.85, so the agent's assessment of expected selling price 
                    # is not spot on, but seems reasonable. Maybe he has a different model?
sum(yPred>=30)/nSim # Probability of $30000 is not very large, but still sizeable (around 0.065).

###############################
########## Problem 3 ########## 
############################### 

# Nothing here to see, the solution does not involve any coding.

###############################
########## Problem 4 ########## 
############################### 

# 4(a)
nSim = 1000
alphaPrior = 25
betaPrior  = 0.1
n = 4
sumX = sum(c(220,323,174,229))
thetaSample = rgamma(n = nSim, shape = alphaPrior + sumX, rate = betaPrior + n)
hist(thetaSample,50)

# 4(b)
x5Sample = rep(0,nSim)
for (i in 1:nSim){
  x5Sample[i] <- rpois(1,thetaSample[i]) # ii) Draw from the Poisson distribution with theta from 4(a)
}
hist(x5Sample,50)
sum(x5Sample<=200)/nSim

# 4(c)
expectedX5 = round(mean(x5Sample))
aGrid <- seq(expectedX5-100,expectedX5+100)
util = rep(0,length(aGrid))
count = 0
for (a in aGrid){
  count = count + 1
  util[count] = mean(utility(a,x5Sample)) # This computes a Monte Carlo (simulation) estimate of posterior expected utility for the current a
}
aOpt = aGrid[which.max(util)] # Finds the a which maximizes expected utility
message('The optimal stock to hold for next quarter is a = ',aOpt)

# The reason why the optimal a is larger than the predictive expectation of X5 (expectedX5) is that the utility
# decreases sharply when the stock is lower than the demand (it decreases quadratically when X5>a) 
# The utlity function encapsulates the idea is that costumers gets upset when they don't get their order.
# It is therefore optimal to choose a stock larger than the expected demand, to be on the safe side.
# See also the solution for the lin-lin loss in Lecture 5 for a similar effect.

# As a bonus, I plot the whole curve of expected utilities as a function of a, and marks out the maximum.
plot(aGrid,util, type = "l")
points(aOpt,util[which.max(util)],'o', col='red') 

