fluidRow(
  box(
    background = "yellow",
    plotOutput("plot1", height = 250)
  ),
  
  box(
    title = "Controls",
    sliderInput("slider", "Number of Tweets : (* Press the play button)", 1, count, 0, step = 25, animate = TRUE)
  )
)

# dgdflghdf

#Initializing the dashboard
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Charts", tabName = "Charts", icon = icon("line-chart"))
    )
  ),
  ## Body content
  dashboardBody(
    
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              div(class = "my-class", h2("Sentiment Analysis of Twitter Tweets using RapidMinor and Shiny Dashboard.")),
              fluidRow(
                valueBox(count, "Total Number of Tweets Analyzed in the competition", icon = icon("twitter"), width = 6),
                valueBox(countDays, "Number of Days ", icon = icon("twitter"), width = 6)
              ),
              fluidRow(
                infoBox("Positive", paste(positivePercent, "%"), icon = icon("thumbs-up"), width = 4, fill = TRUE, color = "green"),
                infoBox("Neutral", paste(negativePercent, "%"), icon = icon("thumbs-up"), width = 4, fill = TRUE, color = "light-blue"),
                infoBox("Negative", paste(neutralPercent, "%"), icon = icon("thumbs-up"), width = 4, fill = TRUE, color = "red")
              )
      ),
      
      # Second tab content
      tabItem(tabName = "Charts",
              h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  output$dateWiseCharts <- renderMenu({
    menuItem("Menu item", icon = icon("calendar"))
  })
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}
