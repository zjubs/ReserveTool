
tabPanel(
  'Settings',
  # use this page for global settings for example which sets of results to display for triangles
  fluidRow(
    column(
      6, h1('Cumulative triangle'), hr()#,
      #DT::dataTableOutput('x35'),
      #verbatimTextOutput('y35')
    )
  ),
  fluidRow(
    column(
      6, h1('Age to age factors'), hr()#,
      #DT::dataTableOutput('x36'),
      #verbatimTextOutput('y36')
    )
  )
)