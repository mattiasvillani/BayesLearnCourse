NormalNonInfoPrior<-function(NDraws,Data){

#####################################################################################
# PURPOSE: 	Generates samples from the joint posterior distribution of the parameters in the
#
#		MODEL: x1,....xn iid Normal(mu,sigma^2) model. 
#		PRIOR: p(mu,sigma^2) propto 1/sigma^2				
#
#
# INPUT:	NDraw: 		(Scalar)	The number of posterior draws
#		Data:		(n-by-1)	Data vector of n observations
#				
# OUTPUT:	PostDraws:	(NDraws-by-2)	Matrix of posterior draws. 
#						First column holds draws of mu		
#						Second column holds draws of sigma^2
#
# AUTHOR:	Mattias Villani, Sveriges Riksbank and Stockholm University.
#		E-mail: mattias.villani@riksbank.se.
#
# DATE:		2005-04-13
#
######################################################################################


Datamean<-mean(Data)
s2<-var(Data)
n<-length(Data)
PostDraws=matrix(0,NDraws,2)
PostDraws[,2]<-((n-1)*s2)/rchisq(NDraws,n-1)
PostDraws[,1]<-Datamean+rnorm(NDraws,0,1)*sqrt(PostDraws[,2]/n)

return(PostDraws)
}

Data<-rnorm(100,5,10) 			# Sampling 100 observations from the N(5,10) density##
PostDraws<-NormalNonInfoPrior(1000,Data) # Generating 1000 draws from the joint posterior density of mu and sigma^2
hist(PostDraws[,1]) 			# Plotting the histogram of mu-draws
