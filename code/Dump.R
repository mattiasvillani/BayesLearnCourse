# Bivariate density estimator
#install.packages("ks") # bivariate kernel density estimates
par(mfrow=c(1,2))
library(ks)
Hpi1 <- Hscv(x = directDraws)
fEst <- kde(x = directDraws, H=Hpi1)
plot(fEst)
evalPoints <- t(rbind(fEst$eval.points[[1]],fEst$eval.points[[1]])) # Finding the points where the density estimate was evaluated in the plot

# Trick to compute the true density
bivariate <- function(x,y){
  return (dmvnorm(c(x,y), mean = mu, sigma = Sigma))
}
trueDensity <- outer(evalPoints[,1],evalPoints[,2],bivariate)
contour(evalPoints[,1], evalPoints[,2], trueDensity, theta = 55, phi = 30, r = 40, d = 0.1, expand = 0.5,
        ltheta = 90, lphi = 180, shade = 0.4, ticktype = "detailed", nticks=5)