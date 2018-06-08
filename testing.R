library(ChainLadder)
setwd("/home/zjubs/Programming/ReservingShiny/Reserving")
source("chainLadderNew.R")
tri<-RAA

CL0<-chainladderNew(tri,origin.incl=4)
f1<-function(CL0){
  sapply(CL0$Models, function(x) summary(x)$coef["x","Estimate"])
}

temp<-sapply(4:1,function(x) f1(chainladderNew(tri,origin.incl=x)))

f1(CL0)

temp
