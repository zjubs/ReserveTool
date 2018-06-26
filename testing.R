library(ChainLadder)
setwd("/home/zjubs/Programming/ReservingShiny/Reserving")
source("chainLadderNew.R")
tri<-RAA

makeWeights <- function(Triangle, weights = 1){
  # from chainladder package
  
  if(is.null(dim(weights))){
    if(length(weights)==1){
      my.weights <- Triangle
      my.weights[!is.na(Triangle)] <- weights
      weights <- my.weights
    }
  }
}
a<-makeWeights(tri)
a["1989",1]<-0
CL0<-chainladderNew(tri,origin.incl=1, weights=a) # this uses error

CL1<-chainladderNew(tri,origin.incl=4) # no error
f1<-function(CL0){
  sapply(CL0$Models, function(x) summary(x)$coef["x","Estimate"])
}
#f2 is an atempt to fix error
f2<-function(CL0){
  # test for eror in model if error set to 1
  sapply(CL0$Models, f3)
}

f3<-function(x){
  #error handling to set factor to 1 if there is an error which arises if there are no dev factors
  # otherwise calc a dev factor as usual
  if(dim(summary(x)$coef)[1] == 0){1}else{
    summary(x)$coef["x","Estimate"]}
  
}
temp<-sapply(4:1,function(x) f1(chainladderNew(tri,origin.incl=x, weights=a)))

f2(CL0)
summary(CL0$Models[[1]])$coef["x","Estimate"]
temp
summary(CL0$Models[[1]])
