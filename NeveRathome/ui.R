#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
load("cityData2.RData")


# Define UI for application that draws a histogram
shinyUI(fluidPage(

  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Open+Sans');
                    "))
    ),
   
  includeCSS("styles.css"),
  
  theme = shinytheme("readable"),

  # Application title
  titlePanel("Where should I live?"),
  # Sidebar with a slider input for number of bins 
  fluidRow(
    tags$style(HTML("
        .tabs-above > .nav > li[class=active] > a {
                    background-color: #0066ff;
                    color: #FFF;
                    }
        #tab-8265-1{
                    margin: 5%;
        }            
                    
                    
                    ")),
    tabsetPanel( 
           tabPanel("Map", 
             radioButtons("mapOption", label = "", choices = list("Globe", "Rectangular"), inline = TRUE, width = "100%"),
             plotlyOutput("map")
             ),
           tabPanel("Graph",plotlyOutput("barchart")),
           tabPanel("Table", dataTableOutput("table")),
           tabPanel("Web", HTML('<iframe width=\"100%\" height=\"600\" margin =\"5%\" src=\"//www.lonelyplanet.com\" frameborder=\"0\" allowfullscreen></iframe>'))),
    tabsetPanel(
      tabPanel("Directions",textOutput("dir")),
      tabPanel("Language",  checkboxGroupInput("lang",
                                              "Language",
                                              choices = c("Arabic", "Armenian", "Azerbaijani", "Bosnian", "Bulgarian", "Croatian",
                                                          "Chinese", "Czech", "Dutch", "French", "English","Afrikaans","Zulu", "Xhosa",
                                                          "Filipino/tagalog", "Hindi", "Irish Gaelic", "Estonian", "Finnish", "Georgian",
                                                          "German", "Italian", "Greek", "Hebrew", "Hungarian", "Icelandic", "Indonesian",
                                                          "Japanese", "Korean", "Latvian", "Lithuanian", "Macedonian", "Malay", "Maltese",
                                                          "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Belarusian",
                                                          "Ukranian", "Serbian", "Slovak", "Slovenian", "Spanish", "Catalan", "Swedish",
                                                          "Thai", "Turkish", "Vietnamese"),
                                              selected = "English",
                                              inline = T)),
      tabPanel("Climate",  checkboxGroupInput("weatype",
                                             "Climate Type",
                                             choices = c(levels(factor(df.clean3$Climate))),
                                             inline =T)),
      tabPanel("City Traits",
               
               column(3,
                      sliderInput("weal",
                                  "Wealth",
                                  min = 0,
                                  max = 5,
                                  value = 0),
                      sliderInput("cor",
                                  "Freedom from Corruption",
                                  min = 0,
                                  max = 5,
                                  value = 0),
                      sliderInput("sft",
                                  "Safety",
                                  min = 0,
                                  max = 5,
                                  value = 0)
               ),
               #I'm thinking this could include air quality, water quality,
               column(3,
                      sliderInput("env",
                                  "Environment",
                                  min = 0,
                                  max = 5,
                                  value = 0),               
                      sliderInput("ntrnet",
                                  "Internet Access",
                                  min = 0,
                                  max = 5,
                                  value = 0),
                      sliderInput("health",
                                  "Healthcare",
                                  min = 0,
                                  max = 5,
                                  value = 0)
               ),
               column(3,
                      #I decided to exclude GDP, people tend to look more at their own financials when 
                      sliderInput("edu",
                                  "Education",
                                  min = 0,
                                  max = 5,
                                  value = 0),
                      sliderInput("col",
                                  "Cost of Living",
                                  min = 0,
                                  max = 5,
                                  value = 0),        
                      sliderInput("tax",
                                  "Taxes",
                                  min = 0,
                                  max = 5,
                                  value = 0)
               ),
               column(3,
                      sliderInput("tc",
                                  "Travel Connectivity",
                                  min = 0,
                                  max = 5,
                                  value = 0),               
                      sliderInput("ci",
                                  "Culture Index",
                                  min = 0,
                                  max = 5,
                                  value = 0),
                      sliderInput("pop",
                                  "Population (Small to Large)",
                                  min = 0,
                                  max = 4,
                                  value = 0
                      )),
               textOutput("slid")
      )
    ),
  margin = "5%")
)
)



