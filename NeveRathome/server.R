#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(ggmap)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$map <- renderPlot({
    title = "World Cities"
    
    #subset data 
    df.subset <- sub.clim(input$weatype)
    df.subset <- sub.lang(input$lang, df.subset)
    
    #run matches
    weights <- c(input$sft, input$cor, input$weal, input$health, input$ntrnet,
                 input$tax, input$pop, input$col, input$ci, input$env, input$tc,
                 input$edu)
    cities <- getCities(weights,df.subset)
    mp = NULL
    mapWorld  <- borders("world", colour = "gray50", fill = "gray50")
    mp <- ggplot() + mapWorld + geom_point(aes(x =cities$lon, y = cities$lat, colour = cities$Score), size = 3)
    mp
    })
  output$l1 <- renderText( 
    "yay"
  )
})
