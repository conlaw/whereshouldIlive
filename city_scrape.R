#Script to get all the city names from the teleport site
library(rvest)
library(RSelenium)
library(stringr)

#Use RSelenium to pull cities (dynamically laoded page)
checkForServer()
startServer()
browser <- remoteDriver()
browser$open()
browser$navigate("https://teleport.org/my-cities")
page <- browser$getPageSource()

cities.raw <- read_html(page[[1]])

cities.list <- cities.raw %>% html_nodes(css = "#container > article.search.widget > section.city-list")
cities <- html_text(html_children(cities.list))
cities <- str_trim(cities)

