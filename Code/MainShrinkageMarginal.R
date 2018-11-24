# Spline regression with estimated shrinkage parameter
# Author: Mattias Villani, Linkoping University, Sweden
# Date: 2012-11-12

setwd('~/Dropbox/Teaching/BayesLearn2012/Code/')

# BEGIN USER INPUTS

# Data options
rawData <- read.table('/home/mv/Dropbox/Teaching/BayesLearn2012/Code/LidarData.dat', header = TRUE)
responseVar <- 'LogRatio' # The name of the response variable in the data frame rawData
covariates <- c('Distance')# Character vector with names of the response variables in the data frame rawData (currently only one covariate is supported)

# Model options
nKnots <- 24
polyOrder <- 2
standardizeX <- TRUE # Should the X's be standardized to mean zero and unit variance?

# Prior options
gPrior <- FALSE # gPrior makes the prior covariance of beta proportional to t(X)*X
deltaPrior <- 0.01 
nuPrior <- 4
sigma2Prior <- 2
etaPrior <- 2
lambdaPrior <- 0.1

# Prediction options
nGridPoints <- 100

# END USER INPUTS

# Sourcing code and installing packages
source('~/Dropbox/Teaching/BayesLearn2012/Code/SplineUtils.R')
# install.packages('geoR', repos = 'http://ftp.sunet.se/pub/lang/CRAN/')
library('geoR', verbose = F)

# Setting up the data
y <- as.matrix(rawData[responseVar])
x <- as.matrix(rawData[covariates])

# Function that sets up the spline basis
basis <- PolyTrunc(x, nKnots, p = polyOrder, standardizeX = standardizeX)
X <- basis$X
X <- X%*%diag(c(1,1/apply(X[,2:dim(X)[2]], 2, sd))) # Standardizing
knots <- basis$knots
transConst <- basis$transConst
XX <- crossprod(X) # Pre-computing it. We need it later
q <- 1 + polyOrder # Number of non-knots covariates

# This function computes the marginal posterior of lambda up to a proportionality factor.
LogMargPostLambda <- function(lambda, y, XX, nKnots, deltaPrior, nuPrior, sigma2Prior, etaPrior,lambdaPrior, gPrior = FALSE){
  n <- length(y)
  m <- nKnots # The number of knots
  q <- dim(XX)[2] - m # 
  if (gPrior){
    Scales <- diag( c( rep(sqrt(deltaPrior),q) , rep(sqrt(lambda), m) ) )
    D = Scales%*%crossprod(XX,Scales)
  }else{
    D <- diag( c( rep(deltaPrior,q) , rep(lambda, m) ) )
  }
  
  nuPost <- nuPrior + n
  OmegaPost <- XX + D
  muPost <- solve(OmegaPost,crossprod(X,y))
  sigma2Post <- (nuPrior*sigma2Prior + crossprod(y) - t(muPost)%*%solve(OmegaPost,muPost))/nuPost
  logDetD <- determinant(D,log = T)$modulus[1]
  logDetOmegaPost <- determinant(OmegaPost,log = T)$modulus[1]
  #print(nuPost)
  #print(sigma2Post)
  betaHat <- solve(XX,crossprod(X,y))
  s2 <- crossprod(y-X%*%betaHat)/n
  #logMargPost <- -0.5*logDetOmegaPost -(nuPost/2)*log(nuPrior*sigma2Prior + n*s2 + t(muPost)%*%crossprod(D,muPost)) 
                                                      + dinvchisq(lambda, etaPrior, lambdaPrior, log = T)
  logMargPost <- 0.5*(logDetD-logDetOmegaPost) -(nuPost/2)*log(nuPost*sigma2Post/2) + dinvchisq(lambda, etaPrior, lambdaPrior, log = T)
  #browser()
  return(logMargPost)
}

par(mfrow = c(2,1))
count <- 0
lambdaGrid <- seq(0.1,100,by = 0.1)
logPostLambda <- matrix(NA, length(lambdaGrid))
for (lambda in lambdaGrid){
   count <- count + 1
   logPostLambda[count] <- LogMargPostLambda(lambda, y, XX, nKnots, deltaPrior, nuPrior, sigma2Prior, etaPrior,lambdaPrior, gPrior = gPrior)
}
logPostLambda <- logPostLambda - max(logPostLambda) # Removing a constant to avoid overflow
plot(lambdaGrid, exp(logPostLambda), type = "l")
postModeLambda <- lambdaGrid[which(logPostLambda == max(logPostLambda))] # Posterior mode
message(paste('Posterior mode of lambda = ',postModeLambda))


# Predictions
# Setting up the grid of x-values where we evaluate E(y|x)
if (is.na(nGridPoints)){
  xGrid <- x
}else{
  xGrid <- seq(min(x), max(x), length=nGridPoints)
}
basisPred <- PolyTrunc(xGrid, knots = knots, p = polyOrder, standardizeX = TRUE, transConst = transConst)
XPred <- basisPred$X
XPred <- XPred%*%diag(c(1,1/apply(XPred[,2:dim(X)[2]], 2, sd))) # Standardizing

#postModeLambda <- solve(XX,crossprod(X,y))
DMode <- diag( c( rep(deltaPrior,q) , rep(postModeLambda, nKnots) ) )
betaMode <- solve(XX + DMode,crossprod(X,y))
DF <- sum(diag(X%*%solve(XX + DMode,t(X)))) # Degrees of freedom of the fit
fittedVals <- XPred%*%betaMode
plot(x,y, ylab = responseVar, xlab = covariates[1])
lines(xGrid,fittedVals,type="l", col = "red", lwd = 3)
message(paste('Degrees of freedom for the fit = ', DF))
knotsOrigScale <- transConst[1] + transConst[2]*knots
rug(knotsOrigScale, lwd = 2, col = "blue")
