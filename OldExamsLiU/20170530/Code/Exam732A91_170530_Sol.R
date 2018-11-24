# SOLUTION TO COMPUTER EXAM IN BAYESIAN LEARNING - 2017-05-30

# First load all the data into memory by running the R-file given at the exam
ExamData

###############################
########## Problem 1 ########## 
############################### 

# 1 a)

# Random number generator for the Rice distribution
rRice <-function(n = 1, theta = 1, psi = 1){
  x <- rnorm(n = n, mean = 0, sd = sqrt(psi))
  y <- rnorm(n = n, mean = theta, sd = sqrt(psi))
  return(sqrt(x^2+y^2))
}

# Log density function for the Rice distribution
logdrice <- function(x, theta = 1, psi = 1){
  logdens <- log(x/psi) - (x^2+theta^2)/(2*psi) + log(besselI(x*theta/psi, 0)) 
  return(logdens)
}

# Define the rice posterior (likelihood x prior)
logRicePost <- function(theta = 1, data){
  sum(logdrice(x=data, theta, psi = 1)) + 0 # The prior is assumed to be constant so can add one on the log scale.
}

# Reading data
riceData <- c(1.556, 1.861, 3.135, 1.311, 1.877, 0.622, 3.219, 0.768, 2.358, 2.056)

# Plot the posterior over a grid of theta values
gridWidth <- 0.01
thetaGrid <- seq(0.01, 3, by = gridWidth)
logRicePostGrid <- rep(0,length(thetaGrid))
count <- 0
for (theta in thetaGrid){
  count <- count + 1
  logRicePostGrid[count] <-logRicePost(theta, data = riceData)
}

# Taking exp() and normalizing so the density integrates to one. Note the (1/gridWidth) factor.
RicePostGrid <- (1/gridWidth)*exp(logRicePostGrid)/sum(exp(logRicePostGrid))
plot(thetaGrid, RicePostGrid, type = "l", lwd = 2, ylim = c(0,1.1), main="Posterior for the Rice model", 
     ylab = "Density", xlab = expression(theta))


# 1b) Normal approximation of posterior
initVal <- mean(riceData)
optRes = optim(initVal, logRicePost, gr=NULL, riceData, method=c("L-BFGS-B"), 
               lower = 0, control=list(fnscale=-1), hessian=TRUE)
postMode <- optRes$par   # Posterior mode
postStdev <- sqrt(-1/optRes$hessian) # Approximate posterior standard deviation
lines(thetaGrid, dnorm(thetaGrid, mean = postMode, sd = postStdev), col="red", lwd = 2)
legend(x = 1.8, y = 1, legend = c("True posterior", "Approximate posterior"), 
       col = c("black","red"), lty = c(1,1), lwd = c(2,2), cex = 0.8)

# The approximation is not perfect, but fairly so, and probably good enough for all practical purposes 

# 1c) Simulation from predictive distribution

# Simulate from normal approximation of the posterior of theta
nDraws <- 10000 # Number of simulations 
thetaDraws <- rnorm(n = nDraws, mean = postMode, sd = postStdev)

# For each theta simulate a data point from the Rice distribution with that theta as parameter
ytilde <- rep(0,nDraws)
for (i in 1:nDraws){
  ytilde[i] <- rRice(n = 1, theta = thetaDraws[i], psi = 1)
}
hist(ytilde, 50, freq = FALSE, main = "Predictive distribution x_{n+1}", xlab = "x_{n+1}")

###############################
########## Problem 2 ########## 
############################### 

# 2a

# Reading data
load(file = 'bids.RData')    # Loading the vector 'bids' into workspace
bidsCounts <- table(bids)  # data2Counts is a frequency table of counts.

# The posterior is Gamma(alphaGamma + sum(bids), betaGamma + n)
alphaGamma = 1 # Prior is theta | data  ~ Gamma(alphaGamma, betaGamma)
betaGamma = 1
n = length(bids)
thetaGrid <- seq(3.3,4,length = 1000)
gammaPost = dgamma(thetaGrid, shape = alphaGamma + sum(bids), rate = betaGamma + n)
plot(thetaGrid, gammaPost, type = "l", lwd = 2, main = "Posterior for mean in Poisson model for bids", 
     xlab = expression(theta), ylab = 'Density')

# 2b
xGrid = seq(min(bids),max(bids))  # A grid used as input to GibbsMixPois.R over which the mixture density is evaluated.
dataDistr = bidsCounts/sum(bidsCounts)

# There are two ways of doing this (of which the second one is more correct, but both are ok here):

# i) First approach - compute the Poisson distribution over xGrid the posterior mean of theta.
poisDistr = dpois(xGrid, lambda = mean(bids))
plot(xGrid, dataDistr, type = "o", lwd = 3, col = "black", pch = 'o', cex = 0.6, 
     ylim = c(0,0.22), main = "Fitted models")
lines(xGrid, poisDistr, type = "o", lwd = 3, col = "red", pch = 'o', cex = 0.6)
legend(x = 6, y = 0.2, legend = c("Data", "Poisson "), 
       col = c("black","red"), lty = c(1,1), lwd = c(3,3), cex = 0.8)

# ii) Second approach - compute the Poisson distribution over xGrid for each theta draw and then 
# average all the resulting distributions.
nDraws = 1000
thetaDraws = rgamma(n = nDraws, shape = alphaGamma + sum(bids), rate = betaGamma + n)
PoisDensMean <- rep(0, length(xGrid))
for (i in 1:nDraws){
  PoisDensMean = PoisDensMean + dpois(xGrid, lambda = thetaDraws[i])
}
PoisDensMean = PoisDensMean/nDraws # Average
lines(xGrid, PoisDensMean, type = "o", lwd = 1, col = "blue", pch = 'o', cex = 0.6)
legend(x = 6 , y = 0.2, legend = c("Data","Poisson (mean theta)",
                                   "Poisson (mean density)"), col = c("black","red","blue"), 
                                   lty = c(1,1,1), lwd = c(3,3,1), cex = 0.8)

# As you can see in the Figure, i) and ii) gives very very similar distributions for the data.
# You can also see that the Poisson model is terrible for this data sets. Very poor fit.




# 2c

# Here is the code that was supplied in the ExamData.R file:

# Code for Problem 3 - Exam in Bayesian Learning 2017-05-30
GibbsMixPois <- function(x, nComp, alpha, alphaGamma, betaGamma, xGrid, nIter){
  
  # Gibbs sampling for a mixture of Poissons
  # Author: Mattias Villani, IDA, Linkoping University. http://mattiasvillani.com
  #
  # INPUTS:
  #   x - vector with data observations (counts)
  #   nComp - Number of mixture components to be fitted
  #   alpha - The prior on the mixture component weights is w ~ Dir(alpha, alpha,..., alpha) 
  #   alphaGamma and betaGamma - 
  #              The prior on the mean (theta) of the Poisson mixture components is 
  #              theta ~ Gamma(alphaGamma, betaGamma) [rate parametrization of the Gamma dist]
  #   xGrid - the grid of data values over which the mixture is evaluated and plotted
  #   nIter - Number of Gibbs iterations
  #
  # OUTPUTS:
  #   results$wSample     - Gibbs sample of mixture component weights. nIter-by-nComp matrix
  #   results$thetaSample - Gibbs sample of mixture component means.   nIter-by-nComp matrix
  #   results$mixDensMean - Posterior mean of the estimated mixture density over xGrid.
  
  
  ####### Defining a function that simulates from a Dirichlet distribution
  rDirichlet <- function(param){
    nCat <- length(param)
    thetaDraws <- matrix(NA,nCat,1)
    for (j in 1:nCat){
      thetaDraws[j] <- rgamma(1,param[j],1)
    }
    thetaDraws = thetaDraws/sum(thetaDraws) # Diving every column of ThetaDraws by the sum of the elements in that column.
    return(thetaDraws)
  }
  
  # Simple function that converts between two different representations of the mixture allocation
  S2alloc <- function(S){
    n <- dim(S)[1]
    alloc <- rep(0,n)
    for (i in 1:n){
      alloc[i] <- which(S[i,] == 1)
    }
    return(alloc)
  }
  
  # Initial values for the Gibbs sampling
  nObs <- length(x)
  S <- t(rmultinom(nObs, size = 1 , prob = rep(1/nComp,nComp))) # nObs-by-nComp matrix with component allocations.
  theta <- rep(mean(x), nComp) # Each component is initialized at the mean of the data
  
  # Setting up the grid where the mixture density is evaluated.
  mixDensMean <- rep(0,length(xGrid))
  effIterCount <- 0
  
  # Setting up matrices to store the draws
  wSample <- matrix(0, nIter, nComp)
  thetaSample <- matrix(0, nIter, nComp)
  probObsInComp <- rep(NA, nComp)
  
  # Setting up the priors - the same prior for all components
  alpha <- rep(alpha, nComp) 
  alphaGamma <- rep(alphaGamma, nComp) 
  betaGamma <- rep(betaGamma, nComp) 
  
  # HERE STARTS THE ACTUAL GIBBS SAMPLING
  
  for (k in 1:nIter){
    # message(paste('Iteration number:',k)) # uncomment this is you want print the iterations
    alloc <- S2alloc(S) # Function that converts between different representations of the group allocations
    nAlloc <- colSums(S)
    
    # Step 1 - Update components probabilities
    w <- rDirichlet(alpha + nAlloc)
    wSample[k,] <- w
    
    # Step 2 - Update theta's in Poisson components
    for (j in 1:nComp){
      theta[j] <- rgamma(1, shape = alphaGamma + sum(x[alloc == j]), rate = betaGamma + nAlloc[j])
    }
    thetaSample[k,] <- theta
    
    # Step 3 - Update allocation
    for (i in 1:nObs){
      for (j in 1:nComp){
        probObsInComp[j] <- w[j]*dpois(x[i], lambda = theta[j])
      }
      S[i,] <- t(rmultinom(1, size = 1 , prob = probObsInComp/sum(probObsInComp)))
    }
    
    # Computing the mixture density at the current parameters, and averaging that over draws.
    effIterCount <- effIterCount + 1
    mixDens <- rep(0,length(xGrid))
    for (j in 1:nComp){
      compDens <- dpois(xGrid, lambda = theta[j])
      mixDens <- mixDens + w[j]*compDens
    }
    mixDensMean <- ((effIterCount-1)*mixDensMean + mixDens)/effIterCount
  }
  return(results = list(wSample = wSample, thetaSample = thetaSample, mixDensMean = mixDensMean))
}


# We now use this code to simulate from GibbsMixPois.R with K=2
GibbsResults2 <- GibbsMixPois(x = bids, nComp = 2, alpha = 1, alphaGamma = 1, betaGamma = 1, 
                              xGrid = xGrid, nIter = 500)

# And for K=3:
GibbsResults3 <- GibbsMixPois(x = bids, nComp = 3, alpha = 1, alphaGamma = 1, betaGamma = 1, 
                              xGrid = xGrid, nIter = 500)
# 2d
# Plotting the data distribution against the Poisson and the fitted mixture of Poissons

mixDistr2 <- GibbsResults2$mixDensMean
mixDistr3 <- GibbsResults3$mixDensMean

lines(xGrid, mixDistr2, type = "o", lwd = 3, col = "purple", pch = 'o', cex = 0.6)
lines(xGrid, mixDistr3, type = "o", lwd = 3, col = "green", pch = 'o', cex = 0.6)

legend(x = 6 , y = 0.2, legend = c("Data","Poisson (mean theta)",
                                  "Poisson (mean density)", "Mixture K=2", "Mixture K=3"), 
                                col = c("black","red","blue","purple","green"), 
                                lty = 1 , lwd = c(3,3,1,3,3), cex = .8)
       

# The two mixture distributions gives very similar fits, and much closer to the data distribution.
# Since K=2 gives similar fit to K=3, I would choose the K=2 model since it is simpler.

# 2e) See paper solution

###############################
########## Problem 3 ########## 
############################### 

# Installing and loading a package with the multivariate normal distribution
#install.packages("mvtnorm")
library(mvtnorm)

# Loading functions supplied in the ExamData.R file
# Defining a function that simulates from the scaled inverse Chi-square distribution
rScaledInvChi2 <- function(n, df, scale){
  return((df*scale)/rchisq(n,df=df))
}

BayesLinReg <- function(y, X, mu_0, Omega_0, v_0, sigma2_0, nIter){
  # Direct sampling from a Gaussian linear regression with conjugate prior:
  #
  # beta | sigma2 ~ N(mu_0, sigma2*inv(Omega_0))
  # sigma2 ~ Inv-Chi2(v_0,sigma2_0)
  # 
  # Author: Mattias Villani, IDA, Linkoping University. http://mattiasvillani.com
  #
  # INPUTS:
  #   y - n-by-1 vector with response data observations
  #   X - n-by-nCovs matrix with covariates, first column should be ones if you want an intercept.
  #   mu_0 - prior mean for beta
  #   Omega_0  - prior precision matrix for beta
  #   v_0      - degrees of freedom in the prior for sigma2
  #   sigma2_0 - location ("best guess") in the prior for sigma2
  #   nIter - Number of samples from the posterior (iterations)
  #
  # OUTPUTS:
  #   results$betaSample     - Posterior sample of beta.     nIter-by-nCovs matrix
  #   results$sigma2Sample   - Posterior sample of sigma2.   nIter-by-1 vector
  
  # Compute posterior hyperparameters
  n = length(y) # Number of observations
  nCovs = dim(X)[2] # Number of covariates
  XX = t(X)%*%X
  betaHat <- solve(XX,t(X)%*%y)
  Omega_n = XX + Omega_0
  mu_n = solve(Omega_n,XX%*%betaHat+Omega_0%*%mu_0)
  v_n = v_0 + n
  sigma2_n = as.numeric((v_0*sigma2_0 + ( t(y)%*%y + t(mu_0)%*%Omega_0%*%mu_0 - t(mu_n)%*%Omega_n%*%mu_n))/v_n)
  invOmega_n = solve(Omega_n)
  
  # The actual sampling
  sigma2Sample = rep(NA, nIter)
  betaSample = matrix(NA, nIter, nCovs)
  for (i in 1:nIter){
    
    # Simulate from p(sigma2 | y, X)
    sigma2 = rScaledInvChi2(n=1, df = v_n, scale = sigma2_n)
    sigma2Sample[i] = sigma2
    
    # Simulate from p(beta | sigma2, y, X)
    beta_ = rmvnorm(n=1, mean = mu_n, sigma = sigma2*invOmega_n)
    betaSample[i,] = beta_
    
  }
  return(results = list(sigma2Sample = sigma2Sample, betaSample=betaSample))
}


# Reading data
load("cars.RData")
y = cars$mpg 
X = as.matrix(cars[,2:5])
nCovs = dim(X)[2]

# Prior
mu_0 = rep(0,nCovs)
Omega_0 = 0.01*diag(nCovs)
v_0 = 1
sigma2_0 = 36

# 3a i)
nIter = 1000
Results = BayesLinReg(y, X, mu_0, Omega_0, v_0, sigma2_0, nIter)
hist(Results$sigma2Sample, 50, freq=FALSE, main = 'Posterior of sigma2', xlab = expression(sigma^2), )
hist(Results$betaSample[,1],50, freq=FALSE, main = 'Posterior of beta0', xlab = expression(beta_0), )
hist(Results$betaSample[,2], 50, freq=FALSE, main = 'Posterior of beta_1', xlab = expression(beta_1), )
hist(Results$betaSample[,3], 50, freq=FALSE, main = 'Posterior of beta_2', xlab = expression(beta_2), )
hist(Results$betaSample[,4], 50, freq=FALSE, main = 'Posterior of beta_3', xlab = expression(beta_3), )

# 3a ii)
# The posterior median is the optimal estimator under linear loss function (see Slides Lecture 4)
median(Results$betaSample[,1])
median(Results$betaSample[,2])
median(Results$betaSample[,3])
median(Results$betaSample[,4])

# 3a iii)
quantile(Results$sigma2Sample, c(0.025, 0.975))
quantile(Results$betaSample[,1], c(0.025, 0.975))
quantile(Results$betaSample[,2], c(0.025, 0.975))
quantile(Results$betaSample[,3], c(0.025, 0.975))
quantile(Results$betaSample[,4], c(0.025, 0.975))

# Interpretation of probability interval beta_1 in [-4.764942 -1.593364]
# A one unit increase in weight lowers the miles per gallon by between -4.764942 and -1.593364 miles
# with 95% (0.95) posterior probability.

# 3b) 
# Here we want to know the posterior distribution of beta_3 == beta_4 or not. 
# A natural way to investigate  this is compute the posterior distribution of 
# theta = beta_3-beta_4 and to see if a 95% probability interval for theta 
# covers the value theta=0.

# 3b
hist(Results$betaSample[,4]-Results$betaSample[,3],50)
quantile(Results$betaSample[,4]-Results$betaSample[,3],c(0.25,0.975))

# The distribution of theta gives quite high density around theta=0.
# The 95% interval covers theta=0
# We can not rule out the the effect from 6 and 8 cylinders are the same.

# 3c
ytilde <- rep(0,nIter)
xtilde <- c(1,3.5,0,0)
for (i in 1:nIter){
  ytilde[i] = sum(xtilde*Results$betaSample[i,]) + rnorm(n=1, mean = 0, sd = sqrt(Results$sigma2Sample[i]))
}
hist(ytilde,40, main ="Predictive distribution of y", freq = FALSE)

###############################
########## Problem 4 ########## 
############################### 
# 4 a) See paper.
# 4 b) See paper.
# 4 c) See also paper.
# The data W,L,L,W,W,L,L,L,W,W are the same as the following geometric data points:
x = c(0,2,0,3,0)  
# First observation is zero since it took no loss before the first win, 
# Second data point is 2 since there are two lossed before the second win and so on
n = length(x)
alpha_ = 1
beta_ = 1
sumX = sum(x)

# We need to decide an upper bound for k (we can't compute expected values by summing over an infinite set of number)
# Let's start by truncating at k = 10
kMax = 10
post = rep(NA,kMax+1)
utility = rep(NA,kMax+1)
for (k in 0:kMax){
  post[k+1] <- gamma(k + sumX + beta_)/gamma(k + sumX + n + alpha_ + beta_ +1)
  utility[k+1] <- (2^k-1)-2
}
post <- post/sum(post)
barplot(post, names.arg = 0:kMax, main = "Predictive distribution", xlab = "x_(n+1)", ylab = "Probability")
sum(utility*post) # = 7.416 which is larger than for the NoPlay action where the utility is 0. Play!

# Truncating at k = 20
kMax = 20
post = rep(NA,kMax+1)
utility = rep(NA,kMax+1)
for (k in 0:kMax){
  post[k+1] <- gamma(k + sumX + beta_)/gamma(k + sumX + n + alpha_ + beta_ +1)
  utility[k+1] <- (2^k-1)-2
}
post <- post/sum(post)
barplot(post, names.arg = 0:kMax, main = "Predictive distribution", xlab = "x_(n+1)", ylab = "Probability")
sum(utility*post) # = 75.61357 which is larger than for the NoPlay action where the utility is 0. Play!

# The choice of kMax clearly matters! In fact, the larger we make kMax the larger becomes the 
# Expected Utility of the Play action. It turns out that the expected utility is infinite!
# See my Paper solutions for more explanation.