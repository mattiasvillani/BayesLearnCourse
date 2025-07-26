PostAndPredIIDNormalNonInfoPrior<-function(Sample,PopStd,Niter){

########################################################################################
#
# PURPOSE:	Sample from posterior and predictive distribution in the normal iid model
# 		with a non-informative (flat) prior. Population standard deviation is known.
#
# INPUT:	Sample	(n-by-1)	Vector with sample observations
#		PopStd	(scalar)	Standard deviation in the population
#		Niter   (scalar)	Number of draws from posterior and predictive distributions.
#
# OUTPUT:	(Niter-by-2) 		Matrix of draws. From posterior in first column. 
#					From predictive distribution in second column.
#
# AUTHOR:	Mattias Villani, Sveriges Riksbank and Stockholm University. 
#         	E-mail: mattias.villani@riksbank.se
#
# FIRST VER.:	2007-02-04
# THIS VER.:    2007-02-04 
#
##########################################################################################

# Initialization
PostSampleTheta=matrix(0,Niter,1)
PredSampleYtilde=matrix(0,Niter,1)

# Initial computations
n<-length(Sample)
SampleMean<-mean(Sample)                                     # ybar
SampleStd<-PopStd/sqrt(n)                                    # Sigma/sqrt(n)

for (i in 1:Niter){
  PostSampleTheta[i]=SampleMean+rnorm(1,0,1)*SampleStd       # Theta~N[ybar,Sigma/sqrt(n)]
  PredSampleYtilde[i]=PostSampleTheta[i]+rnorm(1,0,1)*PopStd # yhat~N(Theta,Sigma)
}

return(cbind(PostSampleTheta,PredSampleYtilde))
}