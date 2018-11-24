

setwd('/home/mv/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')
nBurnin <- 1000
nIter <- 1000
modelFile <- 'BernBeta.txt'

# Data 
data <- list(x = c(1,1,0,0,1,1,1,1,0,1), n = length(x), a = 1, b = 1)

# Initial values
inits <- list(list(a = 1, b = 1),list(a = 1, b = 5))

Results <- BRugsFit(modelFile, data, inits, numChains = 2, parametersToSave = c("p"), nBurnin, nIter, nThin = 1, coda = FALSE, DIC = TRUE)

res <- samplesHistory(node = '*', plot = FALSE) # Plot the draws for all (hence the *) variables

par(mfrow = c(1,2))
hist(res[[1]][,1], 30, main = 'Posterior of p - first chain') # histogram of draws of a from the first Markov Chain
hist(res[[1]][,2], 30, main = 'Posterior of p - second chain') # histogram of draws of a from the first Markov Chain