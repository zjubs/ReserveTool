#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# example from: https://yihui.shinyapps.io/DT-selection/
# see also https://davidjhindley.com/shiny/claimsreserving/
library(shiny)
library(DT)
library(ChainLadder)
library(reshape2)

shinyServer(function(input, output, session) {
  
  checkWeights <- function(Triangle, weights = 1){
    # from chainladder package
    
    if(is.null(dim(weights))){
      if(length(weights)==1){
        my.weights <- Triangle
        my.weights[!is.na(Triangle)] <- weights
        weights <- my.weights
      }
    }
  }
  
  remove_weight<-function(edit,weights){
    weights[edit[1],edit[2]]<-0
    weights
  }
  
  edit_weights<-function(edit.list, weights){
    cat(file=stderr(), "editing","\n")
    res<-weights
    if(!is.null(edit.list)){
      for(i in 1:nrow(edit.list)){
        res<-remove_weight(edit.list[i,], res)
      }
    }
    res
  }
  
  
  tri = RAA
  orig_weights = checkWeights(tri,1)
  #new_weights = orig_weights
  n.origin = dim(tri)[1]
  
  df = dcast(as.data.frame(RAA), origin ~ dev)#iris[, 1:3]
  options(DT.options = list(pageLength = n.origin, searching = FALSE, lengthChange = FALSE))
  
  ata.df = ata(RAA)[1:n.origin-1,]
  
  output$x35 = DT::renderDataTable(
    df,
    server = FALSE,
    selection = list(target = 'cell', selected = cbind(
      c(1, 3, 4, 9), c(3, 2, 1, 2)
    ))
  )
  output$y35 = renderPrint(input$x35_cells_selected)

   output$x36 = DT::renderDataTable(
     round(ata.df,digits=4),
     server = FALSE,
     selection = list(target = 'cell', selected = cbind(
       c(1, 3, 4), c(3, 2, 1)
     ))
   )
   
   output$test1 = renderPrint(orig_weights)
   output$y36 = renderPrint({a <- input$x36_cells_selected
                            b<-"blah"
                            cat(file=stderr(), a,"\n")
                            cat(file=stderr(), a[1],"\n")
                            cat(file=stderr(), nrow(a))
                            new_weights<-edit_weights(a, orig_weights)
                            new_weights[3,7]<-0
                            new_weights})
   
   zeroweights<-reactive({input$x36_cells_selected})
   
   #define weight before applying chainladder
   #ata.weights
   

})
