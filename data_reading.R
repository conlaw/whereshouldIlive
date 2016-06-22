library(httr)
library(reshape2)
cities <- getURL("https://api.teleport.org/api/urban_areas/")
tmp <- fromJSON(cities)
tmp$`_links`$`ua:item`

#gets all the city urls for the get request
city_urls <- sapply(tmp$`_links`$`ua:item`, function(x) x[[1]][1])
city_names <- sapply(tmp$`_links`$`ua:item`, function(x) x[2])

#Get's json for all the cities
city_data <- lapply(city_urls, function(x){fromJSON(getURL(paste0(x,"details/")))})

city_list <- lapply(city_data, function(z){
  city_summary <- sapply(z$categories, function(y) {
    sapply(y$data, function(x){
      for(i in c("float_value", "string_value", "int_value", "currency_dollar_value", "percent_value")){
        if(!(x[i]=="NULL" | is.na(x[i]))){
          test <- x[i]
          names(test) <- x["label"]
        }
      }
      test
    })
  })
  tmp <- unlist(city_summary)
  tmp
})
names(city_list) <- city_names

#List of possible fields
fields <- unique(unlist(sapply(city_list, function (x) names(x))))

#Create long form data

df.city_list <- lapply(1:length(city_list), function(k){
  x <- city_list[[k]]
  tmp <- data.frame(city = rep(names(city_list[k]), length(x)), var = names(x), value = x)
  tmp
})
df.full <- do.call(rbind, df.city_list)
#filter it
library(dplyr)
df.full2 <- filter(df.full, var %in% fields[c(1,2,7,8,9,10,11,13:31, 35, 39, 42, 45:48, 57,58, 60:65, 81, 83, 84, 86)])
df.full2$var <- factor(df.full2$var)
df.full3 <- df.full2[!duplicated(df.full2[1:2]),]

#cast it
df.final <- dcast(df.full3, city ~ var)
save(df.final, file="cityData.RData")
