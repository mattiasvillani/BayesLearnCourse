# Helper functions for splines

# Function that sets up the covariate matrix for the truncated polynomial (order p) spline basis
PolyTrunc <- function(x, nKnots = log(length(x)), knots = NA, p, standardizeX = TRUE, transConst = NA){
  
  sorted <- sort(x, index.return = T)
  x <- sorted$x
  
  # Standardize x
  if (standardizeX){
    if (is.na(transConst[1])){
      c0 <- mean(x)
      c1 <- sd(x)
    }else{
      c0 <- transConst[1]
      c1 <- transConst[2]
    }
  }else{
    c0 <- 0
    c1 <- 1
  }
  transConst <- c(c0,c1)
  x <- (x-c0)/c1
  
  if (is.na(knots[1])){
    quantiles <- seq(0.5/nKnots, 1-0.5/nKnots, length = nKnots)
    knots <- quantile(x,quantiles)
  }
  
  # Setting up the covariate matrix with original variables and the spline base
  n <- length(x)
  nKnots <- length(knots)
  X <- cbind(matrix(1,n),matrix(0,n,p+nKnots))
  for (j in 1:p){
    X[,j+1] <- x^j
  }
  for (i in 1:nKnots){
    idx <- (x>knots[i]) # logical index for the data points where x>knot
    X[idx,i+p+1] <- (x[idx]-knots[i])^p
  }
  X <- X[sorted$ix,]
 
  return(list(X=X,knots=knots, transConst = transConst))
}