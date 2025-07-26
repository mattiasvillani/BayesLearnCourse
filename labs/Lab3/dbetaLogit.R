dbetaLogit <- function(phi, shape1, shape2, log = FALSE){
  if (log == FALSE){
    # Computing the density
     density <- dbeta(exp(phi)/(1+exp(phi)), shape1, shape2, log = FALSE)
     jacobian <- exp(phi)/(1+exp(phi))^2
     return(density*jacobian)
  }else{
      # Computing log density
      logDensity <- dbeta(exp(phi)/(1+exp(phi)), shape1, shape2, log = TRUE)
      logJacobian <- phi - 2*log(1+exp(phi))
      return(logDensity + logJacobian)
  }
}

# Checking that I did the right thing by comparing my density with histogram of simulated draws
theta <- rbeta(n= 100000, shape1 = 3, shape2 = 5)
phi = log(theta/(1-theta))
hist(phi, 30, freq = FALSE)
trueDens <- dbetaLogit(seq(-10,10,by=.01), shape1 = 3, shape2 = 5)
lines(seq(-10,10,by=.01), trueDens, col = "red")