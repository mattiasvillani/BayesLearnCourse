# Using the coda library to compute the effective sample size
# Author: Per Siden

library(coda)

x = rnorm(1000)
y = x
for(i in 2:1000){
  y[i] = .9*y[i-1] + x[i]
}
effectiveSize(x)
effectiveSize(y)
