# Solutions lab 2
setwd('/home/mv/Dropbox/Teaching/BayesLearn2012/Labs/')
japanTemp <- read.table('/home/mv/Dropbox/Teaching/BayesLearn2012/Labs/JapanTemp.dat', header = TRUE)

quadReg <- lm(temp ~ time + I(time^2) + I(time^3) + I(time^4) + I(time^5) + I(time^6) + I(time^7) , data = japanTemp)

