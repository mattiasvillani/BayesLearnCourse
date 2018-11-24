# SOLUTION TO COMPUTER EXAM IN BAYESIAN LEARNING - 2018-08-22
# Author: Per Siden

# First load all the data into memory by running the R-file given at the exam
rm(list=ls())
source("ExamData.R")
set.seed(1)

###############################
########## Problem 1 ########## 
############################### 

# 1 a)

# Read the data
x = lions

logPostLogNormal <- function(x,mu,sigma2){
  sum(dlnorm(x,meanlog=mu,sdlog=sqrt(sigma2), log=TRUE)) + dnorm(mu,5,1,log=TRUE)
} 

sigma2 = 0.04
logPostLogNormal(x,5.25,sigma2)

muGrid <- seq(5.15, 5.35, length = 1000)
logPostEvals <- rep(0, 1000)
i = 0
for (mu in muGrid){
  i = i + 1
  logPostEvals[i] <- logPostLogNormal(x,mu,sigma2)
}
binWidth = muGrid[2]-muGrid[1] 
plot(muGrid, exp(logPostEvals)/(sum(exp(logPostEvals))*binWidth), type = "l", ylab = 'Posterior density', xlab = expression(mu))

# 1 b)

N = length(x)
library(rstan)

stanModel = '
data {
  int<lower=0> N; // Number of observations
  real<lower=0> x[N];
}

parameters {
  real mu;
  real<lower=0> sigma2;
}

model {
  mu ~ normal(5,1);
  sigma2 ~ scaled_inv_chi_square(5,0.2);
  for(i in 1:N)
    x[i] ~ lognormal(mu,sqrt(sigma2));

}'

data = list(N=N, x=x)
burnin = 500
niter = 2000
fit = stan(model_code=stanModel,data=data,
           warmup=burnin,iter=niter)

# Print the posterior mean and standard deviation
print(fit,digits=3,pars = c("mu", "sigma2"),probs=c(.025,.975))
# Joint posterior
pairs(fit,pars = c("mu", "sigma2"))

# 1 c)

# Extract posterior samples
postDraws <- extract(fit)
avgWeight = exp(postDraws$mu + postDraws$sigma2/2)
mean(avgWeight)
quantile(avgWeight, c(0.025, 0.975))
# The results for one seed gave an estimate (posterior mean) of 191kg
# and a 95% CI as (184,198)

###############################
########## Problem 2 ########## 
###############################

# 2a
library(mvtnorm)

# titanic = titanic[sample(1316,184),]
y <- as.vector(titanic[,1])
X <- as.matrix(titanic[,-1])
covNames <- names(titanic)[2:length(names(titanic))]
nPara <- dim(X)[2]

# Setting up the prior
tau <- 50
mu <- as.vector(rep(0,nPara)) # Prior mean vector
Sigma <- tau^2*diag(nPara)

# Defining the functions that returns the log posterior
logPost<- function(betaVect,y,X,mu,Sigma){
  
  nPara <- length(betaVect);
  linPred <- X%*%betaVect;
  
  # evaluating the log-likelihood                                    
  logLik <- sum( linPred*y -log(1 + exp(linPred)));
  if (abs(logLik) == Inf) logLik = -20000; # Likelihood is not finite, stear the optimizer away from here!
  
  # evaluating the prior
  logPrior <- dmvnorm(betaVect, matrix(0,nPara,1), Sigma, log=TRUE);
  
  # add the log prior and log-likelihood together to get log posterior
  return(logLik + logPrior)
}

initVal = rep(10,nPara)

OptimResults<-optim(initVal,logPost,gr=NULL,y,X,mu,Sigma,method=c("BFGS"),control=list(fnscale=-1),hessian=TRUE)

# Printing the results to the screen
postMode <- OptimResults$par
postCov <- -solve(OptimResults$hessian) # Posterior covariance matrix is -inv(Hessian)
names(postMode) <- covNames # Naming the coefficient by covariates
approxPostStd <- sqrt(diag(postCov)) # Computing approximate standard deviations.
names(approxPostStd) <- covNames # Naming the coefficient by covariates

par(mfrow=c(2,2))
for(i in 2:5){
  grid = seq(postMode[i] - 3*approxPostStd[i],postMode[i] + 3*approxPostStd[i],length=1000)
  plot(grid,dnorm(grid,postMode[i],approxPostStd[i]),type="l",main=c(names(postMode)[i],"posterior"),ylab="density")
}

# 2b
Pbeta1 = dnorm(0,postMode[2],approxPostStd[2])
Pbeta1
# The probability is 0.000128 which is the probability that an adult
# is less likely to survive than a child.

# 2c
woman = c(1,1,0,1,0)
man = c(1,1,1,0,0)
Ns = 1000
betaSim = matrix(0,Ns,nPara)
for(i in 1:Ns) {
  betaSim[i,] <- rmvnorm(1,postMode,postCov)
}

linPredWoman <- woman%*%t(betaSim)
linPredMan <- man%*%t(betaSim)
womanSim <- rbinom(Ns,1,exp(linPredWoman) / (1+exp(linPredWoman)))
manSim <- rbinom(Ns,1,exp(linPredMan) / (1+exp(linPredMan)))
ySim <- as.numeric(womanSim & !manSim)
mean(ySim)
# Roughly 0.79


###############################
########## Problem 3 ########## 
###############################

# 3c
n = 3
xbar = 5
a = .5 
b = .5
logmarglik1 <- lbeta(n+a,n*xbar+b) - lbeta(a,b)
logmarglik2 <- n*log(.5) + n*xbar*log(.5)

unnorm_modelprob = c(exp(logmarglik1)/10,exp(logmarglik2)*9/10)
modelprob = unnorm_modelprob / sum(unnorm_modelprob)
modelprob

###############################
########## Problem 4 ########## 
###############################

# 4b
# Setting up data and prior
y <- c(184,67,149)
alpha <- c(1,1,1) # Dirichlet prior hyperparameters
nIter <- 10000 # Number of posterior draws
# Defining a function that simulates from a Dirichlet distribution
SimDirichlet <- function(nIter, param){
  nCat <- length(param)
  thetaDraws <- as.data.frame(matrix(NA, nIter, nCat)) # Storage.
  for (j in 1:nCat){
    thetaDraws[,j] <- rgamma(nIter,param[j],1)
  }
  for (i in 1:nIter){
    thetaDraws[i,] = thetaDraws[i,]/sum(thetaDraws[i,])
  }
  return(thetaDraws)
}
# Posterior sampling from Dirichlet posterior
thetaDraws <- SimDirichlet(nIter,y + alpha)

mean(thetaDraws[,1] > 0.5)
# Roughly 0.052

# 4c
mean(thetaDraws[,1] > pmax(thetaDraws[,2],thetaDraws[,3]))
# Roughly 0.971

# 4d
# p = 0.971
p = 0.9
stdev = sqrt(p*(1-p)/10000)
c(p-1.96*stdev,p+1.96*stdev)


