# Install RStan - uncomment the first time
#source('http://mc-stan.org/rstan/install.R', echo = TRUE, max.deparse.length = 2000)
#install_rstan()

# Load rstan
library(rstan)

# Set wd
setwd('~/Dropbox/Teaching//BayesLearning/Code/RStanCode/')

# Simulated data 
a<-170^2/100
b<-170/100
height<-round(rgamma(52,a,b))
weight<-rnorm(52,mean=10+0.35*height,sd=3)
plot(weight,height)


# Model
stanModel<-'
data {
  int<lower=0> n; # The number of observations
  real<lower=0> my_height; 
  vector[n] height; 
  vector[n] weight; 
}

transformed data {
  vector[n] SHeight; 
  real MySHeight; 
  SHeight <- (height - mean(height)) / sd(height); 
  MySHeight <- (my_height - mean(height)) / sd(height);
}

parameters {
  real alpha;
  real beta;
  real<lower=0> tau;
}

transformed parameters {
  real<lower=0> sigma;
  sigma <- 1.0 / sqrt(tau);
}

model {
  // Priors 
  alpha ~ exponential(2.0); 
  beta ~ normal(0.0,1000.0); 
  tau ~ gamma(0.001,0.001);
  # Model 
  for (i in 1:n) 
     weight[i] ~ normal(alpha + beta * SHeight[i], sigma);
}

generated quantities {
  real my_weight_pred; 
  my_weight_pred <- alpha + beta * MySHeight + normal_rng(0,sigma) ;
}
'

# Create Stan Data format
weightData <- list(n = length(weight),
                   my_height=198, 
                   height=height, 
                   weight=weight)

# Fit the model
fit1<-stan(model_code=stanModel,
           data=weightData,
           warmup=2000,
           iter=4000,
           chains=4)
fit1
plot(fit1)

# Change height
weightData2 <- weightData
weightData2$my_height<-164

fit2<-stan(fit=fit1, # I use the same (already compiled) model
           data=weightData2,
           pars=c("my_weight_pred"), # Choose variables of interest
           warmup=1000,
           iter=5000,
           chains=4)

fit2
plot(fit2)
