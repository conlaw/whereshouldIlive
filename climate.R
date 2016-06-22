#Weather Grouping
View(df.clean3)
df.clean3$Climate <- ifelse(as.character(df.clean3$Weather_type) == "Tropical Savanna Climate" |
         as.character(df.clean3$Weather_type) == "Tropical Monsoon Climate" | 
         as.character(df.clean3$Weather_type) == "Tropical and Subtropical Steppe Climate" | 
         as.character(df.clean3$Weather_type) == "Tropical Rainforest Climate",
       "Tropical", ifelse(as.character(df.clean3$Weather_type) == "Marine West Coast Climate" | 
         as.character(df.clean3$Weather_type) == "Humid Subtropical Climate" | 
         as.character(df.clean3$Weather_type) == "Oceanic Subtropical Highland Climate" |
         as.character(df.clean3$Weather_type) == "Mediterran Climate", "Moderate",
         ifelse(as.character(df.clean3$Weather_type) == "Warm Summer Continental Climate" | 
                  as.character(df.clean3$Weather_type) == "Hot Summer Continental Climate"
           ,"Continental", ifelse(as.character(df.clean3$Weather_type) == "Mid-Latitude Steppe and Desert Climate" |
                                    as.character(df.clean3$Weather_type) == "Tropical and Subtropical Desert Climate","Dry",
                                  "Polar"))))







#DRY
#Mid-Latitude Steppe and Desert Climate
#Tropical and Subtropical Desert Climate

#POLAR
#Continental Subarctic Climate

#MODERATE
#Marine West Coast Climate
#Humid Subtropical Climate
#Oceanic Subtropical Highland Climate
#Mediterran Climate

#TROPICAL
#Tropical Savanna Climate
#Tropical Monsoon Climate
#Tropical and Subtropical Steppe Climate
#Tropical Rainforest Climate

#CONTINENTAL
#Warm Summer Continental Climate
#Hot Summer Continental Climate


















