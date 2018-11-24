#######################################
# Bayesian Learning - Solution to Lab1 
#######################################

# Just some stuff for somewhat fancier plotting
library("RColorBrewer")
plotColors = brewer.pal(12, "Paired")
pointColor = plotColors[5] # Color for single dots
lwdDef = 8                 # Default line thickness
lwdThin = 6
lwdThinner = 4
lwdExtraThin = 2
pointSizeDef = 4
cexLabDef = 1.5            # Default scaling of font size labels
cexAxisDef = 1.5           # Default scaling of tick labels

# Disable scientific notation in the plots
options(scipen = 999)

#######################
###    Problem 1    ###
#######################

#### Problem 1a
n = 20
s = 14
alpha0 = 2
beta0 = 2
nIter = 10000
thetaDraws <- rbeta(n = nIter, shape1 = alpha0 + s, beta0 + n - s)
hist(thetaDraws, 50)

# Plotting cumulative estimate of posterior mean vs true mean
alphaPost = alpha0 + s
betaPost = beta0 + n - s
print(c(alphaPost, betaPost))
trueMean = alphaPost/(alphaPost  + betaPost)
thetaDrawsCumulativeMean = cumsum(thetaDraws)/(1:nIter)
plot(1:nIter, thetaDrawsCumulativeMean, type = "l", lwd = 2, xlab ="iteration", ylab = "posterior mean")
lines(1:nIter,trueMean*rep(1,nIter), col = "red", lwd = 2)
legend(x = 'topright', inset = 0.05, legend = c("Cumulative", "True"), lwd = c(2,2), col = c("black","red"))

# Plotting cumulative estimate of posterior stdev vs true stdev
trueStd = sqrt(alphaPost*betaPost/((alphaPost + betaPost)^2*(alphaPost + betaPost + 1)))
thetaDrawsCumulativeSqr = cumsum(thetaDraws^2)/(1:nIter)
thetaDrawsCumulativeStDev = sqrt(thetaDrawsCumulativeSqr - thetaDrawsCumulativeMean^2)
plot(1:nIter, thetaDrawsCumulativeStDev, type = "l", lwd = 2, xlab ="iteration", ylab = "posterior std")
lines(1:nIter,trueStd*rep(1,nIter), col = "red", lwd = 2)
legend(x = 'bottomright', inset = 0.05, legend = c("Cumulative", "True"), lwd = c(2,2), col = c("black","red"))

print(c(trueMean,trueStd))

#### Problem 1b
sum(thetaDraws < 0.4)/nIter
pbeta(0.4, shape1 = alphaPost, shape2 = betaPost)

#### Problem 1c
logOdds = log(thetaDraws/(1-thetaDraws))
hist(logOdds, 50)


#######################
###    Problem 2    ###
#######################

data = c(14, 25, 45, 25, 30, 33, 19, 50, 34, 67)
mu = 3.5
n = length(data)

### Problem 2a
LogScaledInvChi2 <- function(x, v, tau){
  (v/2)*log(tau^2*v/2) - lgamma(v/2) - (v*tau^2)/(2*x) - (1 + v/2)*log(x)
}
tau2 = sum((log(data)-mu)^2)/n
sigma2Draws = (n*tau2)/rchisq(n = 100000, df = n)
hist(sigma2Draws, 100, freq = F, xlim = c(0,2))
sigma2Vals = seq(0.01,2, length = 1000)
truePDF = exp(LogScaledInvChi2(x = sigma2Vals, v = n, tau = sqrt(tau2)))
lines(sigma2Vals, truePDF, col = "red", lwd = 2)

### Problem 2b
Gdraws = 2*pnorm(sqrt(sigma2Draws)/sqrt(2))-1
histObj = hist(Gdraws, 100, freq = F)


### Problem 2c

# Equal tail interval
equalTailInt = quantile(Gdraws, probs = c(0.025, 0.975))
print(equalTailInt)

equalTailInt = seq(equalTailInt[1], equalTailInt[2], length = 1000)
points(x = equalTailInt, y = rep(-0.25,length(equalTailInt)), col = plotColors[6], cex = 0.25)

# HPD
densObj = density(Gdraws, n = 1000)
normalizedDens <- densObj$y/sum(densObj$y)
densMat = cbind(densObj$x, normalizedDens)
densMat = densMat[order(densMat[,2]),]
insideHPD = which(cumsum(densMat[,2])>0.05)
c(min(densMat[insideHPD,1]),max(densMat[insideHPD,1]))
points(densMat[insideHPD,1], rep(0.25,length(insideHPD)), col = plotColors[2], cex = 0.25)

legend(x = "topright", legend = c("95% equal tail interval", "95% HPD interval"), 
       lwd = 2, col = c(plotColors[6],plotColors[2]))

#######################
###    Problem 3    ###
#######################

### Problem 3a

# The posterior (note that the likelihood is the PRODUCT over the data observations, because of independence)
posterior <- function(kappa,mu,x){prod(exp(kappa*cos(x-mu))/(2*pi*besselI(kappa, 0)))*exp(-kappa)}

# Data
windDirections <- c(0.6981317, 5.2883476, 5.6897734, 4.9741884, 5.1661746, 5.4803339, 0.3490659,
                    5.3756141, 5.2185345, 5.1661746) - pi

# Let's now loop over a grid of kappa values
kappaVals <- seq(0.01, 10, by = 0.01)
postDensValues <- matrix(0,length(kappaVals),1)
count <- 0
for (kappa in kappaVals){
  count <- count + 1
  postDensValues[count] <- posterior(kappa, mu = 2.39, x = windDirections)
}
# And plot the (unnormalized posterior density)
plot(kappaVals, postDensValues, type = "l", col = plotColors[2], lwd = 2, 
     xlab = expression(kappa), ylab = '(unnormalized) Posterior density')

### Problem 3b
postMode = kappaVals[which.max(postDensValues)]
points(postMode, 0, col = plotColors[6])
legend(x = "topright", legend = c("Posterior", "Posterior mode"), lwd = c(2,NA), pch = c(NA,1), col = c(plotColors[2],plotColors[6]))
print(postMode)
