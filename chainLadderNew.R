chainladderNew <- function(Triangle, weights=1,
                        delta=1,origin.incl){
  
  Triangle <- checkTriangle(Triangle)
  n <- dim(Triangle)[2]
  
  
  ## Mack uses alpha between 0 and 2 to distinguish
  ## alpha = 0 straight averages
  ## alpha = 1 historical chain ladder age-to-age factors
  ## alpha = 2 ordinary regression with intercept 0
  
  ## However, in Zehnwirth & Barnett they use the notation of delta, whereby delta = 2 - alpha
  ## the delta is than used in a linear modelling context.
  
  weights <- checkWeights(weights, Triangle)
  delta <- rep(delta,(n-1))[1:(n-1)]
  
  lmCL <- function(i, Triangle){
    lm(y~x+0, weights=weights[,i]/Triangle[,i]^delta[i],
       data=data.frame(x=Triangle[,i], y=Triangle[,i+1]))
  }
  ##
  f<-function(i, Triangle, origin.incl){
    a<-length(Triangle[,i])
    b<-min(a,origin.incl)
    d<-Triangle[(a-b+1-i):a,i]
    print(a-b+1-i)
    d
  }
  f(3,RAA,1)

  ##
  myModel <- lapply(c(1:(n-1)), lmCL, Triangle)
  
  output <- list(Models=myModel, Triangle=Triangle, delta=delta, weights=weights)
  class(output) <- c("ChainLadder", "TriangleModel", class(output))
  return(output)
}