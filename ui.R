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

header <- dashboardHeader(title = "My Dashboard")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(fluidPage
  (theme=shinytheme("cerulean")),
  navbarPage(
    
    title = 'Reserving Tool',
    source("ui_settings.R")$value,
    source("ui_chainladder.R")$value,
    source("ui_BF.R")$value
    
    
    

    
  )
)

ui <- dashboardPage(header, sidebar, body)

