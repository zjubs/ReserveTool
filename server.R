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
    
    if(is.null(dim(weights))){
      if(length(weights)==1){
        my.weights <- Triangle
        my.weights[!is.na(Triangle)] <- weights
        weights <- my.weights
      }
    }
  }
  
  edit_weight<-function(edit,weights){
    weights[edit[1],edit[2]]<-0
    weights
  }
  
  edit_weights<-function(edit.list, weights){
    res<-weights
    
    res<-edit_weight()
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
   output$y36 = renderPrint({a <- input$x36_cells_selected
                            b<-"blah"
                            new_weights = orig_weights
                            apply(temp,1,edit_weight)
                            new_weights[3,7]<-0
                            new_weights})
   
   zeroweights<-reactive({input$x36_cells_selected})
   
   #define weight before applying chainladder
   #ata.weights
   
  
  
  # output$x36 = DT::renderDataTable(
  #   df,
  #   selection = list(target = 'cell', selected = cbind(
  #     c(1, 3, 4, 9), c(3, 2, 1, 2)
  #   ))
  # )
  # output$y36 = renderPrint(input$x36_cells_selected)
  
  # # row+column selection
  # print_rows_cols = function(id) {
  #   cat('Rows selected:\n')
  #   print(input[[paste0(id, '_rows_selected')]])
  #   cat('Columns selected:\n')
  #   print(input[[paste0(id, '_columns_selected')]])
  # }
  # output$x41 = DT::renderDataTable(
  #   df, server = FALSE, selection = list(mode = 'single', target = 'row+column')
  # )
  # output$y41 = renderPrint(print_rows_cols('x41'))
  # 
  # output$x42 = DT::renderDataTable(
  #   df, server = FALSE, selection = list(target = 'row+column')
  # )
  # output$y42 = renderPrint(print_rows_cols('x42'))
  # 
  # output$x43 = DT::renderDataTable(
  #   df, selection = list(mode = 'single', target = 'row+column')
  # )
  # output$y43 = renderPrint(print_rows_cols('x43'))
  # 
  # output$x44 = DT::renderDataTable(df, selection = list(target = 'row+column'))
  # output$y44 = renderPrint(print_rows_cols('x44'))
  # 
  # output$x45 = DT::renderDataTable(
  #   df,
  #   server = FALSE,
  #   selection = list(target = 'row+column', selected = list(
  #     rows = c(1, 3, 4, 9), cols = c(3, 2)
  #   ))
  # )
  # output$y45 = renderPrint(print_rows_cols('x45'))
  # 
  # output$x46 = DT::renderDataTable(
  #   df,
  #   selection = list(target = 'row+column', selected = list(
  #     rows = c(1, 3, 4, 9), cols = c(3, 2)
  #   ))
  # )
  # output$y46 = renderPrint(print_rows_cols('x46'))
  # 
  # sketch = htmltools::withTags(table(
  #   class = 'display',
  #   thead(
  #     tr(
  #       th(rowspan = 2, ''),
  #       th(rowspan = 2, 'Species'),
  #       th(colspan = 2, 'Sepal'),
  #       th(colspan = 2, 'Petal')
  #     ),
  #     tr(
  #       lapply(rep(c('Length', 'Width'), 2), th)
  #     )
  #   ),
  #   tfoot(
  #     tr(
  #       th(rowspan = 2, ''),
  #       th(rowspan = 2, 'Species'),
  #       lapply(rep(c('Length', 'Width'), 2), th)
  #     ),
  #     tr(
  #       th(colspan = 2, 'Sepal'),
  #       th(colspan = 2, 'Petal')
  #     )
  #   )
  # ))
  # output$x47 = DT::renderDataTable(
  #   iris, container = sketch, server = FALSE,
  #   selection = list(target = 'row+column')
  # )
  # output$y47 = renderPrint(print_rows_cols('x47'))
  # 
  # output$x48 = DT::renderDataTable(
  #   iris, container = sketch,
  #   selection = list(target = 'row+column')
  # )
  # output$y48 = renderPrint(print_rows_cols('x48'))
  # 
  # # disable selection
  # output$x51 = DT::renderDataTable(df, server = FALSE, selection = 'none')
  # output$x52 = DT::renderDataTable(df, selection = 'none')
  
})