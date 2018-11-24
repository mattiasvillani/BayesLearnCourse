# Code for Problem 3 - Exam in Bayesian Learning 2017-05-30

# Gibbs sampling for a mixture of normals
# Author: Mattias Villani, IDA, Linkoping University. http://mattiasvillani.com

###########################    BEGIN USER INPUT   ###########################    
# Data options
#load(file = 'bids.RData') # Loading the vector 'bids' into workspace
#x <- bids                 # This is the data vector that we will use.
x <- c(rpois(n = 60, lambda = 1),rpois(n = 140, lambda = 5))

# Model options
nComp <- 4    # Number of mixture components

# Prior options
alpha <- 1*rep(1,nComp) # Dirichlet(alpha) for the weights of the mixture components (the Pi's)
muPrior <- rep(0,nComp) # Prior mean of theta
tau2Prior <- rep(10,nComp) # Prior std theta
sigma2_0 <- rep(var(x),nComp) # s20 (best guess of sigma2)
nu0 <- rep(4,nComp) # degrees of freedom for prior on sigma2

# MCMC options
nIter <- 500 # Number of Gibbs sampling draws

###########################    END USER INPUT     ###########################    



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

# Defining a function that simulates from the scaled inverse Chi-square distribution
rScaledInvChi2 <- function(n, df, scale){
  return((df*scale)/rchisq(n,df=df))
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
theta <- quantile(x, probs = seq(0,1,length = nComp))
sigma2 <- rep(var(x),nComp)
probObsInComp <- rep(NA, nComp)

# Setting up the grid where the mixture density is evaluated.
xGrid <- seq(min(x)-1*sd(x),max(x)+1*sd(x),length = 100)
xGridMin <- min(xGrid)
xGridMax <- max(xGrid)
mixDensMean <- rep(0,length(xGrid))
effIterCount <- 0

# HERE STARTS THE ACTUAL GIBBS SAMPLING
for (k in 1:nIter){
  #message(paste('Iteration number:',k))
  alloc <- S2alloc(S) # Function that converts between different representations of the group allocations
  nAlloc <- colSums(S)
  
  # Step 1 - Update components probabilities
  w <- rDirichlet(alpha + nAlloc)
  
  # Step 2a - Update theta's
  for (j in 1:nComp){
    precPrior <- 1/tau2Prior[j]
    precData <- nAlloc[j]/sigma2[j]
    precPost <- precPrior + precData
    wPrior <- precPrior/precPost
    muPost <- wPrior*muPrior + (1-wPrior)*mean(x[alloc == j])
    tau2Post <- 1/precPost
    theta[j] <- rnorm(1, mean = muPost, sd = sqrt(tau2Post))
  }
  
  # Step 2b - Update sigma2's
  for (j in 1:nComp){
    sigma2[j] <- rScaledInvChi2(1, df = nu0[j] + nAlloc[j], scale = (nu0[j]*sigma2_0[j] + sum((x[alloc == j] - theta[j])^2))/(nu0[j] + nAlloc[j]))
  }
  
  # Step 3 - Update allocation
  for (i in 1:nObs){
    for (j in 1:nComp){
      probObsInComp[j] <- w[j]*dnorm(x[i], mean = theta[j], sd = sqrt(sigma2[j]))
    }
    S[i,] <- t(rmultinom(1, size = 1 , prob = probObsInComp/sum(probObsInComp)))
  }
  
  # Computing the mixture density at the current parameters, and averaging that over draws.
  effIterCount <- effIterCount + 1
  mixDens <- rep(0,length(xGrid))
  for (j in 1:nComp){
    compDens <- dnorm(xGrid, theta[j], sd = sqrt(sigma2[j]))
    mixDens <- mixDens + w[j]*compDens
  }
  mixDensMean <- ((effIterCount-1)*mixDensMean + mixDens)/effIterCount
  
}

# Plotting the fitted mixture density
hist(x, breaks = 20, freq = FALSE, xlim = c(xGridMin,xGridMax), main = "Final fitted density")
lines(xGrid, mixDensMean, type = "l", lwd = 2, lty = 4, col = "red")
lines(xGrid, dnorm(xGrid, mean = mean(x), sd = sd(x)), type = "l", lwd = 2, col = "blue")
legend("topright", box.lty = 1, legend = c("Data histogram","Mixture density","Normal density"), 
       col=c("black","red","blue"), lwd = 2)
