# Script: illustrating normal posterior approximation for probit regression

library(bayeslearn)
library(SUdatasets)

# Loading titanic data from SUdatasets
y = SUdatasets::titanic$survived
X = cbind(1, SUdatasets::titanic$age)

# Setting prior
mu = c(0,0) # Prior is beta ~ N(0, tau2*I)
Sigma = 10^2*diag(2)

# Optimization to find mode and Hessian
initVal = as.vector(solve(crossprod(X,X))%*%t(X)%*%y) # naive OLS as initial values
nPara = dim(X)[2]
optRes = optim(initVal, logPostProbitReg, gr=NULL, y, X, mu, Sigma, method=c("BFGS"),
               control=list(fnscale=-1), hessian=TRUE)
postMode =  optRes$par # Posterior mode
postCov = -solve(optRes$hessian) # Approx posterior covariance matrix

# Sampling from normal posterior approximation and plotting histograms.
betaPostDraws = mvtnorm::rmvnorm(n = 5000, mean = postMode, sigma = postCov) # Draws from posterior
par(mfrow = c(1,2))
hist(betaPostDraws[,1], breaks = 30, main = expression(paste("Posterior ", beta[0])), xlab = "")
hist(betaPostDraws[,2], breaks = 30, main = expression(paste("Posterior ", beta[1])), xlab = "")

