# Bayesian Learning - Computer labs solutions
# Mattias Villani and Måns Magnusson

setwd('~/Dropbox/Teaching/BayesLearning/Labs')


## LAB 1

# Problem 2
LogScaledInvChi2 <- function(x, v, tau){
  (v/2)*log(tau^2*v/2) - lgamma(v/2) - (v*tau^2)/(2*x) - (1 + v/2)*log(x)
}

# Problem 3
LogVonMisesPDF <- function(x, mu, kappa){
  kappa*cos(x-mu) - log(2*pi) - log(besselI(kappa, 0))
}

logPosterior <- function(kappa, x, mu){
  sum(LogVonMisesPDF(x,mu,kappa)) + dexp(kappa,rate=1,log = TRUE)
}

windDirections <- c(0.6981317, 5.2883476, 5.6897734, 4.9741884, 5.1661746, 5.4803339, 0.3490659,
                    5.3756141, 5.2185345, 5.1661746) - pi


kappaVals <- seq(0.01,10,by = 0.01)
logPosts <- matrix(0,length(kappaVals),1)
count <- 0
for (kappa in kappaVals){
  count <- count + 1
  logPosts[count] <- logPosterior(kappa, x = windDirections, mu = 2.39)
}
plot(kappaVals, exp(logPosts), type = "l")




## LAB 2

# Problem 1 - Regression
linData <- read.table(file = 'TempLinkoping2016.txt', header = T)
plot(linData$time, linData$temp, pch = 'o', cex = 0.5)
quadReg <- lm(temp ~ time + I(time^2) , data = linData)
lines(linData$time, quadReg$fitted.values, col = 'red')
cubicReg <- lm(temp ~ time + I(time^2) + I(time^3) , data = linData)
lines(linData$time, cubicReg$fitted.values, col = 'blue')
quarticReg <- lm(temp ~ time + I(time^2) + I(time^3) + I(time^4) , data = linData)
lines(linData$time, quarticReg$fitted.values, col = 'green')

# Problem 2 - Classification
workData <- read.table("WomenWork.dat", header = T)
glmModel <- glm(Work ~ 0 + ., data = workData, family = binomial)
