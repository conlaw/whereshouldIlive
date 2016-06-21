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
sub.clim <- function(x) {
df.clean3[which(df.clean3$Weather_type == x),]
}

#grab language from shiny
#countries that have this language in data frame
sub.lang <- function(x, data) {
data[which(as.character(data$Spoken_Languages) == x),]
}


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




