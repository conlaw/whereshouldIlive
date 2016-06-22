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
  output$map <- renderPlotly({
    title = "World Cities"
    
    #subset data 
    df.subset <- sub.clim(input$weatype)
    df.subset <- sub.lang(input$lang, df.subset)
    
    #run matches
    weights <- c(input$sft, input$cor, input$weal, input$health, input$ntrnet,
                 input$tax, input$pop, input$col, input$ci, input$env, input$tc,
                 input$edu)
    cities <- getCities(weights,df.subset)
    
    g <- list(
      scope = 'world',
      projection = list(type = 'orthographic'),
      showland = TRUE,
      subunitwidth = 1,
      countrywidth = 1,
      showocean = TRUE,
      oceancolor = "royalblue",
      landcolor = "white",
      subunitcolor = toRGB("white"),
      countrycolor = toRGB("white")
    )
    
    p <- plot_ly(cities,type = "scattergeo", lon = lon, lat = lat, text = City, hoverInfo = "text",
            marker = list(size = 10, symbol),color = Score) %>% layout( geo = g) 
    p
    })
  output$l1 <- renderText( 
    "yay"
  )
})
