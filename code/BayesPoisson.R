# Poisson for bugs data

# Reading data and explore it
setwd('/Users/matvi05/Dropbox/Teaching/BayesLearningSU/Code')
load('Bugs.RData')
table(x)
barplot(table(x), main = "Number of bugs per month")
mean(x)
var(x)
n = length(x)

# Posterior distribution for x1,...,xn  ~ Pois(theta) model
alpha_ = 20 # Prior is theta ~ Gamma(alpha_,beta_) 
beta_ = 20
thetaGrid = seq(0, 4, length = 1000) 
normLikelihood = dgamma(thetaGrid, sum(x), n) 
priorDens = dgamma(thetaGrid, alpha_, beta_)
postDens = dgamma(thetaGrid, alpha_ + sum(x), beta_ + n)

# Plotting 
maxY = max(normLikelihood,priorDens,postDens) # To set the plotting window
plot(thetaGrid, normLikelihood, type = "l", lwd = 3, ylim = c(0,maxY),
     xlab = expression(theta), ylab = "Density", col = "blue", 
     main = "Posterior for mean number of bugs")
lines(thetaGrid, priorDens, type = "l", lwd = 3, col = "green")
lines(thetaGrid, postDens, type = "l", lwd = 3, col = "red")

# Posterior mean
postMean = (alpha_ + sum(x))/(beta_ + n)

# Equal tail 95% credible interval
qgamma(p = c(0.025,0.975), alpha_ + sum(x), beta_ + n)

