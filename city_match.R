library(dplyr)
getCities <- function(weights, df.subset){
  scores <- apply(df.subset, 1, FUN = function(x){
    tmp <- x[-c(1,8,9,10,16,17,18)]
    w.pop <- weights[7]
    weights2 <- weights[-7]
    score <- as.numeric(tmp)*weights2
    score.pop <- popScorer(as.numeric(w.pop), x[8])
    score <- sum(score, na.rm = TRUE)+score.pop
    score
  })
  scores.df <- data.frame(City = df.subset[,1], Score = scores, Lon = df.subset["lon"], Lat = df.subset["lat"])
  scores.df$Score <- (scores.df$Score - min(scores.df$Score))/(max(scores.df$Score)-min(scores.df$Score))
  tail(scores.df[sort(scores.df$Score, index.return = TRUE)$ix,], 10)
}

popScorer <- function(weight, pop){
  w <- as.numeric(weight)
  print(w)
  print(class(w))
  pop2 <- as.numeric(pop)
  weight.val <- 0
  if(w == 0){
    weight.val <- -2.6690 
  }
  if(w == 1){
    weight.val <- -0.5685
  }
  if(w == 2){
    weight.val <- -0.1231
  }
  if(w == 3){
    weight.val <- 0.6764
  }
  if(w == 4){
    weight.val <- 2.5920
  }
  if(as.numeric(pop)>=weight.val){
    pop2 <- -1 * as.numeric(pop)
  }
  return(3*as.numeric(pop2))
}