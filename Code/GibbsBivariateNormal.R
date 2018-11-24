# Script to illustrate that direct iid sampling is much more efficient than Gibbs sampling
# Bivariate normal target
# Author: Mattias Villani. IDA, Linköping University. http://mattiasvillani.com

# Setup 
mu1 <- 1
mu2 <- -1
rho <- 0.9
mu <- c(mu1,mu2)
Sigma = matrix(c(1,rho,rho,1),2,2)
nDraws <- 1000 # Number of draws

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
par(mfrow=c(2,4))
plot(directDraws[,1], type="l", main='Direct draws', xlab='Iteration number', ylab=expression(theta[1]))
hist(directDraws[,1], freq = FALSE, main='Direct draws', ylim = c(0,0.5), xlab=expression(theta[1]))
lines(seq(-2,4,by=0.01),dnorm(seq(-2,4,by=0.01), mean = 1), col = "red", lwd = 3)
plot(cumsum(directDraws[,1])/seq(1,nDraws),type="l", main='Direct draws', xlab='Iteration number', ylab='cumulative mean of theta')
lines(seq(1,nDraws),1*matrix(1,1,nDraws),col="red",lwd=3)
acf(directDraws[,1], main='Direct draws', lag.max = 20)

plot(gibbsDraws[,1], type="l", main='Gibbs draws', xlab='Iteration number', ylab=expression(theta[1]))
hist(gibbsDraws[,1], freq = FALSE, main='Gibbs draws', ylim = c(0,0.5), xlab=expression(theta[1]))
lines(seq(-2,4,by=0.01),dnorm(seq(-2,4,by=0.01), mean = 1), col = "red", lwd = 3)
plot(cumsum(gibbsDraws[,1])/seq(1,nDraws),type="l", main='Gibbs draws', xlab='Iteration number', ylab='cumulative mean of theta')
lines(seq(1,nDraws),1*matrix(1,1,nDraws),col="red",lwd=3)
acf(gibbsDraws[,1], main='Gibbs draws', lag.max = 20)

# Plotting the cumulative path of estimates of Pr(theta1>0, theta2>0)
par(mfrow=c(2,1))
plot(cumsum(directDraws[,1]>0 & directDraws[,2]>0)/seq(1,nDraws),type="l", main='Direct draws', xlab='Iteration number', ylab='', ylim = c(0,1))
plot(cumsum(gibbsDraws[,1]>0 & gibbsDraws[,2]>0)/seq(1,nDraws),type="l", main='Gibbs draws', xlab='Iteration number', ylab='', ylim = c(0,1))

# Estimating the expected length of the vector (theta1,theta2)
par(mfrow=c(1,2))
lengthVect <- sqrt(gibbsDraws[,1]^2 + gibbsDraws[,2]^2)
hist(lengthVect,xlab=expression(sqrt(theta[1]^2 + theta[2]^2)), freq = FALSE, ylab ='Density', main = 'Histogram')
plot(density(lengthVect),xlab=expression(sqrt(theta[1]^2 + theta[2]^2)), ylab ='Density', main = 'Density estimate',bty='n')

