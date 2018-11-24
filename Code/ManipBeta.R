# Author: Mattias Villani, Statistics, Linkoping University, Sweden. e-mail: mattias.villani@liu.se

library(manipulate)

####################################################################
## Plotting the beta pdf
####################################################################

BetaPlot <- function(a,b){
  xGrid <- seq(0.001, 0.999, by=0.001)
  prior = dbeta(xGrid, a, b)
  maxDensity <- max(prior) # Use to make the y-axis high enough
  plot(xGrid, prior, type = 'l', lwd = 3, col = "blue", xlim <- c(0,1), ylim <- c(0, maxDensity), xlab = "theta", 
       ylab = 'Density', main = 'Beta(a,b) density')
}

manipulate(
  BetaPlot(a,b),
  a = slider(1, 10, step=1, initial = 2, label = "The hyperparameter a in Beta(a,b) density"),
  b = slider(1, 10, step=1, initial = 2, label = "The hyperparameter b in Beta(a,b) density")
  )