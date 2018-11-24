# SOLUTION TO COMPUTER EXAM IN BAYESIAN LEARNING - 2018-06-01
# Author: Per Siden

# First load all the data into memory by running the R-file given at the exam
rm(list=ls())
source("ExamData.R")
set.seed(1)

###############################
########## Problem 1 ########## 
############################### 

# 1 a)

nSim = 1000
alphaPrior = 20
betaPrior  = 2
n = 50
sumX = 500
muPriorSim = rgamma(n = nSim, shape = alphaPrior, rate = betaPrior)
muPostSim = rgamma(n = nSim, shape = alphaPrior + sumX, rate = betaPrior + n)

muGrid = seq(1,20,.01)
par(mfrow=c(2,1))
hist(muPriorSim,50,prob=TRUE,main ="Prior",xlab = expression(mu))
lines(muGrid,dgamma(muGrid,shape = alphaPrior, rate = betaPrior))
hist(muPostSim,50,prob=TRUE,main="Posterior",xlab = expression(mu))
lines(muGrid,dgamma(muGrid,shape = alphaPrior + sumX, rate = betaPrior + n))

# 1b)

x51Sample = rep(0,nSim)
for (i in 1:nSim){
  x51Sample[i] <- rpois(1,muPostSim[i]) # Use the posterior draws of mu from 1a)
}
par(mfrow=c(1,1))
hist(x51Sample,50,prob=TRUE,main ="Predictive distribution",xlab = "x51")

# 1c)
sum(x51Sample == 10)/nSim

# 1d)

520/52 + 520/52^2

###############################
########## Problem 2 ########## 
############################### 

# m = glm(length ~ 0 +.,data=fish)
# summary(m)

y = fish$length
X = as.matrix(fish[,2:4])
nCovs = dim(X)[2]

# Prior
mu_0 = rep(0,nCovs)
Omega_0 = 0.01*diag(nCovs)
# Omega_0[3,3] = 1000
v_0 = 1
sigma2_0 = 10000

nIter = 5000
Results = BayesLinReg(y, X, mu_0, Omega_0, v_0, sigma2_0, nIter)

# 2a
hist(Results$sigma2Sample, 50, freq=FALSE, main = 'Posterior of sigma2', xlab = expression(sigma^2))
hist(Results$betaSample[,1],50, freq=FALSE, main = 'Posterior of beta0', xlab = expression(beta_0))
hist(Results$betaSample[,2], 50, freq=FALSE, main = 'Posterior of beta_1', xlab = expression(beta_1))
hist(Results$betaSample[,3], 50, freq=FALSE, main = 'Posterior of beta_2', xlab = expression(beta_2))

# 2b
quantile(Results$betaSample[,2], c(0.05, 0.95))
# Interpretation of probability interval beta_1 in [2.3 3.0]
# Increasing the age by one day increases the length by between 2.3 and 3.0 mm
# with 90% (0.9) posterior probability.

# 2c
# On paper

# 2d
# Accounting for that there is a 0.5/0.5 chance of picking up a 30 days or 100 days aged fish,
# can be done in several ways. Here we will draw a random coin flip for each posterior draw
# to see which one to use
ytilde <- rep(0,nIter)
xtilde <- c(1,3.5,0,0)
for (i in 1:nIter){
  if (runif(1) > .5) {
    xtilde = c(1,30,30)
  } else {
    xtilde = c(1,100,30)
  }
  ytilde[i] = sum(xtilde*Results$betaSample[i,]) + rnorm(n=1, mean = 0, sd = sqrt(Results$sigma2Sample[i]))
}
hist(ytilde,50, main ="Predictive distribution of y", freq = FALSE)

###############################
########## Problem 3 ########## 
############################### 

# 3c
n = 10
x = 3
a = 1 
b = 1
logmarglik1 <- lchoose(n,x) + lbeta(x+a,n-x+b) - lbeta(a,b)
a = 4
b = 4
logmarglik2 <- lchoose(n,x) + lbeta(x+a,n-x+b) - lbeta(a,b)
logmarglik3 <- lchoose(n,x) + x*log(0.5) + (n-x)*log(0.5)

unnorm_modelprob = c(exp(logmarglik1)/3,exp(logmarglik2)/3,exp(logmarglik3)/3)
modelprob = unnorm_modelprob / sum(unnorm_modelprob)
modelprob

###############################
########## Problem 4 ########## 
###############################

# 4a

# Load the data greater than 200 into x
x = sulfur[sulfur > 200]

# Log pdf for the truncated normal
logdtruncnorm <- function(x, mu, sigma, L){
  logdens <- dnorm((x-mu)/sigma,log=TRUE) - log(sigma) - log(1-pnorm((L-mu)/sigma))
  return(logdens)
}

# Define the posterior (likelihood x prior)
logpostTruncnorm <- function(x, mu){
  sum(logdtruncnorm(x, mu, sigma = 100, L = 200)) + 0 # The prior is assumed to be constant so can add one on the log scale.
}

# Plot the posterior over a grid of mu values
gridWidth <- 1
muGrid <- seq(100, 400, by = gridWidth)
logPostGrid <- rep(0,length(muGrid))
count <- 0
for (mu in muGrid){
  count <- count + 1
  logPostGrid[count] <- logpostTruncnorm(x,mu)
}

# Taking exp() and normalizing so the density integrates to one. Note the (1/gridWidth) factor.
postGrid <- (1/gridWidth)*exp(logPostGrid)/sum(exp(logPostGrid))
plot(muGrid, postGrid, type = "l", lwd = 2, ylim = c(0,0.02), main="Posterior", 
     ylab = "Density", xlab = expression(mu))

# 4b

library(rstan)
T = length(sulfur)
T_cens = sum(sulfur <= 200)
censData <- list(T=T, T_cens = T_cens, x=sulfur, L=200)

# Model
censModel <- '
data {
  int<lower=0> T;       // Total number of time points
  int<lower=0> T_cens;  // Number of censored time points
  real x[T];            // Partly censored data
  real<upper=max(x)> L; // Lower truncation point
}

parameters {
  real mu;
  real<lower=0> sigma;
  real<upper=L> x_cens[T_cens]; // Censored values
}

model {
  int t_cens = 0;
  for (t in 1:T){
    if (x[t] > L) 
      x[t] ~ normal(mu,sigma);
    else {
      t_cens += 1;
      x_cens[t_cens] ~ normal(mu,sigma);
    }
  }
}
'

# Fit the model
warmup=1000
iter=2000
niter = 4*(iter-warmup)

fit <- stan(model_code=censModel,
            data=censData,
            warmup=warmup,
            iter=iter)
traceplot(fit) # The chains seem to be mixing well, which indicates convergence

list_of_draws = extract(fit)
par(mfrow=c(1,2))
hist(list_of_draws$mu,prob=TRUE,main="Posterior",ylab = "Density", xlab = expression(mu),xlim=c(100,400))
hist(list_of_draws$sigma,prob=TRUE,main="Posterior",ylab = "Density", xlab = expression(sigma))

# 4c

censModelAR1 <- '
data {
  int<lower=0> T;       // Total number of time points
  int<lower=0> T_cens;  // Number of censored time points
  real x[T];            // Partly censored data
  real<upper=max(x)> L; // Lower truncation point
}

parameters {
  real mu;
  real<lower=0> sigma;
  real phi;
  real<upper=L> x_cens[T_cens]; // Censored values
  vector[T] z;
}

model {
  int t_cens = 0;
  mu ~ normal(300,100);
  for (t in 2:T)
    z[t] ~ normal(mu+phi*(z[t-1]-mu),sigma);
  for (t in 1:T){
    if (x[t] > L) 
      x[t] ~ normal(z[t],20);
    else {
      t_cens += 1;
      x_cens[t_cens] ~ normal(z[t],20);
    }
  }
}
'

# Fit the model
warmup=1000
iter=2000
niter = 4*(iter-warmup)

fitAR1 <- stan(model_code=censModelAR1,
            data=censData,
            warmup=warmup,
            iter=iter)

list_of_draws = extract(fitAR1)
par(mfrow=c(1,1))
hist(list_of_draws$phi,prob=TRUE,main="Posterior",ylab = "Density", xlab = expression(phi))

postThetaMean = colMeans(list_of_draws$z)
postThetaBands = apply(list_of_draws$z, 2, quantile, probs = c(0.025, 0.975))

plot(sulfur,type="p",ylim=c(0,500),main="Posterior intensity over time",ylab = "Sulfur emission",
     xlab = "time")
lines(postThetaMean,type="l",col=2)
lines(postThetaBands[1,],type="l",col=c(3))
lines(postThetaBands[2,],type="l",col=c(3))
