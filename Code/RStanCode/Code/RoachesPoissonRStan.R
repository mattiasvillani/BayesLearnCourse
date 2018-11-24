# My own version of the example Roaches
# Author: Mattias Villani, Statistics, Linkoping University, Sweden
#         mattias.villani@liu.se
# Date:    2012-12-05
# Ported to RStan by Mans Magnusson
# Date:    2013-10-24
# Updated: 2018-04-16 by Per Siden

#install.packages("ggplot2")
library(ggplot2)
#install.packages("rstan")
library(rstan)

roachesData<-read.csv2("../Data/roachdata.csv")
head(roachesData)

roachDataRStan<-
  list(N = nrow(roachesData),
       exposure2 = roachesData$exposure2,
       senior = roachesData$senior, 
       treatment = roachesData$treatment,
       y = roachesData$y) 

# The poisson regression model
roachModel = '
data {
  int<lower=0> N;
  vector[N] exposure2;
  vector[N] senior;
  vector[N] treatment;
  int y[N];
}

transformed data {
  vector[N] log_expo;
  log_expo = log(exposure2);
}

parameters {
  vector[3] beta;
}

model {
  // Prior
  beta ~ normal(0,1000.0);

  // Model/likelihood
  y ~ poisson_log(log_expo + beta[1] + beta[2] * treatment
                  + beta[3] * senior);
}
generated quantities {
  int<lower=0> pred_treat;
  int<lower=0> pred_notreat;

  vector[3] exp_beta; 
  exp_beta = exp(beta);

  pred_treat = poisson_rng(exp_beta[1]*exp_beta[2]);
  pred_notreat = poisson_rng(exp_beta[1]);
}
'

fitRoach<-stan(model_code=roachModel,
           data=roachDataRStan,
           par=c("exp_beta","pred_treat","pred_notreat"),
           warmup=1000,
           iter=10000,
           chains=2)

print(fitRoach,digits=2)

# Plot some results
res<-extract(fitRoach)

# Plot overlapping histograms
par(mfrow=c(2,1))
str(res$exp_beta[,2])
hist(res$exp_beta[,2])
hist(res$pred_treat,main="Treated",xlim=c(0,70),xlab="Predicted number of roaches")
hist(res$pred_notreat,main="Not treated",xlim=c(0,70),xlab="Predicted number of roaches")

smoothScatter(res$pred_treat,res$pred_notreat,xlim=c(0,70),ylim=c(0,70))

# Whats the probability that there will be more roaches in a treated house?
mean(res$pred_treat > res$pred_notreat)
lines(x=c(0,70),y=c(0,70))

