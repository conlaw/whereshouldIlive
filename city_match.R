library(dplyr)
getCities <- function(weights, df.subset){
  scores <- apply(df.subset, 1, FUN = function(x){
    tmp <- x[-c(1,9,10,16,17)]
    score <- as.numeric(tmp)*weights
    score <- sum(score)
    score
  })
  scores.df <- data.frame(City = df.subset[,1], Score = scores, Lon = df.subset["lon"], Lat = df.subset["lat"])
  tail(tmp[sort(tmp$Score, index.return = TRUE)$ix,])
}