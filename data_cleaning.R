#Feature Engineering/Data Cleaning
library(dplyr)
library(stringr)

df.clean <- df.final
names(df.clean) <- str_replace_all(names(df.clean), "[\\[|()].*[\\]|)]", "")
names(df.clean) <- str_trim(names(df.clean))
names(df.clean) <- str_replace_all(names(df.clean), " ", "_")

df.clean[-c(1,39,45)] <- lapply(df.clean[-c(1,39,45)], as.numeric)

#Normalise Population
df.clean$Population_size <- log(df.clean$Population_size)

#put rent index in dollars to mix into cost of living metric
df.clean <- mutate(df.clean, Rent = Rent_index*8349.69)
df.clean$Rent <- -(df.clean$Rent-max(df.clean$Rent)) + min(df.clean$Rent)

#cost of living metric
df.clean <- mutate(df.clean, costOfLiving = 20*A_beer + 31*A_Cappuccino + 10*A_kilogram_of_Apples + 30.5*Bread + Monthly_public_transport +
                     8*Price_of_a_meal_at_a_restaurant + 4*Movie_ticket + 30.5*Lunch + Monthly_fitness_club_membership + Rent)
#culture metric
df.clean <- mutate(df.clean, cultureIndex = Art_galleries + Cinemas + Comedy_clubs + Concerts + Historical_sites + Museums + Performing_arts + Zoos)

#environmental metric
df.clean <- mutate(df.clean, environmentalIndex = Urban_greenery + Drinking_water_quality + Average_sunshine_per_day + Air_quality + Cleanliness + Traffic_handling)

#connectivity metric
df.clean <- mutate(df.clean, connectivityMetric = Intercity_train_connectivity + Airport_hub)

#education metric
df.clean <- mutate(df.clean, educationMetric = 0.7*PISA_ranking + 0.3*University_quality)

df.clean2 <- select(df.clean, city, Crime_rate, Freedom_from_corruption, GDP_per_capita, Healthcare_index, Internet_access, Income_tax_level, Population_size, Spoken_languages, Weather_type, costOfLiving:educationMetric)

#Make cost of living negative so smaller costOfLivings have higher scores when fed into scale
df.clean2["costOfLiving"] <- -df.clean2["costOfLiving"]
df.clean2[,-c(1, 9, 10)] <- lapply(df.clean2[,-c(1, 9, 10)], scale)

df.clean2[45, ]$Weather_type <- "Marine West Coast Climate"
df.clean2[-c(1,9,10)] <- lapply(df.clean2[-c(1,9,10)], function(x) {
  x[is.na(x)] <- 0
  x
})

df.clean2 <- as.data.frame(lapply(df.clean2, as.vector))

#get latitude and longitude
library(ggmap)

latlon <- geocode(as.character(df.clean2$city), output = "latlon")

df.clean3 <- cbind(df.clean2, latlon)

#population into quantiles
save(df.clean3, file = "cityData2.RData")
