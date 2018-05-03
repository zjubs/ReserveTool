#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# example from : https://yihui.shinyapps.io/DT-selection/

library(shiny)

navbarPage(
  
  title = 'DT Selection',
  

  tabPanel(
    'Cell',

    fluidRow(
      column(
        6, h1('Cumulative triangle'), hr(),
        DT::dataTableOutput('x35'),
        verbatimTextOutput('y35')
      )
    ),
    fluidRow(
      column(
        6, h1('Age to age factors'), hr(),
        DT::dataTableOutput('x36'),
        verbatimTextOutput('y36')
      )
    )
  )
  
)