

tabPanel(
  'Chain Ladder',
  
  tabBox(
    tabPanel(
      'Triangles',
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
          verbatimTextOutput('test1'),
          verbatimTextOutput('y36')
        )
      )
    ),
    tabPanel(
      'Results'
    ),
    tabPanel(
      'Graphs'
    )
    
  )
  
  
)
