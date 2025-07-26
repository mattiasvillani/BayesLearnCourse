# My own version of the example Roaches
# Author: Mattias Villani, Statistics and Machine Learning, Linkoping University, Sweden
#         mattias.villani@liu.se
# Date:   2017-05-08

setwd("~/Dropbox/Teaching/BayesLearning/Code/RStanCode/")

#install.packages("ggplot2")
library(ggplot2)
#install.packages("rstan")
library(rstan)

roachesData<-read.csv2("Data/roachdata.csv")
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
  # Prior
  beta ~ normal(0,1000.0);

  # Model/likelihood
  y ~ poisson_log(log_expo + beta[1] + beta[2] * treatment
                  + beta[3] * senior);
}
generated quantities {
  vector[3] exp_beta; 
  exp_beta = exp(beta);
}
'

fitRoach<-stan(model_code=roachModel,
           data=roachDataRStan,
           par=c("exp_beta"),
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


