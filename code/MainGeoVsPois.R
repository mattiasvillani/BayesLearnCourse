# Model comparison: Geometric model vs Poisson model
# Author: Mattias Villani, Linköping University. http://mattiasvillani.com

# Log marginal likelihood Geometric model with beta prior
LogMargLikeGeo <- function(y,alpha1,beta1){
  yBar <- mean(y)
  n <- length(y)
  logMargLike <- lgamma(alpha1+beta1) -lgamma(alpha1) -lgamma(beta1) + lgamma(n + alpha1) + lgamma(n*yBar + beta1) - lgamma(n + n*yBar + alpha1 + beta1)
}


# Log marginal likelihood Poisson model with gamma prior
LogMargLikePois <- function(y,alpha2,beta2){
  yBar <- mean(y)
  n <- length(y)
  logMargLike <- lgamma(n*yBar + alpha2) + alpha2*log(beta2) - lgamma(alpha2) - (n*yBar + alpha2)*log(n+beta2) - sum(lgamma(y+1))
}


# Priors
alpha1 = 1; # Prior for the Geometric
alpha2 = 2; # Prior for the Geometric
beta1 = 2; # Prior for the Poisson
beta2 = 1; # Prior for the Poisson

# Data
lambda = 2;
n <- 10; # Sample size
y <- rpois(n,lambda) # generating data from Poisson with parameter lambda

# Computing log marginal likelihoods for both models and then converting to Bayes factor and posterior model probabilities
lmlGeo <- LogMargLikeGeo(y,alpha1,beta1);
lmlPois <- LogMargLikePois(y,alpha2,beta2);
BF = exp(lmlGeo-lmlPois)
PostProbM1 = exp(lmlGeo)/(exp(lmlGeo) + exp(lmlPois));
PostProbs = c(PostProbM1, 1-PostProbM1)
print(PostProbs)