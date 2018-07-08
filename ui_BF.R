
tabPanel(
  'BF',
  fluidRow(
    column(
      6, h1('BF Method'), hr(),
      'This applies the BF method to the results from the chain ladder method calculated in the previous tab.',
      'Enter prior ultimate values into prior column'
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
  )
  #verbatimTextOutput('test2')
  
)