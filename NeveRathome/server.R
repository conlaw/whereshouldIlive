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
load("cityData2.RData")

sub.clim <- function(x = c(levels(factor(df.clean3$Weather_type)))) {
  df.clean3[which(df.clean3$Climate %in% x),]
}

#grab language from shiny
#countries that have this language in data frame
sub.lang <- function(x = c(levels(df.clean3$Spoken_languages)), df) {
  indxs <- lapply(x, function(z) {
    1:nrow(df) %in% grep(z, df$Spoken_languages)
  })
  test <- c(rep(F, nrow(df)))
  sapply(indxs, function(y){
    test <<- test|y
    
  })
  return(df[test,])
}
getCities <- function(weights, df.subset){
  scores <- apply(df.subset, 1, FUN = function(x){
    tmp <- x[-c(1,8,9,10,16,17,18)]
    w.pop <- weights[7]
    weights2 <- weights[-7]
    score <- as.numeric(tmp)*weights2
    score.pop <- popScorer(as.numeric(w.pop), x[8])
    score <- sum(score, na.rm = TRUE)+score.pop
    score
  })
  scores.df <- data.frame(City = df.subset[,1], Score = scores, Lon = df.subset["lon"], Lat = df.subset["lat"])
  scores.df$Score <- (scores.df$Score - min(scores.df$Score))/(max(scores.df$Score)-min(scores.df$Score))
  tail(scores.df[sort(scores.df$Score, index.return = TRUE)$ix,], 10)
}

popScorer <- function(weight, pop){
  w <- as.numeric(weight)
  print(w)
  print(class(w))
  pop2 <- as.numeric(pop)
  weight.val <- 0
  if(w == 0){
    weight.val <- -2.6690 
  }
  if(w == 1){
    weight.val <- -0.5685
  }
  if(w == 2){
    weight.val <- -0.1231
  }
  if(w == 3){
    weight.val <- 0.6764
  }
  if(w == 4){
    weight.val <- 2.5920
  }
  if(as.numeric(pop)>=weight.val){
    pop2 <- -1 * as.numeric(pop)
  }
  return(3*as.numeric(pop2))
}

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
    plot_ly(cities, lon = lon, lat = lat,  text = City, colors = "Greens",
            marker = list(size = 10, color = Score,
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
