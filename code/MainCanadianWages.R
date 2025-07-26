# Spline regression with estimated shrinkage parameter
# Author: Mattias Villani, Linkoping University, Sweden
# Date: 2012-11-12

setwd('~/Dropbox/Teaching/BayesLearn2012/Code/')

# BEGIN USER INPUTS

# Model options
nKnots <- 10
polyOrder <- 2
standardizeX <- TRUE # Should the X's be standardized to mean zero and unit variance?

# Prior options
deltaPrior <- 0.001 
nuPrior <- 4
sigma2Prior <- 0.4
etaPrior <- 2
lambdaPrior <- 1

# Prediction options
nGridPoints <- 100

# END USER INPUTS

# Sourcing code and installing packages
source('~/Dropbox/Teaching/BayesLearn2012/Code/SplineUtils.R')
# install.packages('geoR', repos = 'http://ftp.sunet.se/pub/lang/CRAN/')
library('geoR', verbose = F)

rawData <- read.table('./CanadianWages.dat', header = T)
y <- rawData[,1]
x <- rawData[,2]

# Function that sets up the spline basis
basis <- PolyTrunc(x, nKnots, p = polyOrder, standardizeX = TRUE)
X <- basis$X
knots <- basis$knots
transConst <- basis$transConst
XX <- crossprod(X) # Pre-computing it. We need it later
q <- 1 + polyOrder # Number of non-knots covariates

# This function computes the marginal posterior of lambda up to a proportionality factor.
LogMargPostLambda <- function(lambda, y, XX, nKnots, deltaPrior, nuPrior, sigma2Prior, etaPrior,lambdaPrior){
  n <- length(y)
  m <- nKnots # The number of knots
  q <- dim(XX)[2] - m # 
  D = diag( c( rep(deltaPrior,q) , rep(lambda, m) ) )
  nuPost <- nuPrior + n
  OmegaPost <- XX + D
  muPost <- solve(OmegaPost,crossprod(X,y))
  sigma2Post <- nuPrior*sigma2Prior + crossprod(y) - t(muPost)%*%solve(OmegaPost,muPost)
  logDetD <- determinant(D,log = T)$modulus[1]
  logDetOmegaPost <- determinant(OmegaPost,log = T)$modulus[1]
  logMargPost <- 0.5*(logDetD-logDetOmegaPost) -(nuPost/2)*log(nuPost*sigma2Post/2) + dinvchisq(lambda, etaPrior, lambdaPrior, log = T)
  return(logMargPost)
}

count <- 0
lambdaGrid <- seq(0.1,50,by = 0.01)
logPostLambda <- matrix(NA, length(lambdaGrid))
for (lambda in lambdaGrid){
   count <- count +1
   logPostLambda[count] <- LogMargPostLambda(lambda, y, XX, nKnots, deltaPrior, nuPrior, sigma2Prior, etaPrior,lambdaPrior)
}
logPostLambda <- logPostLambda - max(logPostLambda) # Removing a constant to avoid overflow
plot(lambdaGrid, exp(logPostLambda), type = "l")
postModeLambda <- lambdaGrid[which(logPostLambda == max(logPostLambda))] # Posterior mode


# Predictions
# Setting up the grid of x-values where we evaluate E(y|x)
if (is.na(nGridPoints)){
  xGrid <- x
}else{
  xGrid <- seq(min(x), max(x), length=nGridPoints)
}
basisPred <- PolyTrunc(xGrid, knots = knots, p = polyOrder, standardizeX = TRUE, transConst = transConst)
XPred <- basisPred$X
DMode <- diag( c( rep(deltaPrior,q) , rep(postModeLambda, nKnots) ) )
betaMode <- solve(XX + DMode,crossprod(X,y))
DF <- sum(diag(X%*%solve(XX + DMode,t(X)))) # Degrees of freedom of the fit
fittedVals <- XPred%*%betaMode
plot(x,y)
lines(xGrid,fittedVals,type="l", col = "red", lwd = 3)
message(paste('Degrees of freedom for the fit = ', DF))

