

setwd('/home/mv/Dropbox/Teaching/BayesLearn2012/Code/OpenBugs/')
nBurnin <- 1000
nIter <- 1000

# Data 
data <- list(x = c(1,1,0,0,1,1,1,1,0,1), n = length(x), a = 1, b = 1)

# This is the model in BUGS form. It can be written as a separate text file


# Input data. Can also be read from separate file.
normalData <- list( x = c(10, 23, 23, 26, 17, 5, 53, 55, 32, 46, 10, 8, 10, 8, 23, 0, 3, 22, 15, 32, 3) , n = length(x))
bugsData(c('n', names(normalData)),"normalData.txt") # Sets up a separate data file in bugs format

# Initial values
inits <- list(list(mu0 = 0, sigma = 1, tau0 = 1),list(mu0 = 1, sigma = 5, tau0 = 2))

Results <- BRugsFit(modelFile = 'NormalHierarchy.txt', data = "normalData.txt", inits, numChains = 2, parametersToSave = c("mu0","sigma","tau0"), 
                    nBurnin, nIter, nThin = 1, coda = FALSE, DIC = TRUE)

res <- samplesHistory(node = '*', plot = FALSE) # Plot the draws for all (hence the *) variables

par(mfrow = c(1,2))
hist(res[[1]][,1], 30, main = 'Posterior of p - first chain') # histogram of draws of a from the first Markov Chain
hist(res[[1]][,2], 30, main = 'Posterior of p - second chain') # histogram of draws of a from the first Markov Chain