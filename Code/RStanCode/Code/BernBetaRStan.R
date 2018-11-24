# BRugs code for analyzing a simple Bernoulli model with a Beta(a,b) prior
# Author: Mattias Villani, Linkoping University
# Ported to RStan by Mans Magnusson
# Date:    2013-10-24
# Updated: 2018-04-16 by Per Siden

rm(list=ls())

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Data 
x = c(1,1,0,0,1,1,1,1,0,1)
n = length(x)
a = 1
b = 1

BernBetaData <- list(n = length(x), x=x, a=a, b=b)

# Model
BernBetaStanModel <- '
data {
int<lower=0> n;
int<lower=0,upper=1> x[n];
real<lower=0> a;
real<lower=0> b;
}

parameters {
real<lower=0,upper=1> theta;
} 

model {
theta ~ beta(a,b);
for (i in 1:n)
x[i] ~ bernoulli(theta);
}
'

# Do the fitting of the model
burnin = 1000
niter = 2000
fit1<-stan(model_code=BernBetaStanModel,
           data=BernBetaData,
           warmup=burnin,
           iter=niter,
           chains=4)

# Print the fitted model
print(fit1,digits_summary=3)

# Extract posterior samples
postDraws <- extract(fit1) 

# Do traceplots of the first chain
par(mfrow = c(1,1))
plot(postDraws$theta[1:(niter-burnin)],type="l",ylab="theta",main="Traceplot")

# Do automatic traceplots of all chains
traceplot(fit1)

# Plot posterior histogram and compare with analytical posterior
thetaSeq <- seq(0,1,by=0.01)
par(mfrow = c(1,1))
hist(postDraws$theta, 40, freq = FALSE, main = 'Posterior of theta - all chains', xlab ='theta') # histogram of draws of a from the first Markov Chain
lines(thetaSeq, dbeta(thetaSeq, shape1 = sum(x) + a, shape2 = n - sum(x) + b), col = "red")
legend("topleft", inset=.05, legend = c('MCMC approximation','True density'), lty =c(1,1),col=c('black','red'))

