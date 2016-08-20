# shinydashboard makes it easy to use Shiny to create dashboards
# shinydashboard requires Shiny 0.11 or above
#First Selecting the shiny Dashboard
library(shiny)
library(shinydashboard)
library(openxlsx)
library(ggplot2)


FileNames <- list.files("ExcelSheets/")
countDays <- length(FileNames)

positive = 0
neutral = 0
negative = 0
countTweets = 0

positiveTweets = ""
negativeTweets = ""
neutralTweets = ""


p = 1
nu = 1
ng = 1

chartMatrix = 0

for (i in seq(1, length(FileNames)))
{
  excelSheetData = read.xlsx(paste0("ExcelSheets/", FileNames[i]), startRow = 0, colNames = TRUE, detectDates = TRUE)
  countRows <- dim(excelSheetData)
  countRows <- countRows[1]
  
  rows <- countRows
  countTweets = countTweets + rows
  data = excelSheetData[, c("polarity", "polarity_confidence", "Text")]
  positiveCount = 0
  negativeCount = 0 
  neutralCount = 0
  
  for (j in seq(1, rows))
  {
    if(data[j, 1] == "positive")
    {
      positive = positive + data[j, 2]
      positiveTweets = paste0(positiveTweets, paste0(paste(paste0(p, ":"), data[j,3]), "<br><br>"))
      positiveCount = positiveCount + 1
      p = p + 1
    }
    else if(data[j, 1] == "negative")
    {
      negative = negative + data[j, 2]
      negativeTweets = paste0(negativeTweets, paste0(paste(paste0(ng, ":"), data[j,3]), "<br><br>"))
      negativeCount = negativeCount + 1
      ng = ng + 1
    }
    else if(data[j, 1] == "neutral")
    {
      neutral = neutral + data[j, 2]
      neutralTweets = paste0(neutralTweets, paste0(paste(paste0(nu, ":"), data[j,3]), "<br><br>"))
      neutralCount = neutralCount + 1
      nu = nu + 1
    }
  }
  
  if(i==1)
    chartMatrix <- c(positiveCount, neutralCount, negativeCount)
  else
    chartMatrix <- c(chartMatrix, c(positiveCount, neutralCount, negativeCount))
}
total <- (positive + negative) + neutral

positivePercent <<- round((positive * 100) / total)
negativePercent <<- round((negative * 100) / total)
neutralPercent <<- round((neutral * 100) / total)

countVect = c(positive, neutral, negative)

chartMatrix <- matrix(chartMatrix, ncol=3, byrow=TRUE)
colnames(chartMatrix) <- c("Positive", "Neutral", "Negative")
chartMatrix <<- as.table(chartMatrix)


shinyUI(dashboardPage(
  dashboardHeader(title = "Sentiment Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Tweets", icon = icon("twitter"),
               menuSubItem("Positive Tweets", tabName = "pTweets", icon = icon("thumbs-up")),
               menuSubItem("Neutral Tweets", tabName = "neuTweets", icon = icon("hand-spock-o")),
               menuSubItem("Negative Tweets", tabName = "negTweets", icon = icon("thumbs-down"))
      ),
      menuItem("Charts", tabName = "Charts", icon = icon("twitter"))
    )
  ),
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              div(class = "titleText", h2(HTML("<center><b>Sentiment Analysis</b> of Twitter Tweets using <i>RapidMiner</i> and <i>Shiny Dashboard</i>.</center>"))),
              div(class = "Author", h5(HTML("<center>- By Rushabh Wadkar & Ankit Agarwal.</center><br>"))),
              fluidRow(
                valueBox(countTweets, "Total Number of Tweets Analyzed in the competition", icon = icon("twitter"), width = 6),
                valueBox(countDays, "Number of Days ", icon = icon("calendar-check-o"), width = 6, color = "yellow")
              ),
              fluidRow(
                infoBox("Positive", paste(positivePercent, "%"), icon = icon("thumbs-up"), width = 4, fill = TRUE, color = "green"),
                infoBox("Neutral", paste(neutralPercent, "%"), icon = icon("hand-spock-o"), width = 4, fill = TRUE, color = "light-blue"),
                infoBox("Negative", paste(negativePercent, "%"), icon = icon("thumbs-down"), width = 4, fill = TRUE, color = "red")
              ),
              fluidRow(
                plotOutput("DashboardChart", width="100%", height="400px")
              )
              
      ),
      
      # Positive Tweets tab content
      tabItem(tabName = "pTweets",
              h2(HTML("<center><b><span style='color: green'>Positive</span> Tweets <i>#Brexit</i></b></center>")),
              h4(HTML(positiveTweets))
      ),
      # Neutral Tweets tab content
      tabItem(tabName = "neuTweets",
              h2(HTML("<center><b><span style='color: blue'>Neutral</span> Tweets <i>#Brexit</i></b></center>")),
              h4(HTML(neutralTweets))
      ),
      # Negative Tweets tab content
      tabItem(tabName = "negTweets",
              h2(HTML("<center><b><span style='color: red'>Negative</span> Tweets <i>#Brexit</i></b></center>")),
              h4(HTML(negativeTweets))
      ),
      
      #charts
      tabItem(tabName = "Charts",
              h2(HTML("<center><b><span style='color: orange; font-size: 40px;'>C</span>harts</b></center>")),
              HTML("<hr style='border-width: 3px; border-color: black'>"),
                
              fluidRow(
                column(5, offset = 1,
                       h4(HTML("<b>Select the Date</b>")),
                       br(),
                       sliderInput(inputId = 'dateSlider', "Date Slider", 1, countDays, 1, step=1, animate=TRUE),
                       br(),
                       fluidRow(
                         valueBoxOutput("PositiveCount"),
                         
                         valueBoxOutput("NeutralCount"),
                         
                         valueBoxOutput("NegativeCount")
                       ),
                       br(),
                       fluidRow(
                         column(12, offset=3,
                          valueBoxOutput("TotalCount")
                         )
                       )
                ),
                column(5, offset = 1,
                       h4(HTML("<center><b>Output</b></center>")),
                      textOutput("desc"),
                       br(),
                       plotOutput("pieChart", width="90%", height="350px")
                  )
              )
      )
    )
  )
))

