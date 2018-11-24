# My own version of the example from http://mathstat.helsinki.fi/openbugs/ExamplesFrames.html
# Author: Mattias Villani, Statistics, Linkoping University, Sweden
#         mattias.villani@liu.se
# Date:    2012-12-05
# Ported to RStan by Mans Magnusson
# Date:    2013-10-24
# Updated: 2018-04-16 by Per Siden

rm(list=ls())

library(rstan)

nBurnin <- 1000
nIter <- 2000

rstanSeedModel<-'
data {
  int<lower=0> N; // Number of observations
  int<lower=0> r[N]; // Number of successes
  int<lower=0> n[N]; // Numer of trials
  vector[N] x1; // Covariate 1
  vector[N] x2; // Covariate 2
}

parameters {
  real alpha0;
  real alpha1;
  real alpha2;
  real<lower=0> tau;
  vector[N] b;
}

transformed parameters {
  real<lower=0> sigma;
  sigma <- 1.0 / sqrt(tau);
}

model {
  // Priors
  alpha0 ~ normal(0.0,1.0E3);
  alpha1 ~ normal(0.0,1.0E3);
  alpha2 ~ normal(0.0,1.0E3);
  tau ~ gamma(1.0E-3,1.0E-3);

  // Model
  b ~ normal(0.0, sigma);
  r ~ binomial_logit(n, alpha0 + alpha1 * x1 + alpha2 * x2 + b);  
}
'

# Data
seedsData <- list(N = 21, 
                  r = c(10, 23, 23, 26, 17, 5, 53, 55, 32, 46, 10, 8, 10, 8, 23, 0, 3, 22, 15, 32, 3),
                  n = c(39, 62, 81, 51, 39, 6, 74, 72, 51, 79, 13, 16, 30, 28, 45, 4, 12, 41, 30, 51, 7),
                  x1 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
                  x2 = c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1))

fit1<-stan(model_code=rstanSeedModel,
           data=seedsData,
           warmup=nBurnin,
           iter=(nBurnin+nIter),
           chains=2)
fit1
print(fit1,digits_summary=3)
plot(fit1)

# Extract parameters samples
fit1ParSamples<-extract(fit1,permuted=FALSE)
dim(fit1ParSamples)

# Reuse the model
fit2 <- stan(fit=fit1,data=seedsData,warmup=nBurnin,iter=(nIter+nBurnin)*10,thin=10)
print(fit2,digits_summary=3)

fit2ParSamples<-extract(fit2,permuted=FALSE)
dim(fit2ParSamples)

