# install package where the data is
install.packages("carData")
library(carData)
library(mvtnorm)

# Load the data and set up covariate matrix X
data(Salaries)
head(Salaries)
attach(Salaries)
phdage = yrs.since.phd / max(yrs.since.phd)
phdagesqr = phdage^2
rank2 = (rank == "AssocProf")
rank3 = (rank == "Prof")
discipline = (Salaries$discipline == "A")
intercept = rep(1,length(phdage))
X = cbind(intercept, phdage, phdagesqr, rank2, rank3, sex, discipline)
y = log(salary)
p = dim(X)[2]
head(X)

# Least squares/MLE estimate betaHat - to warm up
lmfit = lm(y ~ 0 + X) # 0 + since we already have the intercept in X
n = length(y)
k = dim(X)[2] # number of covariates, including the intercept
s2 = sum(lmfit$residuals^2)/(n-k) # residual variance estimate

XX = crossprod(X) # this does X'*X, i.e same as t(X)%*%X
betaHat = solve(XX) %*% t(X) %*% y
covBetaHat = s2*solve(XX)      # this is s2*(X'X)^-1, the frequentist covariance of betaHat
sqrt(diag(covBetaHat))         # standard errors of betaHat

# Prior beta
mu0 = c(log(70000), 2, -1.5, 0, 0, 0, 0)
kappa0 = 50# 397
I1 = (1/n)*XX      # This is the information from one, "typical" observation
Omega0 = kappa0*I1 # Prior is equivalent to kappa0 observations

# Prior sigma2
nu0 = 10
sigma20 = 0.3^2

# Posterior
Omegan = XX + Omega0
mun = solve(Omegan) %*% (XX %*% betaHat + Omega0 %*% mu0)
nun = nu0 + n
sigma2n = (nu0*sigma20 + crossprod(y) + crossprod(mu0, Omega0 %*% mu0)  - 
             crossprod(mun, Omegan %*% mun) )/nun
sigma2n = as.numeric(sigma2n)

# Simulate from posterior
rscaledinvchi2 <- function(n, nu, tau2){
  chi2 = rchisq(n, nu)
  return (nu*tau2/chi2)
}
nSim = 10000
sigma2Draws = rscaledinvchi2(nSim, nun, sigma2n)
betaDraws = matrix(rep(0, nSim*p), nSim, p)
invOmegan = solve(Omegan)
for (i in 1:nSim){
  betaDraws[i, ] = rmvnorm(1, mun, sigma2Draws[i]*invOmegan)
}

hist(betaDraws[,2], 50, main =  colnames(X)[2])
hist(betaDraws[,4], 50, main =  colnames(X)[4])
hist(betaDraws[,5], 50, main =  colnames(X)[5])
hist(betaDraws[,6], 50, main =  colnames(X)[6])


