#################################################################################################
#################  Example of conjugate prior inference of the multinomial model ################ 
#################################################################################################
 
####### Defining a function that simulates from a Dirichlet distribution
SimDirichlet <- function(nIter,param){
	nCat <- length(param)
	thetaDraws <- matrix(0,nIter,nCat) # Matrix where the posterior draws are stored
	for (j in 1:nCat){
		thetaDraws[,j] <- rgamma(nIter,param[j],1)
	}
	for (i in 1:nIter){
		thetaDraws[i,] = thetaDraws[i,]/sum(thetaDraws[i,]) # Diving every column of ThetaDraws by the sum of the elements in that column.
	}
	return(thetaDraws)
}

###########   Setting up data and prior  #################
y <- c(36,87,77) # Data
alpha <- c(1,1,1) # Dirichlet prior hyperparameters
nIter <- 10000 # Number of posterior draws

###########   Posterior sampling from Dirichlet  #################
thetaDraws <- SimDirichlet(nIter,y + alpha)

################ Computing Summary statistics from the posterior sample ###################
mean(thetaDraws[,1])
mean(thetaDraws[,2])
mean(thetaDraws[,3])

sqrt(var(thetaDraws[,1]))
sqrt(var(thetaDraws[,2]))
sqrt(var(thetaDraws[,3]))

sum(thetaDraws[,2]>thetaDraws[,3])/nIter # p(theta2>theta3|Data)

# Plots histograms of the posterior draws
plot.new() # Opens a new graphical window
par(mfrow = c(2,2)) # Splits the graphical window in four parts (2-by-2 structure)
hist(thetaDraws[,1],25) # Plots the histogram of theta[,1] in the upper left subgraph
hist(thetaDraws[,2],25)
hist(thetaDraws[,3],25)

