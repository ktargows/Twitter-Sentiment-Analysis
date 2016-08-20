
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotrix)


shinyServer(function(input, output) {
  
  output$PositiveCount <- renderValueBox({
    valueBox(
      chartMatrix[input$dateSlider, 1], "Positive", width=1,
      color = "green"
    )
  })
  output$NeutralCount <- renderValueBox({
    valueBox(
      chartMatrix[input$dateSlider, 2], "Neutral", width=1,
      color = "blue"
    )
  })
  output$NegativeCount <- renderValueBox({
    valueBox(
      chartMatrix[input$dateSlider, 3], "Negative", width=1,
      color = "red"
    )
  })
  
  output$TotalCount <- renderValueBox({
    valueBox(
      chartMatrix[input$dateSlider, 1]+chartMatrix[input$dateSlider, 2]+chartMatrix[input$dateSlider, 3], "Total Tweets", width=1,
      color = "orange"
    )
  })
  
    
    output$desc <- renderText(
      paste(paste("Generating Pie Chart for : ", input$dateSlider+8), "August, 2016")
    )
    
    output$pieChart <- renderPlot(
      pie(chartMatrix[input$dateSlider, ], paste(c("Positive", "Neutral", "Negative"), paste0(round(chartMatrix[input$dateSlider, ]/sum(chartMatrix[input$dateSlider, ])*100) ), "%"), radius = 1, clockwise = TRUE,col=c("forestgreen", "cadetblue1", "Red"), main = "Pie chart")
    )
    output$DashboardChart <- renderPlot(
      pie(c(positivePercent, neutralPercent, negativePercent), c("Positive","Neutral", "Negative"),clockwise = TRUE,col=c("forestgreen", "cadetblue1", "Red"), main = "Pie Chart #Total Analysis")
    )
  
})
