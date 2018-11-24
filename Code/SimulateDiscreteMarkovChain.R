#####   BEGIN USER INPUT  #####
nIter <- 10000 # Number of simulated steps of the Markov chain
P = matrix(c(0.8,0.1,0.1,0.2,0.6,0.2,0.3,0.3,0.4),3,3, byrow=TRUE) # Define a transition matrix
#####   END USER INPUT    #####

# install.packages("expm") # To get the matrix power
library(expm)

lineColors = c("red","blue","green","black","yellow")
nStates <- dim(P)[1]
print(P)

# Stationary distribution is normalized left eigenvector of P corresponding to eigenvalue of one.
eigObj <- eigen(t(P))
eigenVect <- eigObj$vector[,eigObj$values == 1]
piStat <- eigenVect/sum(eigenVect)

print(piStat)
print(piStat - piStat%*%P) # Check 1: should be the zeros vector if piStat is the stationary distribution
print(P%^%100) # Check 2: each row should be approximately piStat

# Simulating a Markov chain
x <- matrix(NA,nIter,1)
x[1] <- 3 # Initial value
for (i in 2:nIter){
  x[i] <- sample(1:nStates,1, prob = P[x[i-1],])
}


# Graphics
print(x[1:50]) # Printing the first 50 simulations
approxStat <- list(nStates,1)
for (j in 1:nStates){
  approxStat[[j]] <- cumsum(x == j)/seq(1,nIter)
}

plot(0, type = "n", xlim = c(0,nIter), ylim = c(0,1), ylab = "Marginal probability", xlab = "Iteration number", lwd = 2)
legendText <- c()
for (j in 1:nStates){
  lines(1:nIter,approxStat[[j]], col = lineColors[j], lwd = 2)
  legendText <- c(legendText, paste('Cumulative mean - state',j), paste('True stationary - state',j))
  abline(piStat[j], 0, col = lineColors[j], lty = 2)
}
legend("topright", inset = 0.05, box.lty = 1, legend = legendText, col = rep(lineColors[1:nStates], each=2), 
       lty = rep(c(1,2),nStates), lwd = rep(c(2,1),nStates), cex = 0.5)

