# Run this file once during the exam to get all the required data and functions for the exam in working memory 
# Author: Mattias Villani

###############################
########## Problem 1 ########## 
############################### 

riceData <- c(1.556, 1.861, 3.135, 1.311, 1.877, 0.622, 3.219, 0.768, 2.358, 2.056)

# Random number generator for the Rice distribution
rRice <-function(n = 1, theta = 1, psi = 1){
  x <- rnorm(n = n, mean = 0, sd = sqrt(psi))
  y <- rnorm(n = n, mean = theta, sd = sqrt(psi))
  return(sqrt(x^2+y^2))
}



###############################
########## Problem 2 ########## 
############################### 

# eBay bids data
load(file = 'bids.RData')    # Loading the vector 'bids' into workspace
bidsCounts <- table(bids)  # data2Counts is a frequency table of counts.
xGrid <- seq(min(bids),max(bids))  # A grid used as input to GibbsMixPois.R over which the mixture density is evaluated.

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
    message(paste('Iteration number:',k))
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


###############################
########## Problem 3 ########## 
############################### 

# Reading the cars data from file
load("cars.RData")

install.packages("mvtnorm")
library(mvtnorm)

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


###############################
########## Problem 4 ########## 
############################### 
# NOTHING IS NEEDED FOR THIS EXERCISE

