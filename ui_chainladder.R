

tabPanel(
  'Chain Ladder',
  
  tabBox(width = 12,
    tabPanel(
      'Triangles',
      fluidRow(
        column(
          6, h1('Cumulative triangle'), hr(),
          DT::dataTableOutput('x35')
          #verbatimTextOutput('y35')
        )
      ),
      fluidRow(
        column(
          6, h1('Age to age factors'), hr(),
          DT::dataTableOutput('x36'),
          #verbatimTextOutput('test1'),
          DT::dataTableOutput('y36'),
          #verbatimTextOutput('test2'),
          wellPanel(width = 3,
            selectInput("input_meth_manual", "Method",
                        c("selected", "manual")
                        )
            ),
          uiOutput('ui')
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
