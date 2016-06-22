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
library(plotly)
library(shinythemes)
library(dplyr)


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
    cities <<- getCities(weights,df.subset)
    
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
    plot_ly(cities, lon = lon, lat = lat,  text = City, marker = list(size = 10, color = Score, 
            colorbar = list(yanchor = "middle", title = "Score")),
            hoverInfo = "text", type = 'scattergeo')  %>% layout( geo = g)   
    
    })
  output$barchart <- renderPlotly({
    df.subset <- sub.clim(input$weatype)
    df.subset <- sub.lang(input$lang, df.subset)
    
    #run matches
    weights <- c(input$sft, input$cor, input$weal, input$health, input$ntrnet,
                 input$tax, input$pop, input$col, input$ci, input$env, input$tc,
                 input$edu)
    cities <- getCities(weights,df.subset)
    ggplotly(ggplot(cities) + geom_bar(aes(x = City, weight = Score, fill = City)))
  })
  output$l1 <- renderText( 
    "yay"
  )
})
