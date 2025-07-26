##########
# Compare Normal approximation of Beta posterior to the true posterior (MathExercise 3)
#
# Author: Per Siden
# Date: 2018-04-11
##########

# 3c
alpha = 1
beta = 1
n = 6
s = 1
f = n-s
normalMean = (alpha + s - 1)/(alpha+beta+n-2)
normalVar = (alpha + s - 1)*(beta + f - 1)/(alpha + beta + n - 2)^3

xgrid = seq(0,1,.001)
plot(xgrid,dbeta(xgrid,alpha+s,beta+f),type="l")
lines(xgrid,dnorm(xgrid,normalMean,sqrt(normalVar)),col=2)
legend("topright", box.lty = 1, legend = c("Beta posterior","Normal approx."), 
       col = c("black",'red'), lwd = 2)

# 3d
alpha = 1
beta = 1
n = 12
s = 2
f = n-s
normalMean = (alpha + s - 1)/(alpha+beta+n-2)
normalVar = (alpha + s - 1)*(beta + f - 1)/(alpha + beta + n - 2)^3

xgrid = seq(0,1,.001)
plot(xgrid,dbeta(xgrid,alpha+s,beta+f),type="l")
lines(xgrid,dnorm(xgrid,normalMean,sqrt(normalVar)),col=2)
legend("topright", box.lty = 1, legend = c("Beta posterior","Normal approx."), 
       col = c("black",'red'), lwd = 2)

