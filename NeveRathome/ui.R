#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Where should I live?"),
  # Sidebar with a slider input for number of bins 
  fluidRow(
    column(12, 
           plotOutput("map"),
           textOutput("l1")),
    column(3,
           selectInput("lang",
                       "Language",
                       choices = levels(factor(df.clean3$Spoken_languages)),
                       selected = "English"),
           #selectInput("pop",
            #           "Population Size",
             #          choices = c("very small", "small", "medium", "large")),
           sliderInput("pop",
                       "Population",
                       min = 0,
                       max = 5,
                       value = 0),
           sliderInput("health",
                       "Healthcare",
                       min = 0,
                       max = 5,
                       value = 0),
           
           sliderInput("tc",
                       "Travel Connectivity",
                       min = 0,
                       max = 5,
                       value = 0),
           
           checkboxGroupInput("weatype",
                         "Climate Type",
                         choices = c(levels(factor(df.final$`Weather type`))))
           ),
    column(3,
       
       sliderInput("ci",
                   "Culture Index",
                   min = 0,
                   max = 5,
                   value = 0),
       sliderInput("weal",
                   "Wealth",
                   min = 0,
                   max = 5,
                   value = 0),
       
       sliderInput("cor",
                   "Corruption",
                   min = 0,
                   max = 5,
                   value = 0)
    ),
       
      column(3,
             sliderInput("sft",
                         "Safety",
                         min = 0,
                         max = 5,
                         value = 0),
             #I'm thinking this could include air quality, water quality,
             sliderInput("env",
                         "Environment",
                         min = 0,
                         max = 5,
                         value = 0),

             #I decided to exclude GDP, people tend to look more at their own financials when 
             #choosing a city
             
             sliderInput("ntrnet",
                         "Internet Access",
                         min = 0,
                         max = 5,
                         value = 0)
      ),   
    column(3,
       sliderInput("edu",
                   "Education",
                   min = 0,
                   max = 5,
                   value = 0),
       
       sliderInput("col",
                   "Low Cost of Living",
                   min = 0,
                   max = 5,
                   value = 0),
       
       sliderInput("tax",
                   "Taxes",
                   min = 0,
                   max = 5,
                   value = 0)
    )
       
  )
  )
)


