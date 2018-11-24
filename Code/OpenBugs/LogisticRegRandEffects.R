# My own version of the example from http://mathstat.helsinki.fi/openbugs/ExamplesFrames.html
# Author: Mattias Villani, Statistics, Linkoping University, Sweden
#         mattias.villani@liu.se
# Date:   2012-12-05

library(BRugs)
setwd('~/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')
nBurnin <- 1000
nIter <- 1000

# Data
seedsData <- list( r = c(10, 23, 23, 26, 17, 5, 53, 55, 32, 46, 10, 8, 10, 8, 23, 0, 3, 22, 15, 32, 3),
                   n = c(39, 62, 81, 51, 39, 6, 74, 72, 51, 79, 13, 16, 30, 28, 45, 4, 12, 41, 30, 51, 7),
                   x1 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
                   x2 = c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1),
                   N = 21 )

# Model
LogisticRandEffectsModel <- function(){
  for (i in 1:N) {
    r[i] ~ dbin(p[i], n[i])
    b[i] ~ dnorm(0, tau)
    logit(p[i]) <- alpha0 + alpha1 * x1[i] + alpha2 * x2[i]
    + alpha12 * x1[i] * x2[i] + b[i]
  }
  alpha0 ~ dnorm(0, 1.0E-6)
  alpha1 ~ dnorm(0, 1.0E-6)
  alpha2 ~ dnorm(0, 1.0E-6)
  alpha12 ~ dnorm(0, 1.0E-6)
  tau ~ dgamma(0.001, 0.001)
  sigma <- 1 / sqrt(tau)
}

# Initial values
initVals <- list( list(alpha0 = 0, alpha1 = 0, alpha2 = 0, alpha12 = 0, tau = 10), 
                  list(alpha0 = 1, alpha1 = 2, alpha2 = 0, alpha12 = 0, tau = 10) )

# Run OpenBugs to sample from the posterior
BRugsFit(modelFile = LogisticRandEffectsModel, data = seedsData, inits = initVals, numChains = 2, 
         parametersToSave = c("alpha0", "alpha1", "alpha2", "alpha12", "tau", "sigma"),
         nBurnin, nIter, nThin = 1, coda = FALSE,
         DIC = TRUE, working.directory = NULL, digits = 5, seed=NULL,
         BRugsVerbose = getOption("BRugsVerbose"))

# Process the posterior draw. Summarize them, plot them etc
samplesHistory("*", mfrow = c(3, 2)) # Plots the MCMC trajectories (the draw plotted against the iteration number) for all parameters.
alpha0Post <- samplesSample("alpha0") # This is the vector of alpha0-draws from the posterior
hist(alpha0Post) # histogram of the draws to approximate the posterior of alpha0
samplesDensity("*") # Plots density estimates of the posterior draws for all the parameters.
plot(samplesSample("alpha1"),samplesSample("alpha2"),xlab="alpha1",ylab="alpha2", main = "Draws from joint posterior of alpha1 and alpha2")



