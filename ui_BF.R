
tabPanel(
  'BF',
  fluidRow(
    column(
      6, h1('BF Method'), hr(),
    'Enter prior values into prior column'
    )
  ),
  fluidRow(
    column(
      6, #h1('Client-side / Single selection'), hr(),
      DT::dataTableOutput('BF')
      
    ),
    column(
      2, #h1('Prior selection'), hr(),
      DT::dataTableOutput('BFprior')
     ),
     column(
       2, #h1('Prior selection'), hr(),
       DT::dataTableOutput('BFult')
     )
  ),
  verbatimTextOutput('test2')
  
)