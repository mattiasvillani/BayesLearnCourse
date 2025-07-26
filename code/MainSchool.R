# Eight schools example in Rstan Vignette (https://cran.r-project.org/web/packages/rstan/vignettes/rstan.html)

# Stan model function
schoolsModel <- '
data {
  int<lower=0> J;           // number of schools 
  real y[J];                // estimated treatment effects
  real<lower=0> sigma[J];   // s.e. of effect estimates 
}
parameters {
  real mu; 
  real<lower=0> tau;
  vector[J] eta;
}
transformed parameters {
  vector[J] theta;
  theta = mu + tau * eta;
}
model {
  target += normal_lpdf(eta | 0, 1);
  target += normal_lpdf(y | theta, sigma);
}
'

# Data
schools_data <- list(
  J = 8,
  y = c(28,  8, -3,  7, -1,  1, 18, 12),
  sigma = c(15, 10, 16, 11,  9, 11, 10, 18)
)

# Posterior sampling by HMC
library(rstan)
fit1 <- stan(
  model_code = schoolsModel,  # Stan program
  data = schools_data,    # named list of data
  chains = 4,             # number of Markov chains
  warmup = 1000,          # number of warmup iterations per chain
  iter = 2000,            # total number of iterations per chain
  cores = 2,              # number of cores (using 2 just for the vignette)
  refresh = 1000          # show progress every 'refresh' iterations
)

# Summarize results
print(fit1, pars=c("theta", "mu", "tau", "lp__"), probs=c(.1,.5,.9))
plot(fit1)
traceplot(fit1, pars = c("mu", "tau"), inc_warmup = TRUE, nrow = 2)

#install.packages("shinystan")
library(shinystan)
