# Toy RStan example: Measuring the number of flowers of 3 plants for 4 months
# Per Siden 2018-04-23

rm(list=ls())

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

y = c(4,5,6,4,0,2,5,3,8,6,10,8)
plot(y,col=c(1,1,1,1,2,2,2,2,3,3,3,3))
N = length(y)
P = 3

StanModel = '
data {
  int<lower=0> N; // Number of observations
  int<lower=0> y[N]; // Number of flowers
  int<lower=0> P; // Number of plants
}

transformed data {
  int<lower=0> M; // Number of months
  M = N / P;
}

parameters {
  real mu;
  real<lower=0> sigma2;
  real mup[P];
  //real sigmap2[P];
}

transformed parameters {
  //real sigma;
  //sigma = sqrt(sigma2);
}

model {
  mu ~ normal(0,100); // Normal with mean 0, st.dev. 100
  sigma2 ~ scaled_inv_chi_square(1,2); // Scaled-inv-chi2 with nu 1, sigma 2
  //sigma ~ exponential(.2); // Exponential with mean 5 = 1/.2
  
  // Model 1: iid
  //for(i in 1:N)
  //  y[i] ~ normal(mu,sqrt(sigma2));

  // Model 2: Multilevel normal
  //for(p in 1:P){
  //  mup[p] ~ normal(mu,sqrt(sigma2));
  //  for(m in 1:M)
  //    y[M*(p-1)+m] ~ normal(mup[p],sqrt(sigmap2[p])); 
  //}

  // Model 3: Multilevel poisson
  for(p in 1:P){
    mup[p] ~ lognormal(mu,sqrt(sigma2)); // Log-normal
    for(m in 1:M)
      y[M*(p-1)+m] ~ poisson(mup[p]); // Poisson
  }
}'

data = list(N=N, y=y, P=P)
burnin = 1000
niter = 2000
fit = stan(model_code=StanModel,
           data=data,
           warmup=burnin,
           iter=niter,
           chains=4)

# Print the fitted model
print(fit,digits_summary=3)

# Extract posterior samples
postDraws <- extract(fit) 

# Do traceplots of the first chain
par(mfrow = c(1,1))
plot(postDraws$mu[1:(niter-burnin)],type="l",ylab="mu",main="Traceplot")

# Do automatic traceplots of all chains
traceplot(fit)

# Bivariate posterior plots
pairs(fit)
