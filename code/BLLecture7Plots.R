
# Loading pretty plot settings
source('~/Dropbox/CodeSnippets/PlotSettingsR.R')

# Simulating an AR(1) process to emulate the output of an MCMC chain
N = 2000
sigma = 1
mu = 2
rho = 0.98
x = matrix(rep(0,N))
for (i in 2:N){
  x[i] = mu + rho*(x[i-1]-mu) + sigma*rnorm(1)
}
TrueMean = mu
TrueStd = sigma/sqrt(1-rho^2)
TrueTailsProb = pnorm(7, mean = TrueMean, sd = TrueStd, lower.tail = F)
  
# Posterior mean estimate
minRaw = floor(min(x))
maxRaw = ceiling(max(x))
png('meanMCMC.png')
par(cex.lab=cexLabDef, cex.axis = cexAxisDef)
plot(1:N, x, type = "l", col = plotColors[2], ylab=TeX('$\\theta$'), 
     lwd = lwdThinner, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,N), ylim = c(minRaw, maxRaw), 
     main = 'Posterior mean')
lines(1:N, cumsum(x)/(1:N), type = "l", col = plotColors[6], lwd = lwdThin)
lines(1:N, TrueMean*rep(1,N), col = plotColors[4], lwd = lwdThinner)
axis(side = 1, at = seq(0, N, by = 500))
axis(side = 2, at = seq(minRaw, maxRaw, length = 5))

legend(x = "topright", inset=.05, 
       legend = c("Raw", "Cumul", "True"), 
       cex = c(1.5, 1.5, 1.5),
       lwd = c(lwdThinner,lwdThinner,lwdThinner),
       lty=c(1, 1, 1),
       col = c(plotColors[2], plotColors[6], plotColors[4])
)
dev.off()


# Posterior std estimate
minRaw = floor(min(x))
maxRaw = ceiling(max(x))
png('stdMCMC.png')
par(cex.lab=cexLabDef, cex.axis = cexAxisDef)
plot(1:N, x, type = "l", col = plotColors[2], ylab=TeX('$\\theta$'), 
     lwd = lwdThinner, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,N), ylim = c(minRaw, maxRaw), 
     main = 'Posterior stdev')
lines(1:N, sqrt(cumsum(x^2)/(1:N)-(cumsum(x)/(1:N))^2), type = "l", col = plotColors[6], lwd = lwdThinner)
lines(1:N, TrueStd*rep(1,N), col = plotColors[4], lwd = lwdThinner)
axis(side = 1, at = seq(0, N, by = 500))
axis(side = 2, at = seq(minRaw, maxRaw, length = 5 ))

legend(x = "topright", inset=.05, 
       legend = c("Raw", "Cumul", "True"), 
       cex = c(1.5, 1.5, 1.5),
       lwd = c(lwdThinner,lwdThinner,lwdThinner),
       lty=c(1, 1, 1),
       col = c(plotColors[2], plotColors[6], plotColors[4])
       )

dev.off()


# Tail estimate
minRaw = floor(min(x))
maxRaw = ceiling(max(x))
png('tailsProbMCMC.png')
par(cex.lab=cexLabDef, cex.axis = cexAxisDef)
plot(1:N, x>5, type = "p", col = plotColors[2], ylab=TeX('$\\theta$>7'), 
     lwd = 1, axes=FALSE, xlab = 'MCMC iteration', xlim = c(0,N), ylim = c(0, 1), 
     main = 'Posterior tail probability')
lines(1:N, cumsum(x>7)/(1:N), type = "l", col = plotColors[6], lwd = lwdThin)
lines(1:N, TrueTailsProb*rep(1,N), col = plotColors[4], lwd = lwdThinner)
axis(side = 1, at = seq(0, N, by = 500))
axis(side = 2, at = seq(0, 1, length = 5))

legend(x = "topright", inset=.05, 
       legend = c("Raw", "Cumul", "True"), 
       cex = c(1.5, 1.5, 1.5),
       lwd = c(lwdThinner,lwdThinner,lwdThinner),
       lty=c(1, 1, 1),
       col = c(plotColors[2], plotColors[6], plotColors[4])
)
dev.off()

nIters = c(500,1000,1500,2000)
png('seqDensMCMC.png')
par(cex.lab=cexLabDef, cex.axis = cexAxisDef)
par(mfrow=c(2,2))
thetaGrid = seq(TrueMean-4*TrueStd, TrueMean+4*TrueStd, length = 1000)
minTheta = floor(min(thetaGrid)) 
maxTheta = ceiling(max(thetaGrid))
TruePostDens = dnorm(thetaGrid,mean = TrueMean, sd = TrueStd)

for (nIter in nIters){
  hist(x[1:nIter],30, freq = F, axes = FALSE, xlim = c(minTheta, maxTheta), 
       main = paste('nSim = ',nIter), ylab = "", xlab = TeX('$\\theta$'), 
       col = plotColors[3])
  lines(thetaGrid,TruePostDens, col = plotColors[6], lwd = lwdThinner)
  axis(side = 1, at = seq(minTheta, maxTheta, by = 5))
}

dev.off()
