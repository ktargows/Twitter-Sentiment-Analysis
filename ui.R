# shinydashboard makes it easy to use Shiny to create dashboards
# shinydashboard requires Shiny 0.11 or above

#First Selecting the shiny Dashboard
library(shiny)
library(shinydashboard)
library(openxlsx)

FileNames <- list.files("ExcelSheets/")
countDays <- length(FileNames)
positive = 0
neutral = 0
negative = 0
count = 0
for (i in seq(1, length(FileNames)))
{
  excelSheetData = read.xlsx(paste0("ExcelSheets/", FileNames[i]), startRow = 0, colNames = TRUE, detectDates = TRUE)
  countRows <- dim(excelSheetData)
  countRows <- countRows[1]
  
  rows <- countRows
  count = count + rows
  data = excelSheetData[, c("polarity", "polarity_confidence")]
  for (j in seq(1, rows)){
    if(data[j, 1] == "positive")
      positive = positive + data[j, 2]
    else if(data[j, 1] == "negative")
      negative = negative + data[j, 2]
    else
      neutral = neutral + data[j, 2]
  }
}
total <- positive + negative + neutral
positivePercent <- round((positive * 100) / total)
negativePercent <- round((negative * 100) / total)
neutralPercent <- round((neutral * 100) / total)

countVect = c(positive, neutral, negative)

shinyUI(dashboardPage(
  dashboardHeader(title = "Sentiment Analysis"),
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
                valueBox(countDays, "Number of Days ", icon = icon("calendar-check-o"), width = 6, color = "yellow")
              ),
              fluidRow(
                infoBox("Positive", paste(positivePercent, "%"), icon = icon("thumbs-up"), width = 4, fill = TRUE, color = "green"),
                infoBox("Neutral", paste(neutralPercent, "%"), icon = icon("hand-spock-o"), width = 4, fill = TRUE, color = "light-blue"),
                infoBox("Negative", paste(negativePercent, "%"), icon = icon("thumbs-down"), width = 4, fill = TRUE, color = "red")
              )
      ),
      
      # Second tab content
      tabItem(tabName = "Charts",
              h2("Widgets tab content")
      )
    )
  )
))

