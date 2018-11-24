###################################################################################
# Author: Mattias Villani, Sveriges Riksbank and Stockholm University. 
#         E-mail: mattias.villani@gmail.se
# Script to illustrate numerical maximization of the Logistic or Probit regression
###################################################################################

###########   BEGIN USER INPUTS   ################
Probit <- 0 # If Probit <-0, then logistic model is used.
chooseCov <- 1:16 # Here we choose which covariates to include in the model
tau <- 10; # Prior scaling factor such that Prior Covariance = (tau^2)*I
###########     END USER INPUT    ################


# install.packages("mvtnorm") # Loading a package that contains the multivariate normal pdf
library("mvtnorm") # This command reads the mvtnorm package into R's memory. NOW we can use dmvnorm function.

# Loading data from file
Data<-read.table("/home/mv/Dropbox/Teaching/BayesLearning/HT2013/Code/SpamReduced.dat",header=TRUE)  # Spam data from Hastie et al.
y <- as.vector(Data[,1]); # Data from the read.table function is a data frame. Let's convert y and X to vector and matrix.
X <- as.matrix(Data[,2:17]);
covNames <- names(Data)[2:length(names(Data))];
X <- X[,chooseCov]; # Here we pick out the chosen covariates.
covNames <- covNames[chooseCov];
nPara <- dim(X)[2];

# Setting up the prior
mu <- as.vector(rep(0,nPara)) # Prior mean vector
Sigma <- tau^2*diag(nPara);

# Defining the functions that returns the log posterior (Logistic and Probit models). Note that the first input argument of
# this function must be the one that we optimize on, i.e. the regression coefficients.

LogPostLogistic <- function(betaVect,y,X,mu,Sigma){
  nPara <- length(betaVect);
  linPred <- X%*%betaVect;                                
  logLik <- sum( linPred*y -log(1 + exp(linPred)));
  logPrior <- dmvnorm(betaVect, matrix(0,nPara,1), Sigma, log=TRUE);
  return(logLik + logPrior)
}

# Calling the optimization routine Optim. Note the auxilliary arguments that are passed to the function logPost
# Note how I pass all other arguments of the function logPost (i.e. all arguments except betaVect which is the one that we are trying to optimize over) to the R optimizer.
# The argument control is a list of options to the optimizer. Here I am telling the optimizer to multiply the objective function (i.e. logPost) by -1. This is because
# Optim finds a minimum, and I want to find a maximum. By reversing the sign of logPost I can use Optim for my maximization problem.
initVal <- as.vector(solve(crossprod(X,X))%*%t(X)%*%y); # Initial values by OLS
OptimResults<-optim(initVal,LogPostLogistic,gr=NULL,y,X,mu,Sigma,method=c("BFGS"),control=list(fnscale=-1),hessian=TRUE)

postMode <- OptimResults$par
approxPostStd <- sqrt(diag(-solve(OptimResults$hessian)))

# Printing the results to the screen
names(postMode) <- covNames # Naming the coefficient by covariates
names(approxPostStd) <- covNames # Naming the coefficient by covariates
print('The posterior mode is:')
print(postMode)
print('The approximate posterior standard deviation is:')
print(approxPostStd)

# Plotting the marginal posterior of the first beta
paramGrid <- seq(0,1,length=1000)
plot(paramGrid,dnorm(paramGrid,mean = postMode[1], sd = approxPostStd[1]), type = "l", ylab = "marginal posterior", xlab = paste("beta_",covNames[1]))