# L2-regularization for Stronium example in Bayesian Learning book

setwd("~/Dropbox/BayesBook/Code/ppl/Stan/")
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Read and transform data
rawdata <- read.csv(file = "~/Dropbox/BayesBook/Data/fossil.csv")
n  = dim(rawdata)[1]
y = rawdata$strontium_ratio
x = rawdata$age

# Standardize the covariates and the response variable.
mean_y = mean(y)
mean_x = mean(x)
sd_y = sd(y)
sd_x = sd(x)
y = (y - mean_y)/sd_y
x = (x - mean_x)/sd_x

# Set up covariate matrix from 10 degree polynomial
degree = 10 # polynomial degree
X = matrix(rep(0,n*degree), n, degree)
for (k in 1:degree){
  X[,k] = x^k
}
p = dim(X)[2]

# Setup data structures used by Stan
data <- list(n = length(y), p = p, X = X, y = y)
prior <- list(c = 100, nu0 = 2, sigma20 = 0.11, omega0 = 0.01, psi20 = 100)

l2regression = '
data {
  // data
  int<lower=0> n;   // number of observations
  int<lower=0> p;   // number of covariates
  matrix[n, p] X;   // covariate matrix
  vector[n] y;      // response vector
  // prior
  real<lower=0> c;
  real<lower=0> nu0;
  real<lower=0> sigma20;
  real<lower=0> omega0;
  real<lower=0> psi20;
}
parameters {
  real beta0;           // intercept
  vector[p] beta;       // regression coefficients
  real<lower=0> sigma2;  // error standard deviation
  real<lower=0> psi2;  // psi2 = 1 / lambda, in the usual L2-regularization 
}
model {
  beta0 ~ normal(0,c);
  sigma2 ~ scaled_inv_chi_square(nu0, sqrt(sigma20));
  psi2 ~ scaled_inv_chi_square(omega0, sqrt(psi20));
  beta ~ normal(0, sqrt(sigma2*psi2));
  y ~ normal(beta0 + X * beta, sqrt(sigma2));  
}
'

fit = stan(model_code = l2regression, data = c(data, prior), iter = 1000)
summary(fit)
traceplot(fit, pars = c("psi2", "sigma2"), nrow = 2)

postDraws <- extract(fit, permuted = TRUE) # return a list of arrays 
lambdaDraws <- 1/postDraws$psi2
hist(lambdaDraws, 50, xlab = expression(1/psi^2))

# Plotting the posterior distribution of the fit

# Set up grid in x-space and construct covariate matrix with polynomial basis for predictions.
nGrid = 100
xGrid = seq(min(x), max(x), length = nGrid)
XGrid = matrix(rep(0,m*(degree+1)), nGrid, degree + 1)
for (k in 0:degree){
  XGrid[,k+1] = xGrid^k
}

# Compute regresion curve for each posterior draws
nDraws = dim(postDraws$beta)[1]
yHatGrid = matrix(0, nDraws, nGrid)
for (i in 1:nDraws){
  beta0 = postDraws$beta0[i]
  beta_ = postDraws$beta[i,]
  yHatGrid[i,] = XGrid %*% c(beta0,beta_)
}

# Plot data with posterior mean curve and 95 equal tail bands
plot(x,y, pch = 19, col = "gray", cex = 0.7, xlab = "age", ylab = "strontium")
postMean = colMeans(yHatGrid)
postQuantiles = apply(yHatGrid, 2, quantile, c(0.025,0.975))
lines(xGrid, postMean, col = "indianred", lwd = 3)
lines(xGrid, postQuantiles[1,], col = "cornflowerblue")
lines(xGrid, postQuantiles[2,], col = "cornflowerblue")
