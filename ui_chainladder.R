

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
          6, h1('Triangle Age To Age Factors'), hr(),
          "Highlight cells to exclude factor from projection",
          DT::dataTableOutput('x36'),
          #verbatimTextOutput('test1'),
          h1('Calculated Age To Age Factors'), hr(),
          "Select factors to use for projecting the triangle.",
          "Alternatively input factors manually below and change selection method to manual.",
          DT::dataTableOutput('y36'),
          #verbatimTextOutput('test2'),
          # wellPanel(width = 3,
          #   selectInput("input_meth_manual", "Method",
          #               c("selected", "manual")
          #               )
          #   ),
          DTOutput('x1'),
          wellPanel(width = 3,
                       selectInput("input_meth_manual", "Selection Method",
                                   c("selected", "manual")
                                   )
                       )
          #verbatimTextOutput('test1')
          #uiOutput('ui')
        )

      )
      
    ),
    tabPanel(
      'Results',
      fluidRow(
        column(
          6, h1('Chain ladder results'), hr(),
          DT::dataTableOutput('chainladder_result')
          #verbatimTextOutput('y35')
        )
      )

    ),
    tabPanel(
      'Graphs',
      plotOutput('plotDev'),
      plotOutput('plotAnalysis')
      
    )
    
  )
  
  
)
