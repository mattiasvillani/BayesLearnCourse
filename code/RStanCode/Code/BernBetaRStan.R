library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Stan to simulate from the posterior in the Bernoulli model with Beta prior

# Data 
x = c(1,1,0,0,1,1,1,1,0,1)
n = length(x)
a = 1
b = 1

data <- list(n = length(x), x=x, a=a, b=b)

# Model
BernModel <- '
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
fit1<-stan(model_code = BernModel,
           data = data,
           warmup = burnin,
           iter = niter,
           chains = 4)

# Print the fitted model
print(fit1, digits_summary = 3)

# Extract posterior samples
postDraws <- extract(fit1) 

# Do traceplots of the first chain
par(mfrow = c(1,1))
plot(postDraws$theta[1:(niter-burnin)],type="l",ylab="theta",main="Traceplot")

# Do automatic traceplots of all chains
traceplot(fit1)

# Plot posterior histogram and compare with analytical posterior
thetaSeq <- seq(0, 1, by=0.01)
par(mfrow = c(1,1))
hist(postDraws$theta, 40, freq = FALSE, col = "cornflowerblue", main = 'Posterior of theta - all chains', xlab ='theta')
lines(thetaSeq, dbeta(thetaSeq, shape1 = sum(x) + a, shape2 = n - sum(x) + b),
      col = "darkblue", lwd = 3)
legend("topleft", inset=.05, legend = c('MCMC approximation','True density'), 
       lty = c(1,1), col=c('cornflowerblue','darkblue'))


##############################################################################
# Same model again, but this with simulations from the predictive distribution
##############################################################################

data <- list(n = length(x), x = x, a = a, b = b)

# Model
BernModelPred <- '
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

generated quantities {
  int<lower=0,upper=1> yPred;
  yPred = bernoulli_rng(theta);
}
'

# Do the fitting of the model
burnin = 1000
niter = 2000
fit1<-stan(model_code = BernModelPred,
           data = data,
           warmup = burnin,
           iter = niter,
           chains = 4)

# Print the fitted model
print(fit1, digits_summary = 3)
