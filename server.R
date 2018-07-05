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
    cat(file=stderr(), "removing","\n")
    weights[edit[1],edit[2]]<-0
    #cat(file=stderr(), weights,"\n")
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
    #cat(file=stderr(), res,"\n")
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
    selection="none"
  )
  output$y35 = renderPrint(input$x35_cells_selected)

   output$x36 = DT::renderDataTable(
     round(ata.df,digits=4),
     server = FALSE,
     selection = list(target = 'cell', selected = cbind(
       c(1, 3, 4), c(3, 2, 1)
     ))
   )
   
   #output$test1 = renderPrint(orig_weights)
   new_weights<-reactive({edit_weights(input$x36_cells_selected, orig_weights)})
   new_weights2<-reactive({edit_weights(input$x36_cells_selected, orig_weights)[4,1]})
   
   
   #cat(file=stderr(), zeroweights(),"\n")
   output$test2 = renderPrint({cat(file=stderr(), "here","\n")
     #cat(file=stderr(), new_weights(),"\n")
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
     sapply(CL0$Models,f2)
   }
   
   f2<-function(x){
     #error handling to set factor to 1 if there is an error which arises if there are no dev factors
     # otherwise calc a dev factor as usual
     a<-if(dim(summary(x)$coef)[1] == 0){1}else{
       summary(x)$coef["x","Estimate"]}
     #cat(file=stderr(), a,"\n")
     a
    }
   
   res1<-f1(chainladderNew(tri,user_weights, delta=1))
   res2<-sapply(4:1,function(x) f1(chainladderNew(tri,user_weights, delta=1,origin.incl=x)))
   res3<-f1(chainladderNew(tri,user_weights, delta=0))
   res4<-sapply(4:1,function(x) f1(chainladderNew(tri,user_weights, delta=0,origin.incl=x)))
   result<-rbind(t(res1),t(res2),t(res3),t(res4))
   rownames(result)<-c("weighted all","weighted last 4", "weighted last 3","weighted last 2", "weighted last 1",
                       "simple all","simple last 4", "simple last 3","simple last 2", "simple last 1")
   result
   })
   #output$y36 = renderPrint({user_chainladder()})
   output$y36 = DT::renderDataTable(
     DT::datatable(round(user_chainladderfactors(),digits=3),
     options = list(ordering=FALSE),
     #selection ="single",
     selection = list(target = 'row', mode = 'single', selected = c(1)
     ))
    )
   
   
   # The next section allows users to input manual dev factors or select from
   # pre defined approaches
   
   #prepare manual input
   prep_user_input<-as.data.frame(t(rep(1,n.origin-1)))
   rownames(prep_user_input)<-"manual"
   
   
   y <- reactive({
     # this gives us the manual factor
     input$x1_cell_edit
     cat(file=stderr(), "hello","\n")
     unlist(prep_user_input)
   })
   
   
   output$x1 = renderDT(prep_user_input, selection = "none", editable = T)
   
   proxy = dataTableProxy('x1')
   
   observeEvent(input$x1_cell_edit, {
     info = input$x1_cell_edit
     cat(file=stderr(), "hello1","\n")
     str(info)
     i = info$row
     j = info$col
     v = info$value
     prep_user_input[i, j] <<- DT::coerceValue(v, prep_user_input[i, j])
     replaceData(proxy, prep_user_input, resetPaging = FALSE)  # important
   })
   
   
   blah<-reactive({
     zz =input$y36_rows_selected
     cat(file=stderr(), zz,"\n")
     user_chainladderfactors()[zz,]
   })
   

   #output$test1 = output$test1 = renderPrint(y()) #renderPrint({blah()})
   

   prep_results<-reactive({

     ddd<-switch(input$input_meth_manual,
                    "selected" = blah(),
                    "manual" = y()
               )
     ddd<-c(ddd,1) # assume no tail for now. Add in tail factors later
     LDF<-rev(cumprod(rev(ddd)))
     currentEval<-getLatestCumulative(tri)
     EstdUlt<-currentEval* rev(LDF)
     Reserve<- EstdUlt - currentEval
     Exhibit <- data.frame(latestIncurred=currentEval, LDF = round(rev(LDF), 3), EstdUlt=round(EstdUlt), Reserve=round(Reserve))
     Exhibit <- rbind(Exhibit,
                      data.frame(latestIncurred=round(sum(currentEval)), LDF=NA, EstdUlt=round(sum(EstdUlt)), Reserve = round(sum(Reserve)),
                                 row.names = "Total"))
     Exhibit
   })
   
   output$test1 = renderPrint({prep_results()})
   
   output$chainladder_result = DT::renderDataTable(
     DT::datatable(prep_results(),
                   options = list(ordering=FALSE),
                   selection ="none"
     )
     
   )
   
   # use MackChainLadde function in chain ladder library to produce graphs
   mack <- MackChainLadder(tri, est.sigma="Mack")
   output$plotDev<- renderPlot({plot(mack, lattice = TRUE)})
    output$plotAnalysis<- renderPlot({plot(mack)})
   

})
