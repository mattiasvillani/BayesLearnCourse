# Author: Mattias Villani, Statistics, Linkoping University, Sweden. e-mail: mattias.villani@liu.se

library(manipulate)

####################################################################
## Plotting the prior-to-posterior mapping for the Normal model.
####################################################################

NormalPriorPostPlot <- function(mu0,tau0,n,xbar,sigma){
  tau02 <- tau0^2
  sigma2 <- sigma^2
  taun2 <- 1/( n/sigma2 + 1/tau02 )
  taun <- sqrt(taun2)
  w <- (n/sigma2)/( n/sigma2 + 1/tau02 )
  mun <- w*xbar +  (1-w)*mu0
  
  # Finding suitable grid to plot over
  IntervalData = c(xbar-4*sigma/sqrt(n),xbar+4*sigma/sqrt(n))
  IntervalPrior = c(mu0-4*tau0,mu0+4*tau0)
  IntervalPost = c(mun-4*taun,mun+4*taun)
  minimum <- min(IntervalData,IntervalPost)
  maximum <- max(IntervalData,IntervalPost)
  
  thetaGrid <- seq(minimum, maximum, length=1000)
  normalizedLikelihood = dnorm(thetaGrid, mean = xbar, sd = sigma/sqrt(n))
  prior = dnorm(thetaGrid, mean = mu0, sd = tau0)
  posterior = dnorm(thetaGrid, mean = mun, sd = taun)
  maxDensity <- max(normalizedLikelihood, prior, posterior) # Use to make the y-axis high enough
  plot(thetaGrid, normalizedLikelihood, type = 'l', lwd = 3, col = "blue", xlim <- c(minimum,maximum), ylim <- c(0, maxDensity), xlab = "theta", 
       ylab = 'Density', main = expression(paste('Normal model - N(',mu[0],',',tau[0]^2,') prior')))
  lines(thetaGrid, posterior, lwd = 3, col = "red")
  lines(thetaGrid, prior, lwd = 3, col = "green")
  legend(x = minimum, y = maxDensity*0.95, legend = c("Likelihood", "Prior", "Posterior"), col = c("blue","green","red"), 
         lwd = c(3,3,3), cex = 0.7)
}

manipulate(
  NormalPriorPostPlot(mu0,tau0,n,xbar,sigma),
  mu0 = slider(-10, 10, step=1, initial = 0, label = "The mean in the Normal(mu0,tau0^2) prior"),
  tau0 = slider(0.1, 10, step=.1, initial = 3, label = "The standard deviation in the Normal(mu0,tau0^2) prior"),
  n = slider(1, 1000, step=10, initial = 10, label = "The number of data observations, n"),
  xbar = slider(-5, 5, step=0.01, initial = 3, label = "Sample mean"),
  sigma = slider(0, 100, step=1, initial = 10, label = "Standard deviation of data observations")
  )