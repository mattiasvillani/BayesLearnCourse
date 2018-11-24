
# Author: Mattias Villani, Statistics, Linkoping University, Sweden
#         mattias.villani@liu.se
# Date:   2012-12-04

# Settings 
nBurnin <- 10
nIter <- 10

# Set working directory
setwd('~/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')

# Reading data from file and printing it to special bugs data file format
spamData <- read.table('~/Dropbox/Teaching/BayesLearn2012/Code/SpamReduced.dat', header = TRUE)
attach(spamData) # Puts all variables spamData in memory.
n <- length(spamData$spam)
bugsData(c('n', names(spamData)),"SpamBugs.txt") # Sets up a separate data file in bugs format

# This is the model in BUGS form. It can also be read from a separate text file.
logisticReg <- function(){
  for (i in 1:n) {
    spam[i] ~ dbin(p[i],1)
    logit(p[i]) <- alpha0 + alpha1 * free[i] + alpha2 * CapRunMax[i] + alpha3 * CapRunTotal[i] + alpha4 * edu[i]
  }
  alpha0 ~ dnorm(0, 1.0E-4)
  alpha1 ~ dnorm(0, 1.0E-4)
  alpha2 ~ dnorm(0, 1.0E-4)
  alpha3 ~ dnorm(0, 1.0E-4)
  alpha4 ~ dnorm(0, 1.0E-4)
}

# Input initial values for the MCMC. Can also be read from separate file.
initVals <- list( list(alpha0 = 0, alpha1 = 0, alpha2 = 0, alpha3 = 0, alpha4 = 0), 
                  list(alpha0 = 1, alpha1 = 1, alpha2 = 1, alpha3 = 1, alpha4 = 1) )

# Run OpenBugs to sample from the posterior
BRugsFit(modelFile = logisticReg, data = "SpamBugs.txt", inits = initVals, numChains = 2, 
         parametersToSave = c("alpha0", "alpha1", "alpha2", "alpha3", "alpha4"),
         nBurnin, nIter, nThin = 1, DIC = TRUE)

# Process the posterior draw. Summarize them, plot them etc
samplesHistory("*", mfrow = c(3, 2)) # Plots the MCMC trajectories (the draw plotted against the iteration number) for all parameters.
alpha0Post <- samplesSample("alpha0") # This is the vector of alpha0-draws from the posterior
hist(alpha0Post, 30) # histogram of the draws to approximate the posterior of alpha0
samplesDensity("*") # Plots density estimates of the posterior draws for all the parameters.
plot(samplesSample("alpha1"),samplesSample("alpha2"),xlab="alpha1",ylab="alpha2", main = "Draws from joint posterior of alpha1 and alpha2")



