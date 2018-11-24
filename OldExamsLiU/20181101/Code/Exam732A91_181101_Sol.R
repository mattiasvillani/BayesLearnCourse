# SOLUTION TO COMPUTER EXAM IN BAYESIAN LEARNING - 2018-11-01
# Author: Per Siden and Mattias Villani

# First load all the data into memory by running the R-file given at the exam
rm(list=ls())
source("ExamData.R")
set.seed(1)

###############################
########## Problem 1 ########## 
############################### 

# 1a)
nSim = 1000
y = c(1690,1790,1760,1750)
n = length(y)
sigma2 = 50^2

maxWeightGivenDay = rnorm(nSim, mean = mean(y), sd = sqrt(sigma2/n+sigma2))
par(mfrow=c(1,1))
hist(maxWeightGivenDay,50)

# 1b)
weekWeightYear = matrix(NA,52,nSim)
for (i in 1:nSim){
  weekWeightYear[,i] = t(rnorm(52, mean = mean(y), sd = sqrt(sigma2/n+sigma2)))
}
countWeightYear = colSums(weekWeightYear > 1850)
hist(countWeightYear,50)
sum(countWeightYear)/nSim
# Roughly 1.73

# 1c)
ExpectedLoss<-function(a, weekWeightYear){
  EL = a + mean(colSums(weekWeightYear>1000*log(a)))
  return(EL)
}

aGrid = seq(2,10,by = 0.01)
EL = rep(NA,length(aGrid),1)
count = 0
for (a in aGrid){
  count = count + 1
  EL[count] = ExpectedLoss(a, weekWeightYear)
}
plot(aGrid, EL, type = "l")
aOpt = aGrid[which.min(EL)] # This is the optimal a
points(x= aOpt, y = ExpectedLoss(a=aOpt, weekWeightYear), col = "red")
aOpt
# Roughly 6.74

###############################
########## Problem 2 ########## 
############################### 

fish_mod = cbind(fish,fish$age^2,fish$temp^2,fish$age*fish$temp)
names(fish_mod)[5:7] = c("age2","temp2","agetemp")

# m = glm(length ~ 0 + .,data=fish_mod)
# summary(m)

y = fish_mod$length
X = as.matrix(fish_mod[,2:7])
nCovs = dim(X)[2]

# Prior
mu_0 = rep(0,nCovs)
Omega_0 = 0.01*diag(nCovs)
v_0 = 1
sigma2_0 = 10000

nIter = 5000
Results = BayesLinReg(y, X, mu_0, Omega_0, v_0, sigma2_0, nIter)

# 2a
c(mean(Results$betaSample[,1]),quantile(Results$betaSample[,1], c(0.025, 0.975)))
c(mean(Results$betaSample[,2]),quantile(Results$betaSample[,2], c(0.025, 0.975)))
c(mean(Results$betaSample[,3]),quantile(Results$betaSample[,3], c(0.025, 0.975)))
c(mean(Results$betaSample[,4]),quantile(Results$betaSample[,4], c(0.025, 0.975)))
c(mean(Results$betaSample[,5]),quantile(Results$betaSample[,5], c(0.025, 0.975)))
c(mean(Results$betaSample[,6]),quantile(Results$betaSample[,6], c(0.025, 0.975)))

# 2b
mean(sqrt(Results$sigma2Sample))
median(sqrt(Results$sigma2Sample))

# 2c
n = 160
agrid = seq(1,n)
fmean = matrix(0,n,1)
fbands = matrix(0,n,2)
for(i in 1:n){
  f = Results$betaSample %*% c(1,i,25,i^2,25^2,25*i)
  fmean[i] = mean(f)
  fbands[i,] = quantile(f,probs=c(.025,.975))
}

plot(fish_mod$age[1:11],fish_mod$length[1:11],type='p',xlab="age",ylab="length",
     main="Posterior mean and bands",ylim=c(0,500))
lines(agrid,fmean)
lines(agrid,fbands[,1],col=2)
lines(agrid,fbands[,2],col=2)

# 2d (This is solved on paper).

###############################
########## Problem 3 ########## 
############################### 

# This is solved on paper.

###############################
########## Problem 4 ########## 
############################### 

# 4a
x = weibull

logPostWeibull <- function(param, x){
  theta1 = param[1]
  theta2 = param[2]
  logPost =   sum(dweibull(x, shape = theta1, scale = theta2, log=TRUE)) +
    - 2*log(theta1*theta2)
  return(logPost)
}

initVal = c(1,1)
optRes <- optim(par = initVal, fn  = logPostWeibull, gr = NULL, x, method = c("L-BFGS-B"),
                lower = c(0.0001,0.0001), upper = c(Inf,Inf), control = list(fnscale = -1), hessian = TRUE)
postMean <- optRes$par # This is the mean vector
postCov <- -solve(optRes$hessian) # This is posterior covariance matrix

print(postMean)
print(postCov)

# 4b

Metropolis <- function(c,niter,warmup,initVal,Sigma,logPostFunc,...) {
  
  theta <- initVal
  thetamat <- matrix(0,length(theta),warmup+niter)
  thetamat[,1] <- theta
  accprobvec <- rep(0,warmup+niter)
  
  for(i in 2:(warmup+niter)) {
    thetaProp <- t(rmvnorm(1,theta,c*Sigma))
    thetaProp[thetaProp <= 0] = 1e-6
    accprob <- exp(logPostFunc(thetaProp,...) - logPostFunc(theta,...))
    accprobvec[i] <- min(accprob,1)
    if(runif(1) < accprob) {
      theta <- thetaProp
    } 
    thetamat[,i] <- theta
  }
  
  return(list(thetamat=thetamat,accprobvec=accprobvec))
}

###################
#### c = 0.1  #####
###################
c <- 0.1
niter <- 2000
warmup <- 500

initVal <- c(1,1)
Sigma = postCov
#Sigma = diag(c(.01,.1))

mp <- Metropolis(c,niter,warmup,initVal,Sigma,logPostWeibull,x)
n <- length(initVal)
theta_mean <- rowMeans(mp$thetamat[,(warmup+1):(warmup+niter)])
theta_var<- rep(0,n)
for(i in 1:n) {
  theta_var[i] <- var(mp$thetamat[i,(warmup+1):(warmup+niter)]) 
}

par(mfrow=c(2,1))
plot(mp$thetamat[1,], type="l")
plot(mp$thetamat[2,], type="l")
mean(mp$accprobvec)

# The chain is mixing fairly ok, but could be better. The acceptance probability is
# is around 0.83, which is much too high. It should be around 0.2-0.3 according to the Lecture 8 slides.
# The cTilde=0.1 is too low. The chain takes too small steps.

rowMeans(mp$thetamat)
apply(mp$thetamat,1,var)

###################
#### c = 4  #####
###################
c <- 4
niter <- 2000
warmup <- 500

initVal <- c(1,1)
Sigma = postCov
#Sigma = diag(c(.01,.1))

mp <- Metropolis(c,niter,warmup,initVal,Sigma,logPostWeibull,x)
n <- length(initVal)
theta_mean <- rowMeans(mp$thetamat[,(warmup+1):(warmup+niter)])
theta_var<- rep(0,n)
for(i in 1:n) {
  theta_var[i] <- var(mp$thetamat[i,(warmup+1):(warmup+niter)]) 
}

par(mfrow=c(2,1))
plot(mp$thetamat[1,], type="l")
plot(mp$thetamat[2,], type="l")
mean(mp$accprobvec)

# We see good mixing in the chain and acceptance probabilities between 25-30%
# which is optimal according to the Lecture 8 slides.

rowMeans(mp$thetamat)
apply(mp$thetamat,1,var)





###################
#### c = 100  #####
###################
c <- 100
niter <- 2000
warmup <- 500

initVal <- c(1,1)
Sigma = postCov
#Sigma = diag(c(.01,.1))

mp <- Metropolis(c,niter,warmup,initVal,Sigma,logPostWeibull,x)
n <- length(initVal)
theta_mean <- rowMeans(mp$thetamat[,(warmup+1):(warmup+niter)])
theta_var<- rep(0,n)
for(i in 1:n) {
  theta_var[i] <- var(mp$thetamat[i,(warmup+1):(warmup+niter)]) 
}

par(mfrow=c(2,1))
plot(mp$thetamat[1,], type="l")
plot(mp$thetamat[2,], type="l")
mean(mp$accprobvec)

# We see really poor mixing in the chain and acceptance probabilities is around 2%, which is
# far from the 25-30% which is optimal according to the Lecture 8 slides.
# We are using a too large cTilde and proposing too large steps, most of which 
# are rejected.

rowMeans(mp$thetamat)
apply(mp$thetamat,1,var)



