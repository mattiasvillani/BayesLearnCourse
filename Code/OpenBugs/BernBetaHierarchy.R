# BRugs code for analyzing a Bernoulli model with a Beta(a,b) prior
# where a and b are unknown and estimated.
# Author: Mattias Villani, Linköping University

library(BRugs)
setwd('~/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')
nBurnin <- 1000
nIter <- 1000

# Data 
data <- list(x = c(1,1,0,0,1,1,1,1,0,1), n = length(x))

# Model
BernModelHierarchy <- function(){
  for( i in 1:n) {
    x[i] ~ dbin(p,1)
  }
  p ~ dbeta(a,b)
  a ~ dunif(0,10)
  b ~ dunif(0,10)
}

# Initial values
inits <- list(list(a = 1, b = 1),list(a = 1, b = 5))

Results <- BRugsFit(modelFile = BernModelHierarchy, data, inits, numChains = 2, 
                    parametersToSave = c("a","b"), nBurnin, nIter, nThin = 1, coda = FALSE, 
                    DIC = TRUE)

res <- samplesHistory(node = '*', plot = FALSE) # Plot the draws for all (hence the *) variables

par(mfrow = c(2,2))
hist(res[[1]][,1], 30, main = 'Posterior of a - first chain') # histogram of draws of a from the first Markov Chain
hist(res[[2]][,1], 30, main = 'Posterior of b - first chain') # histogram of draws of b from the first Markov Chain
hist(res[[1]][,2], 30, main = 'Posterior of a - second chain') # histogram of draws of a from the first Markov Chain
hist(res[[2]][,2], 30, main = 'Posterior of b - second chain') # histogram of draws of b from the first Markov Chain