# BRugs code for analyzing a simple linear regression model
# Author: Mattias Villani, Linköping University

library(BRugs)
setwd('~/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')
nBurnin <- 1000
nIter <- 1000

# Data
heightweight <- read.table("HeightWeight.dat", header = TRUE)
attach(heightweight) # Puts all variables spamData in memory.
n <- length(weight)
bugsData(c('n', 'height', 'weight'),'HeightWeight.txt') # Sets up a separate data file in bugs format

# Model
linReg <- function(){
  for (i in 1:n) {
    weight[i] ~ dnorm(theta[i],psi)
    theta[i] <- beta0 + beta1 * height[i]
  }
  psi <- 1/sigma2
  sigma2 ~ dunif(0, 10000)
  beta0 ~ dnorm(0, 1.0E-6)
  beta1 ~ dnorm(0, 1.0E-6)
}

# Initial values for MCMC
initVals <- list( list(beta0 = 0, beta1 = 0, sigma2 = 1), 
                  list(beta0 = 1, beta1 = -1, sigma2 = 1) )

# Run OpenBugs to sample from the posterior
BRugsFit(modelFile = linReg, data = "HeightWeight.txt", inits = initVals, numChains = 2, 
         parametersToSave = c("beta0", "beta1", "sigma2"), nBurnin, nIter)

# Process the posterior draw. Summarize them, plot them etc
samplesHistory("*", mfrow = c(3, 1)) # Plots the MCMC trajectories (the draw plotted against the iteration number) for all parameters.
beta1Post <- samplesSample("beta1") # This is the vector of beta1-draws from the posterior
hist(beta1Post,30) # histogram of the draws to approximate the posterior of alpha0
samplesDensity("*") # Plots density estimates of the posterior draws for all the parameters.
plot(samplesSample("beta1"),samplesSample("sigma2"),xlab="beta1",ylab="sigma2", main = "Draws from joint posterior of beta1 and sigma2")
