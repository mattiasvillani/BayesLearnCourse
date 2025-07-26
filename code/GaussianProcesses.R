# Some simple code to simulate from a Gaussian Process.
# Author: Mattias Villani, http://mattiasvillani.com

# User input
nSim <- 10
sigmaF <- 0.1
l <- 2

#install.packages("mvtnorm")
library("mvtnorm")

# Setting up the kernel
SquaredExpKernel <- function(x1,x2,sigmaF=1,l=3){
  n <- length(x1)
  K <- matrix(NA,n,n)
  for (i in 1:n){
    K[,i] <- sigmaF*exp(-0.5*( (x1-x2[i])/l)^2 )
  }
  return(K)
}

MeanFunc <- function(x){
  m <- sin(x)
  return(m)
}

SimGP <- function(m = 0,K,x,nSim,...){
  # Simulates nSim realizations (function) form a Gaussian process with mean m(x) and covariance K(x,x')
  # over a grid of inputs (x)
  n <- length(x)
  if (is.numeric(m)) meanVector <- rep(0,n) else meanVector <- m(x)
  covMat <- K(x,x,...)
  f <- rmvnorm(n, mean = meanVector, sigma = covMat)
  return(f)
}

xGrid <- seq(-5,5,length=20)
fSim <- SimGP(m=MeanFunc, K=SquaredExpKernel, x=xGrid, nSim, sigmaF, l)

plot(xGrid, fSim[1,], type="l", ylim = c(-3,3))
for (i in 2:nSim) {
  lines(xGrid, fSim[i,], type="l")
}
lines(xGrid,MeanFunc(xGrid), col = "red", lwd = 3)



# Plotting using manipulate package
library(manipulate)

plotGPPrior <- function(sigmaF, l, nSim){
  fSim <- SimGP(m=MeanFunc, K=SquaredExpKernel, x=xGrid, nSim, sigmaF, l)
  plot(xGrid, fSim[1,], type="l", ylim = c(-3,3))
  for (i in 2:nSim) {
    lines(xGrid, fSim[i,], type="l")
  }
  lines(xGrid,MeanFunc(xGrid), col = "red", lwd = 3)
  title(paste('l =',l,', sigmaf =',sigmaF))
}

manipulate(
  plotGPPrior(sigmaF, l, nSim = 10),
  sigmaF = slider(0, 2, step=0.1, initial = 1, label = "SigmaF"),
  l = slider(0, 2, step=0.1, initial = 1, label = "Length scale, l")
)

