#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# example from : https://yihui.shinyapps.io/DT-selection/

library(shiny)
library(shinydashboard)
library(shinythemes)
library(DT)

header <- dashboardHeader(title = "Reserving Dashboard")

sidebar <- dashboardSidebar(disable=TRUE)

body <- dashboardBody(fluidPage
  (theme=shinytheme("cerulean")),
  navbarPage(
    
    title = 'Reserving Tool',
# todo: add a settings tab which will allow to select differnt triangles and other options    
#    source("ui_settings.R")$value,
    source("ui_chainladder.R")$value,
    source("ui_BF.R")$value
    
    
    

    
  )
)

ui <- dashboardPage(header, sidebar, body)

