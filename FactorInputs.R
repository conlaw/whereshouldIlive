library(reshape2)
library(dplyr)
library(plyr)
#langauge, weather
load("cityData.RData")

#grab weather from from shiny
#grab countries which have this weather type
#save into a new data frame
#paste(ifelse(lalala, paste("weather_type", names(lalala), sep = "=="),""))
#names(lalala) = unique(df.final$`Weather type`)
lalala <- "Marine West Coast Climate"
hello <- df.final[which(df.final$`Weather type` == lalala),]$city

fefe <- "Humid Subtropical Climate"
hello2 <- df.final[which(df.final$`Weather type` == fefe),]$city
hello2


#grab language from shiny
#countries that have this language in data frame
hehehe <- "English" 
bye <- df.final[which(df.final$`Spoken languages` == hehehe),]$city
bye


#population
#class(df.final$`Population size (millions)`)
#df.final$`Population size (millions)` <- as.numeric(df.final$`Population size (millions)`)
#class(df.final$`Population size (millions)`)

#summary(df.final$`Population size (millions)`)

#ummm <- df.final[which(df.final$`Population size (millions)` < 1.2),]$city
#ummm
#ummm2 <- df.final[which(df.final$`Population size (millions)` >= 1.2 & df.final$`Population size (millions)` < 10),]$city
#ummm2
#ummm3 <- df.final[which(df.final$`Population size (millions)` >= 10),]$city
#ummm3





