# Lab 4 Bayesian learning

# This is the log posterior density of the beta(s+a,f+b) density
LogPostBernBeta <- function(theta, s, f, a, b){
  logPost <- (s+a-1)*log(theta) + (f+b-1)*log(1-theta)
  return(logPost)
}

# Testing if the log posterior function works
s = 8;f = 2;a = 1;b = 1
logPost <- LogPostBernBeta(theta = 0.1, s, f, a, b) # First for a single theta value  ...
# ... then for a whole vector of values
thetas <- seq(0.001, 0.999, by = .01)
logPost <- LogPostBernBeta(theta = thetas, s, f, a, b) 
plot(thetas, exp(logPost), type ="l", main = 'Unnormalized beta posterior') # Note the exp()

# This is a rather useless function that takes the function myFunction, evaluates it at x = 0.3, 
# and then returns two times the function value.
MultiplyByTwo <- function(myFunction, ...){
  x <- 0.3
  y <- myFunction(x,...)
  return(2*y)
}

MultiplyByTwo(LogPostBernBeta,s,f,a,b)