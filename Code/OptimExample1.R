# Author: Mattias Villani, Sveriges Riksbank and Stockholm University. 
#         E-mail: mattias.villani@riksbank.se

# Script to illustrate numerical maximization of the function 
# f(x,y)=(x-a)^2+a*y^2-2*x*sin(y). Note that the above expression is really
# a function of x,y and a, but I write as f(x,y) since I will maximize 
# with respect to x and y for a given a.

# First define the function f. Note that the minimization routine in R
# forces us to group all the variables which we intended to maximize
# with respect to in a vector z=(x,y), so that x=z[1] and y=z[2].

f<-function(z,a){
t=(z[1]-a)^2+a*z[2]^2-2*z[1]*sin(z[2])
return(t)
}

# Initial values of z
Init=c(5,-4)

# Calling the optimization routine. Note the argument a=3
OptimResults<-optim(Init,f,hessian=TRUE,a=3)
XOpt=OptimResults$par[1] # x-value at the optimum
YOpt=OptimResults$par[2] # y-value at the optimum

# Evaluate the function over two grids (one for x and one for y) 
# to see if we indeed have a maximum
XGrid=seq(2,5,0.1)
YGrid=seq(0.5,1.5,0.1)
FunctionXGrid=matrix(NA,length(XGrid))
FunctionYGrid=matrix(NA,length(YGrid))
a=3

XCount=0;
# Evaluating the function f(x,y) over The x-grid, with y kept fixed at YOpt
for (x in XGrid){
	XCount=XCount+1;
	FunctionXGrid[XCount]=f(c(x,YOpt),a)
}

YCount=0;
# Evaluating the function f(x,y) over The y-grid, with x kept fixed at XOpt
for (y in YGrid){
	YCount=YCount+1;
	FunctionYGrid[YCount]=f(c(XOpt,y),a)
}

# Plotting the perturbated function
par(mfrow=c(1,2)) # Opens a graphic windows consisting of two subplots which
			# are filled row by row
plot(XGrid,FunctionXGrid,type='l') # The extra argument type='l' makes it a line plot 
title('Function over the x-grid for y=YOpt')
plot(YGrid,FunctionYGrid,type='l')
title('Function over the y-grid for x=XOpt')