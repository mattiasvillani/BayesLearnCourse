######################
###### Math exercise 2
######################

# Math exercise 2.1a)

# Scaled inverse chi squared density function
dinvchi <- function(x, v, tau2) return( ((tau2*v/2)^(v/2)/gamma(v/2))*exp(-v*tau2/(2*x)) /x^(1+v/2) )

# Testing the function by comparing to the PDF plot in Wikipedia.
cols <- c("blue","green","red","black")
xGrid <- seq(0,5,length = 1000)
count <- 1
plot(xGrid,dinvchi(x=xGrid,v = 1,tau2=1), type = "l", ylim = c(0,1), lwd = 2, col = cols[count], xlab = "x", ylab = "f(x)")
for (v in c(2,4,10)){
  count <- count + 1
  lines(xGrid,dinvchi(x=xGrid,v = v,tau2=1), type = "l", lwd = 2, col = cols[count]) 
}

# Data
x <- c(0.6,3.2,1.2)
theta <- 1
n <- length(x)
s2 <- sum((x-theta)^2)/n

v0 <- 0.1
sigma02 <- 1

sigma2Grid <- seq(0.001,10,length = 1000)
plot(sigma2Grid, dinvchi(sigma2Grid, v0, sigma02), type = "l", lwd = 2, col = "blue", 
      ylab = "Density", xlab = expression(sigma^2), main ="Prior is InvChi(0.1,s2)")
lines(sigma2Grid, dinvchi(sigma2Grid, v0+n, (n*s2+v0*sigma02)/(v0+n)), type = "l", lwd = 2, col = "red")
legend(x = 6, y = 0.3, legend = c('prior','posterior'), col = c(4,2), lty = 1, lwd = 2)


PredBern <- function(a,b,s,f){
  n <- s + f
  return (c((b+f)/(a+b+n), (a+s)/(a+b+n)))
}

ExpUtil <- function(probs, decisionTable){
  nActions <- nrow(decisionTable)
  nStates <- ncol(decisionTable)
  EUtil <- rep(NA,nActions,1)
  for (action in 1:nActions){
    EUtil[action] <- sum(probs*decisionTable[action,])
  }
  return(list(EUtil = EUtil, optimalAction = which.max(EUtil)))
}

probs <- PredBern(a = 1, b = 1, s = 2, f = 8)
decisionTable <- matrix(c(20,10,50,-50),2,2, byrow = T)
ExpUtil(probs, decisionTable)

aGrid <- 1:20
bGrid <- 1:20
DecisionSurface <- matrix(NA, length(aGrid), length(bGrid))
for (a in aGrid){
  for (b in bGrid){
    probs <- PredBern(a, b, s = 2, f = 8)
    EU <- ExpUtil(probs, decisionTable)
    DecisionSurface[a,b] <- EU$optimalAction
  }
}
par(pty="s")
image(bGrid,aGrid,DecisionSurface, xlab = expression(alpha), ylab = expression(beta), xlim = c(0,20), ylim = c(0,20))
text(x = 12, y = 5, 'Bring umbrella', cex=0.8)
text(x = 5.5, y = 18, 'Leave umbrella', cex=0.8)
dev.copy(eps,'myplot.png')
dev.off()

# More data: n = 80
aGrid <- 1:20
bGrid <- 1:20
DecisionSurface <- matrix(NA, length(aGrid), length(bGrid))
for (a in aGrid){
  for (b in bGrid){
    probs <- PredBern(a, b, s = 16, f = 64)
    EU <- ExpUtil(probs, decisionTable)
    DecisionSurface[a,b] <- EU$optimalAction
  }
}
image(bGrid,aGrid,DecisionSurface, xlab = expression(alpha), ylab = expression(beta), xlim = c(0,20), ylim = c(0,20))
text(x = 17, y = 2, 'Bring umbrella', cex=0.8)
text(x = 5, y = 17, 'Leave umbrella', cex=0.8)


######################
###### Math exercise 3
######################

# Math exercise 3.2)

theta = 10

# Simulate data
x = runif(n = 10, min = theta-0.5, max = theta+0.5)

# Plot data
plot(x,0*x, pch = 1, cex = 0.2, xlim = c(theta-0.5,theta+0.5))
lines(x = c(theta-0.5, theta-0.5), y = c(-0.1,0.1), col = "red")
lines(x = c(theta+0.5, theta+0.5), y = c(-0.1,0.1), col = "red")


# Mean estimator
FreqSampDistMean <- function(n, nSim){
  xBar <- rep(0,nSim)
  for (i in 1:nSim){
    x = runif(n, min = theta-0.5, max = theta+0.5)
    xBar[i] <- mean(x)
  }
  return(xBar)
}

n <- 3
theta = 1.53
xBars <- FreqSampDistMean(n, nSim = 10000)
mean(xBars) # Should be close to theta
var(xBars) # Should be close to 1/(12*n)
hist(xBars,50)


# Midrange estimator
FreqSampDistMidRange <- function(n, nSim){
  xBar <- rep(0,nSim)
  for (i in 1:nSim){
    x = runif(n, min = theta-0.5, max = theta+0.5)
    xBar[i] <- (min(x)+max(x))/2
  }
  return(xBar)
}

n <- 5
xBars <- FreqSampDistMidRange(n, nSim = 1000)
mean(xBars) # Should be close to theta
var(xBars) # Should be close to 1/(12*n)
hist(xBars,50)


# Math exercise 3.3)

# 3.3 c)
s = 1
f = 5
n = s + f
a = 1
b = 1
thetaGrid <- seq(0.001,0.999, length = 1000)
plot(thetaGrid, dbeta(x = thetaGrid, shape1 = a+s, shape2 = b+f), 
     type= "l", lwd = 3, xlab = expression(theta), ylab = "density")
thetaHat = (a+s-1)/(a+b+n-2)
varTheta = (a+s-1)*(b+f-1)/(a+b+n-2)^3
lines(thetaGrid, dnorm(thetaGrid, mean = thetaHat, sd = sqrt(varTheta)), col ="red")

# 3.3 d)
s = 2
f = 10
n = s + f
a = 1
b = 1
thetaGrid <- seq(0.001,0.999, length = 1000)
plot(thetaGrid, dbeta(x = thetaGrid, shape1 = a+s, shape2 = b+f), 
     type= "l", lwd = 3, xlab = expression(theta), ylab = "density")
thetaHat = (a+s-1)/(a+b+n-2)
varTheta = (a+s-1)*(b+f-1)/(a+b+n-2)^3
lines(thetaGrid, dnorm(thetaGrid, mean = thetaHat, sd = sqrt(varTheta)), col ="red")

# Bonus
s = 20
f = 100
n = s + f
a = 1
b = 1
thetaGrid <- seq(0.001,0.999, length = 1000)
plot(thetaGrid, dbeta(x = thetaGrid, shape1 = a+s, shape2 = b+f), 
     type= "l", lwd = 3, xlab = expression(theta), ylab = "density")
thetaHat = (a+s-1)/(a+b+n-2)
varTheta = (a+s-1)*(b+f-1)/(a+b+n-2)^3
lines(thetaGrid, dnorm(thetaGrid, mean = thetaHat, sd = sqrt(varTheta)), col ="red")

# Exercise 3.4)
dataTable <- matrix(c(1.2,2.1,1.4,3.5,0.7,4.7), 3, 2, byrow = TRUE)
n <- c(5,5,10)
x1 = 1.3
x2 = 4.2
prior <- n+1
post <- rep(0,3)
for (i in 1:3){
  post[i] = dnorm(x1,dataTable[i,1], sd = sqrt(1/n[i]))*
            dnorm(x2,dataTable[i,2], sd = sqrt(1/n[i]))*
            prior[i]
}
post <- post/sum(post)
barplot(height = post, names.arg = c("A","B","C"), ylab = "Probability", xlab = "Disease")


x1Grid <- seq(-1,3,length = 1000)
plot(x1,0, xlim = c(-1,3), ylim = c(0,1.3), col = 'green', main = 'T1')
colVect <- c("black","red","blue")
for (i in 1:3){
  lines(x1Grid, dnorm(x1Grid,dataTable[i,1], sd = sqrt(1/n[i])), 
        col = colVect[i], lwd = 2)
}
legend(x = 2, y = 1.2, legend = c("A","B","C"), pch = '-', col = colVect, cex = 0.7, lwd = 2)

x2Grid <- seq(0,6,length = 1000)
plot(x2,0, xlim = c(0,6), ylim = c(0,1.3), main = 'T2')
colVect <- c("black","red","blue")
for (i in 1:3){
  lines(x2Grid, dnorm(x2Grid,dataTable[i,2], sd = sqrt(1/n[i])), 
        col = colVect[i], lwd = 2)
}
legend(x = 0.05, y = 1.2, legend = c("A","B","C"), pch = '-', col = colVect, cex = 0.7, lwd = 2)

