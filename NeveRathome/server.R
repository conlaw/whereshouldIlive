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
  output$table <- renderDataTable({
    df.subset <- sub.clim(input$weatype)
    df.subset <- sub.lang(input$lang, df.subset)
  
   #run matches
   weights <- c(input$sft, input$cor, input$weal, input$health, input$ntrnet,
               input$tax, input$pop, input$col, input$ci, input$env, input$tc,
               input$edu)
    cities <- getCities(weights,df.subset)
    for(i in nrow(cities):1){
      cities$Rank[i] <- -i + nrow(cities) + 1
    }
    df.clean3$Population_size <- popScorer(input$pop, df.clean3$Population_size)
    outputtab <- merge(df.clean3, cities)
    
    outputtab <- select(outputtab, City, Rank,Score, Spoken_languages, Climate, Crime_rate:Population_size, costOfLiving:educationMetric)
    names(outputtab) <- c("City", "Rank", "Score", "Language(s)", "Climate", "Safety", "Freedom from Corruption", "Wealth", 
                          "Healthcare", "Internet Access", "Tax", "Population Size", "Cost of Living", "Culture",
                          "Environment", "Travel Connectivity", "Education")
    
    if(input$sft == 0){
      outputtab <- select(outputtab, -`Safety`)
    }
    if(input$cor == 0){
      outputtab <- select(outputtab, -`Freedom from Corruption`)
    }
    if(input$weal == 0){
      outputtab <- select(outputtab, -`Wealth`)
    }
    if(input$health == 0){
      outputtab <- select(outputtab, -`Healthcare`)
    }
    if(input$ntrnet == 0){
      outputtab <- select(outputtab, -`Internet Access`)
    }
    if(input$tax == 0){
      outputtab <- select(outputtab, -`Tax`)
    }
    if(input$col == 0){
      outputtab <- select(outputtab, -`Cost of Living`)
    }
    if(input$ci == 0){
      outputtab <- select(outputtab, -`Culture`)
    }
    if(input$env == 0){
      outputtab <- select(outputtab, -`Environment`)
    }
    if(input$tc == 0){
      outputtab <- select(outputtab, -`Travel Connectivity`)
    }
    if(input$edu == 0){
      outputtab <- select(outputtab, -`Education`)
    }
    outputtab}
  )
  
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
    inputMap <- input$mapOption
    if(inputMap == "Globe"){
      tmp <- "orthographic"
    }
    if(inputMap == "Rectangular"){
      tmp <- "miller"
    }
    g <- list(
      scope = 'world',
      projection = list(type = tmp),
      showframe = FALSE,
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
    ggplotly(ggplot(cities) + geom_bar(aes(x = City, weight = Score, fill = City))+ labs(y = "Score")) 
  })
  output$l1 <- renderText( 
    class(input$pop)
  )
  output$dir <- renderText( 
    "Hello user! So you've decided to move but want some advice on where exactly you want to go. 
    There are so many options out there it can get overwhelming but worry not! Where Should I live 
    was designed to make choosing your dream city easy. Simply tell us the languages you would like to 
    speak, the climate you would like to live in, and how important you find traits in a 
    city using the sliders provided. Happy Travels!"
    
  )
})
