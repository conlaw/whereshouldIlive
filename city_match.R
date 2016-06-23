library(dplyr)
getCities <- function(weights, df.subset){
  scores <- apply(df.subset, 1, FUN = function(x){
    tmp <- x[-c(1,8,9,10,16,17,18)]
    w.pop <- weights[7]
    weights2 <- weights[-7]
    score <- as.numeric(tmp)*weights2
    score.pop <- popScorer(w.pop, x[8])
    score <- sum(score)+score.pop
    score
  })
  scores.df <- data.frame(City = df.subset[,1], Score = scores, Lon = df.subset["lon"], Lat = df.subset["lat"])
  scores.df$Score <- (scores.df$Score - min(scores.df$Score))/(max(scores.df$Score)-min(scores.df$Score))
  tail(scores.df[sort(scores.df$Score, index.return = TRUE)$ix,], 10)
}

popScorer <- function(weight, pop){
  weight.val <- 0
  if(weight==0){
    weight.val <- min(df.clean3$Population_size)
  }
  else if(weight == 1){
    weight.val <- quantile(df.clean3$Population_size, 0.25)
  }
  else if(weight == 2){
    weight.val <- median(df.clean3$Population_size)
  }
  else if(weight == 3){
    weight.val <- quantile(df.clean3$Population_size, 0.75)
  }
  else{
    weight.val <- max(df.clean3$Population_size)
  }
  if(pop[1]>=weight.val[1]){
    pop <- -pop
  }
  return(3*as.numeric(pop))
}