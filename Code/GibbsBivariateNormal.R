# Script to illustrate that direct iid sampling is much more efficient than Gibbs sampling
# Bivariate normal target
# Author: Mattias Villani, Stockholm and Linköping University. http://mattiasvillani.com

# Loading pretty plot settings
source('~/Dropbox/CodeSnippets/PlotSettingsR.R')

# Setup 
mu1 <- 1
mu2 <- -1
rho <- 0.9
mu <- c(mu1,mu2)
Sigma = matrix(c(1,rho,rho,1),2,2)
nDraws <- 500 # Number of draws

library(MASS) # To access the mvrnorm() function

# Direct sampling from bivariate normal distribution
directDraws <- mvrnorm(nDraws, mu, Sigma)


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
png('BiNormDirect.png')
par(cex.lab=cexLabDef, cex.axis = cexAxisDef)
par(mfrow=c(2,4))

# DIRECT SAMPLING
minY = round(min(directDraws[,1]))
maxY = round(max(directDraws[,1]))
plot(1:nDraws, directDraws[,1], type = "l", col = plotColors[2], ylab=TeX('$\\theta$'), 
     lwd = lwdExtraThin, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,nDraws), ylim = c(minY, maxY), 
     main = 'Raw - Direct')
axis(side = 1, at = seq(0, nDraws, by = 250))
axis(side = 2, at = seq(minY, maxY, by = 0.5))

hist(directDraws[,1], freq = FALSE, main='Direct draws', ylim = c(0,0.5), xlab=TeX('$\\theta$'))
lines(seq(-2,4,by=0.01),dnorm(seq(-2,4,by=0.01), mean = 1), col = plotColors[4], 
      lwd = lwdThinner)

cusumData =  cumsum(directDraws[,1])/seq(1,nDraws)
minY = floor(min(cusumData))
maxY = ceiling(max(cusumData))
plot(1:nDraws, cusumData, type = "l", col = plotColors[6], ylab='Cumulative estimate', 
     lwd = lwdExtraThin, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,nDraws), 
     ylim = c(minY,maxY), main = 'Cusum - Direct')
lines(seq(1,nDraws),1*matrix(1,1,nDraws),col= plotColors[3], lwd=lwdExtraThin)
axis(side = 1, at = seq(0, nDraws, by = 250))
axis(side = 2, at = seq(minY, maxY, by = 0.5))

a = acf(directDraws[,1], main='Direct draws', lag.max = 20, plot = F)
barplot(height = a$acf[-1], names.arg=seq(1,20), col = plotColors[3])

# GIBBS

minY = round(min(gibbsDraws[,1]))
maxY = round(max(gibbsDraws[,1]))
plot(1:nDraws, gibbsDraws[,1], type = "l", col = plotColors[2], ylab=TeX('$\\theta$'), 
     lwd = lwdExtraThin, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,nDraws), ylim = c(minY, maxY), 
     main = 'Raw - Gibbs')
axis(side = 1, at = seq(0, nDraws, by = 250))
axis(side = 2, at = seq(minY, maxY, by = 0.5))

hist(gibbsDraws[,1], freq = FALSE, main='Gibbs draws', ylim = c(0,0.5), xlab=TeX('$\\theta$'))
lines(seq(-2,4,by=0.01),dnorm(seq(-2,4,by=0.01), mean = 1), col = plotColors[4], 
      lwd = lwdThinner)

cusumData =  cumsum(gibbsDraws[,1])/seq(1,nDraws)
minY = floor(min(cusumData))
maxY = ceiling(max(cusumData))
plot(1:nDraws, cusumData, type = "l", col = plotColors[6], ylab='Cumulative estimate', 
     lwd = lwdExtraThin, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,nDraws), 
     ylim = c(minY,maxY), main = 'Cusum - Gibbs')
lines(seq(1,nDraws),1*matrix(1,1,nDraws),col = plotColors[3], lwd=lwdExtraThin)
axis(side = 1, at = seq(0, nDraws, by = 250))
axis(side = 2, at = seq(minY, maxY, by = 0.5))

a = acf(directDraws[,1], main='Direct draws', lag.max = 20, plot = F)
barplot(height = a$acf[-1], names.arg=seq(1,20), col = plotColors[3])

dev.off()

# Plotting the cumulative path of estimates of Pr(theta1>0, theta2>0)
par(mfrow=c(2,1))
plot(cumsum(directDraws[,1]>0 & directDraws[,2]>0)/seq(1,nDraws),type="l", main='Direct draws', xlab='Iteration number', ylab='', ylim = c(0,1))
plot(cumsum(gibbsDraws[,1]>0 & gibbsDraws[,2]>0)/seq(1,nDraws),type="l", main='Gibbs draws', xlab='Iteration number', ylab='', ylim = c(0,1))

# Estimating the expected length of the vector (theta1,theta2)
par(mfrow=c(1,2))
lengthVect <- sqrt(gibbsDraws[,1]^2 + gibbsDraws[,2]^2)
hist(lengthVect,xlab=expression(sqrt(theta[1]^2 + theta[2]^2)), freq = FALSE, ylab ='Density', main = 'Histogram')
plot(density(lengthVect),xlab=expression(sqrt(theta[1]^2 + theta[2]^2)), ylab ='Density', main = 'Density estimate',bty='n')

