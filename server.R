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
  
  source("chainLadderNew.R")
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
    #cat(file=stderr(), "editing","\n")
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
  options(DT.options = list(pageLength = n.origin, searching = FALSE,
                            lengthChange = FALSE, ordering=FALSE,
                            paging = FALSE, info = FALSE))
  
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
   new_weights<-reactive({edit_weights(input$x36_cells_selected, orig_weights)})
   new_weights2<-reactive({edit_weights(input$x36_cells_selected, orig_weights)[4,1]})
   
   
   #cat(file=stderr(), zeroweights(),"\n")
   output$test2 = renderPrint({cat(file=stderr(), "here","\n")
     cat(file=stderr(), new_weights(),"\n")
     new_weights()
     })
   #define weight before applying chainladder
   #ata.weights
   # fit new chainladder model
   # can I replace coefficients with user selected values
   user_chainladderfactors<-reactive({user_weights<-edit_weights(input$x36_cells_selected, orig_weights)
   #CL0<-chainladderNew(tri,user_weights)
   #sapply(CL0$Models, function(x) summary(x)$coef["x","Estimate"])
   f1<-function(CL0){
     sapply(CL0$Models, function(x) summary(x)$coef["x","Estimate"])
   }
   
   res1<-sapply(4:1,function(x) f1(chainladderNew(tri,user_weights, delta=1,origin.incl=x)))
   res2<-sapply(4:1,function(x) f1(chainladderNew(tri,user_weights, delta=0,origin.incl=x)))
   result<-rbind(t(res1),t(res2))
   rownames(result)<-c("weighted last 4", "weighted last 3","weighted last 2", "weighted last 1",
                       "simple last 4", "simple last 3", "simple last 2", "simple last 1")
   result
   })
   #output$y36 = renderPrint({user_chainladder()})
   output$y36 = DT::renderDataTable(
     DT::datatable(round(user_chainladderfactors(),digits=3),
     options = list(ordering=FALSE),
     selection ="single"
     )
   )
   
    output$ui <- renderUI({
      
      if (is.null(input$input_meth_manual))
    #is.null(input_meth_manual$input_type)
        return()
      
      r = input$y36_rows_selected
      selectedfactors<-t(as.matrix(user_chainladderfactors()[r,]))
      output$selected<- DT::renderDataTable(
        DT::datatable(round(selectedfactors,digits=3),
                      options = list(ordering=FALSE)
        )
      )
      output$manual<- DT::renderDataTable(
        DT::datatable(round(selectedfactors,digits=3),
                      options = list(ordering=FALSE),
                      editable = TRUE
        )
      )
      
      
      cat(file=stderr(), r,"\n")
      cat(file=stderr(), selectedfactors,"\n")
      switch(input$input_meth_manual,
           "selected" = DT::dataTableOutput("selected"),
           "manual" = DT::dataTableOutput("manual")
      )
      
      #proxy = dataTableProxy('manual')
      
      # observeEvent(input$ui, {
      #   info = input$ui_cell_edit
      #   str(info)
      #   i = info$row
      #   j = info$col
      #   v = info$value
      #   selected_factors[i, j] <<- DT::coerceValue(v, selected_factors[i, j])
      #   replaceData(proxy, selected_factors, resetPaging = FALSE)  # important
      # })
    })
    
    

   

})
