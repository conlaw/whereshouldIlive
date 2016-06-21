library(dplyr)
getCities <- function(weights, df.subset){
  scores <- apply(df.subset, 1, FUN = function(x){
    tmp <- x[-c(1,9,10)]
    score <- as.numeric(tmp)*weights
    score <- sum(score)
    score
  })
  names(scores) <- df.subset[,1]
  
}