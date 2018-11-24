# BRugs code for analyzing a Bernoulli model with a Beta(a,b) prior
# where a and b are unknown and estimated.
# Author: Mattias Villani, Linköping University
# Ported to RStan by Måns Magnusson
# Date:   2013-10-24

rm(list=ls())

library(rstan)

# Data 
dataBernHiarch <- list(x = c(1,1,0,0,1,1,1,1,0,1), n = 10)

BernBetaHiearchStanModel <- '
data {
  int<lower=0> n;
  int<lower=0,upper=1> x[n];
}

parameters {
  real<lower=0,upper=1> p;
  real<lower=0,upper=10> a;
  real<lower=0,upper=10> b;
} 

model {
for (i in 1:n)
  x[i] ~ bernoulli(p);
}
'

# Do the fitting of the model
fit1<-stan(model_code=BernBetaHiearchStanModel,
           data=dataBernHiarch,
           warmup=1000,
           iter=2000,
           chains=2)

print(fit1,digits_summary=3)

res <- extract(fit1,permuted=FALSE)

# Plot the a:s and b:s
par(mfrow = c(2,2))
hist(res[,1,2], 30, main = 'Posterior of a - first chain') # histogram of draws of a from the first Markov Chain
hist(res[,1,3], 30, main = 'Posterior of b - first chain') # histogram of draws of b from the first Markov Chain
hist(res[,2,2], 30, main = 'Posterior of a - second chain') # histogram of draws of a from the first Markov Chain
hist(res[,2,3], 30, main = 'Posterior of b - second chain') # histogram of draws of b from the first Markov Chain

