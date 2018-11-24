###################################################################################
# Author: Mattias Villani, Linköping University
# Script to illustrate data augmentation Gibbs sampler for probit regression
###################################################################################

###########   BEGIN USER INPUTS   ################
dataFile <- "/home/mv/Dropbox/Teaching/BayesLearn2012/Code/SpamReduced.dat"
chooseCov <- c(1:16) # Here we choose which covariates to include in the model
tau <- 10            # Prior scaling factor such that Prior Covariance = (tau^2)*I
nIter <- 10000        # Number of MCMC iterations
prcBurnin <- 10      # Percentage of nIter draws that are discarded before the nIter draws.
standardize <- TRUE  # If TRUE, covariates are standardized to zero mean and unit variance
###########     END USER INPUT    ################


install.packages("mvtnorm") # Loading a package that contains the multivariate normal pdf
install.packages("msm")     # Loading a package that contains the truncated normal distribution
library(mvtnorm) # This command reads the mvtnorm package into R's memory. NOW we can use dmvnorm function.
library(msm)

# Preliminaries
nBurnin <- round(nIter*prcBurnin/100)
nIter <- nIter + nBurnin
                      
# Loading data from file
Data<-read.table(dataFile, header=TRUE)  # Spam data from Hastie et al.
y <- as.vector(Data[,1]) # Data from the read.table function is a data frame. Let's convert y and X to vector and matrix.
X <- as.matrix(Data[,2:17])
covNames <- names(Data)[2:length(names(Data))]
X <- X[,chooseCov]; # Here we pick out the chosen covariates.
if (standardize){
  X <- scale(X)
  constantPos <- which(is.na(X[1,]))
  X[,constantPos] <- 1
}
covNames <- covNames[chooseCov]
nPara <- dim(X)[2]
nObs <- dim(X)[1]
nSpam <- sum(y==1)

# Setting up the prior
priorMean <- as.vector(rep(0,nPara)) # Prior mean vector
priorCov <- tau^2*diag(nPara)
priorPrec <- solve(priorCov)
eye <- diag(rep(1,nPara))
XX <- crossprod(X)

postBeta <- matrix(NA,nIter,nPara)
betas <- solve(XX,crossprod(X,y)) # OLS estimate as initial value
u <- matrix(NA, nObs, 1)

for (i in 1:nIter){
    
  xBeta <- X%*%betas
  
  # Draw u | betas
  u[y == 0] <- rtnorm(n = nObs - nSpam, mean = xBeta[y==0], sd = 1, lower = -Inf, upper = 0)
  u[y == 1] <- rtnorm(n = nSpam, mean = xBeta[y==1], sd = 1, lower = 0, upper = Inf)
  
  # Draw betas | u
  betaHat <- solve(XX,t(X)%*%u)
  postPrec <- XX + priorPrec
  postCov <- solve(postPrec)
  betasMean <- solve(postPrec,XX%*%betaHat + priorPrec%*%priorMean)
  betas <- t(rmvnorm(n = 1, mean = betasMean, sigma = postCov))
  postBeta[i,] <- t(betas)
  
}

postBeta <- postBeta[(nBurnin+1):dim(postBeta)[1],] # Removing burn-in

# Computing inefficiency factors
ACF <- matrix(0,nPara,1)
for (j in 1:nPara){
  ACF[j] <- 1+2*sum(acf(postBeta[,j], plot = FALSE)$acf[-1])
}

# print results
results <- matrix(NA,nPara,4)
results[,1] <- colMeans(postBeta)
results[,2] <- apply(postBeta,2,sd)
results[,3] <- results[,1]/results[,2]
results[,4] <- ACF
colnames(results) <- c("PostMean","PostStd","t-ratio","IF")
print(results)

par(mfrow = c(4,4))
for (j in 1:16){
densEst <- density(postBeta[,j])
  plot(densEst$x,densEst$y, type = "l", main = covNames[j], xlab = "", ylab = "")
}