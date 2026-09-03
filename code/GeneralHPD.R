# By Oskar Gustafsson.
# This script introduces a function for computing highest posterior density 
# regions for samples from an arbitrary potentially multimodal univariate 
# distribution. It also give an example with a mixture of two normal 
# distributions were we get disjoint intervals.



# Make a general function for computing highest posterior density regions for
# samples from an arbitrary potentially multimodal univariate distribution.
computeHPDGeneral <- function(samples, prob = 0.95) {
  # 1. Estimate the posterior density
  dens <- density(samples)
  
  # 2. Sort the density values in descending order
  sortedDens_y <- sort(dens$y, decreasing = TRUE)
  
  # 3. Find the density threshold (height)
  mass <- cumsum(sortedDens_y) / sum(sortedDens_y)
  heightIndex <- which.max(mass >= prob)
  heightThreshold <- sortedDens_y[heightIndex]
  
  # 4. Identify all regions where the density is above the threshold
  aboveThresholdIndices <- which(dens$y >= heightThreshold)
  
  # Find the start and end points of the contiguous intervals
  # A jump in the indices indicates a new interval
  jumps <- which(diff(aboveThresholdIndices) > 1)
  
  starts <- c(aboveThresholdIndices[1], aboveThresholdIndices[jumps + 1])
  ends <- c(aboveThresholdIndices[jumps], aboveThresholdIndices[length(aboveThresholdIndices)])
  
  # 5. Create the HPD intervals using the x-values from the density object
  hpdIntervals <- data.frame(
    lower = dens$x[starts],
    upper = dens$x[ends]
  )
  
  return(list(Intervals = hpdIntervals, Densities=dens))
}


# Create a function for sampling from a mixture of two normal distributions:
randBiModal <- function(compProb, mu, sigma, n){
  randNumb <- rep(NA,n)
  for(i in 1:n){
    randNumb[i] <- ifelse(rnorm(1) < 0., rnorm(1,mu[1],sigma[1]), rnorm(1,mu[2],sigma[2]))
  }
  return(randNumb)
}

# You can select your own settings! 
mu <- c(-2,5)      # vector of means.
sigma <- c(1.2, 2) # vector of standard deviations.
compProb <- 0.3    # mixing probability of component 1.

# Draw random numbers and make histogram.
bimod <- randBiModal(0.3, mu, sigma, 10000)
hist(bimod, 100)

# Select a coverage rate and compute corresponding H(P)D regions of the sample.
covRate <- 0.8

# Compute the intervals with our function.
HPDStuff <- computeHPDGeneral(bimod, prob = covRate)

# You can print this to verify it found two intervals for my settings!
print(HPDStuff$Intervals)


# Set up the empty plot
plot(HPDStuff$Densities,
     main = paste0("Posterior Density with ", covRate, "% HPD Region"),
     xlab = "Parameter Value",
     ylab = "Density",
     type = "n") # 'n' for no plotting yet

# Loop through each found interval to draw its polygon and lines.
for (i in 1:nrow(HPDStuff$Intervals)) {
  # Get the lower and upper bounds for the current interval
  lower <- HPDStuff$Intervals$lower[i]
  upper <- HPDStuff$Intervals$upper[i]
  
  # Find the indices of the density curve inside this interval
  hpdIndices <- which(HPDStuff$Densities$x >= lower & HPDStuff$Densities$x <= upper)
  
  # Define coordinates for the polygon
  x_coords <- c(lower, HPDStuff$Densities$x[hpdIndices], upper)
  y_coords <- c(0, HPDStuff$Densities$y[hpdIndices], 0)
  
  # Draw the shaded polygon
  polygon(x_coords, y_coords, col = rgb(0.0, 0.45, 0.1, alpha = 0.15))
  
  # Mark the boundaries for this interval
  abline(v = c(lower, upper), col = "darkred", lty = 2, lwd = 2)
}

# Draw the main density line on top of everything
lines(HPDStuff$Densities, col = "darkblue", lwd = 3)

# Add a legend
legend("topright",
       legend = c("Posterior Density", paste0(covRate*100, "% HPD Region")),
       col = c("darkblue", "darkred"),
       lwd = c(3, 2),
       lty = c(1, 2), # Use line type to distinguish
       bty = "n")










