# Bayesian Learning Exam 2019-10-31
# Run this file once during the exam to get all the required data and functions for the exam in working memory 
# Author: Per Siden

###############################
########## Problem 1 ########## 
###############################

###############################
########## Problem 2 ########## 
############################### 

library(MASS)
Traffic = Traffic

###############################
########## Problem 3 ########## 
############################### 

###############################
########## Problem 4 ########## 
############################### 

# Load data
cars = cars

library(rstan)
LinRegModel <- '
data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma2;
}
model {
  sigma2 ~ scaled_inv_chi_square(5,10);
  for (n in 1:N)
    y[n] ~ normal(alpha + beta * x[n], sqrt(sigma2));
}
'