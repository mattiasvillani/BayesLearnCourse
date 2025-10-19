# Script to illustrate that direct iid sampling is much more efficient than Gibbs sampling
# Bivariate normal target
# Author: Mattias Villani, Stockholm and Linköping University. http://mattiasvillani.com

# Just some plotting option to make the plots a bit prettier
options(scipen = 999) # Disable scientific notation in the plots
library(latex2exp)    # Math symbols in plots
library("RColorBrewer")
plotColors = brewer.pal(12, "Paired")

# Setup 
mu1 <- 1
mu2 <- -1
rho <- 0.9
mu <- c(mu1,mu2)
Sigma = matrix(c(1,rho,rho,1),2,2)
nDraws <- 500 # Number of draws

library(mvtnorm) # To access the rmvnorm function

# Direct sampling from bivariate normal distribution
directDraws <- rmvnorm(nDraws, mu, Sigma)


# Gibbs sampling
gibbsDraws <- matrix(0,nDraws,2)
theta2 <- 0
for (i in 1:nDraws){
  
  # Update theta1 given theta2
  theta1 <- rnorm(1, mean = mu1 + rho*(theta2-mu2), sd = sqrt(1-rho^2))
  gibbsDraws[i,1] <- theta1
  
  # Update theta2 given theta1
  theta2 <- rnorm(1, mean = mu2 + rho*(theta1-mu1), sd = sqrt(1-rho^2))
  gibbsDraws[i,2] <- theta2
  
}

# Plotting the results to compare the two sampling methods
par(mfrow=c(2,2))

# DIRECT SAMPLING
minY = round(min(directDraws[,1]))
maxY = round(max(directDraws[,1]))
plot(1:nDraws, directDraws[,1], type = "l", col = plotColors[2], 
     ylab=TeX('$\\theta$'), lwd = 2, xlab = 'MCMC iteration', 
     xlim = c(0,nDraws), ylim = c(minY, maxY), main = 'Raw - Direct')

hist(directDraws[,1], freq = FALSE, main='Direct draws', ylim = c(0,0.5), 
     xlab=TeX('$\\theta$'))
lines(seq(-2,4,by=0.01), dnorm(seq(-2,4,by=0.01), mean = 1), col = plotColors[4], 
      lwd = 4)

cusumData =  cumsum(directDraws[,1])/seq(1,nDraws)
minY = floor(min(cusumData))
maxY = ceiling(max(cusumData))
plot(1:nDraws, cusumData, type = "l", col = plotColors[6], ylab='Cumulative estimate', 
     lwd = 2, xlab = 'MCMC iteration', xlim = c(0,nDraws), 
     ylim = c(minY,maxY), main = 'Cusum - Direct')
lines(seq(1,nDraws),1*matrix(1,1,nDraws),col= plotColors[3], lwd=2)
a = acf(directDraws[,1], main='Direct draws', lag.max = 20, plot = F)
barplot(height = a$acf[-1], names.arg=seq(1,20), col = plotColors[3])

# GIBBS
plot(1:nDraws, gibbsDraws[,1], type = "l", col = plotColors[2], 
     ylab=TeX('$\\theta$'), lwd = 2, xlab = 'MCMC iteration', 
     xlim = c(0,nDraws), main = 'Raw - Gibbs')

hist(gibbsDraws[,1], freq = FALSE, main='Gibbs draws', ylim = c(0,0.5), 
     xlab=TeX('$\\theta$'))
lines(seq(-2,4, by=0.01), dnorm(seq(-2,4, by=0.01), mean = 1), 
      col = plotColors[4], lwd = 4)

cusumData =  cumsum(gibbsDraws[,1])/seq(1,nDraws)
minY = floor(min(cusumData))
maxY = ceiling(max(cusumData))
plot(1:nDraws, cusumData, type = "l", col = plotColors[6], ylab='Cumulative estimate', 
     lwd = 2, xlab = 'MCMC iteration', xlim = c(0,nDraws), 
     ylim = c(minY,maxY), main = 'Cusum - Gibbs')
lines(seq(1,nDraws),1*matrix(1,1,nDraws),col = plotColors[3], lwd=2)

a = acf(gibbsDraws[,1], main='Gibbs draws', lag.max = 20, plot = F)
barplot(height = a$acf[-1], names.arg=seq(1,20), col = plotColors[3])

