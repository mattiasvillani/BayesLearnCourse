# BRugs code for analyzing a simple Bernoulli model with a Beta(a,b) prior
# Author: Mattias Villani, Linköping University

library(BRugs)
setwd('~/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')
nBurnin <- 1000
nIter <- 1000

# Data 
x = c(1,1,0,0,1,1,1,1,0,1)
n = length(x)
a = 1
b = 1
bugsData(c('n', 'a', 'b', 'x'),'BernData.txt') # Sets up a separate data file in bugs format

# Model
BernModel <- function(){
  for( i in 1:n) {
    x[i] ~ dbin(p,1)
  }
  p ~ dbeta(a,b)
}

# Initial values
inits <- list(list(p = 0.5),list(p = 0.1))

# Generating random MCMC draws from posterior
Results <- BRugsFit(modelFile = BernModel, data = "BernData.txt", inits = inits, numChains = 2, parametersToSave = c("p"), nBurnin, nIter, nThin = 1, coda = FALSE, DIC = TRUE)

# Plot some results
res <- samplesHistory(node = '*', plot = FALSE) # Plot the draws for all (hence the *) variables
pSeq <- seq(0,1,by=0.01)
par(mfrow = c(1,2))
hist(res[[1]][,1], 30, freq = FALSE, main = 'Posterior of p - first chain') # histogram of draws of a from the first Markov Chain
lines(pSeq, dbeta(pSeq, shape1 = sum(x) + a, shape2 = n - sum(x) + b), col = "red")
legend("topright", inset=.05, legend = c('MCMC approximation','True density'), lty =c(1,1),col=c('black','red'))
hist(res[[1]][,2], 30, freq = FALSE, main = 'Posterior of p - second chain') # histogram of draws of a from the first Markov Chain
lines(pSeq, dbeta(pSeq, shape1 = sum(x) + a, shape2 = n - sum(x) + b), col = "red")
legend("topright", inset=.05, legend = c('MCMC approximation','True density'), lty =c(1,1),col=c('black','red'))