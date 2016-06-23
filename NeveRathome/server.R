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
    cities <<- getCities(weights,df.subset)
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
    "yay"
  )
})
