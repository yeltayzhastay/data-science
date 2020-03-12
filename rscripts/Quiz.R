setwd("C:/sample_dataset")
library(readr)
qu <- read_csv("quiz_user.csv")#Данные
qr <- read_csv("quiz_result.csv")#Данные


mqr <- as.matrix(qr)

vector <- matrix(nrow = 390,ncol = 76)

for (i in 1:390) {
  for(j in 1:76) {
    
    if(j == 1){
      vector[i,1] <- mqr[i*75 - 74,1]
    }
    else{
      vector[i,j] <- mqr[i*75 - 76 + j,3]
    }
  }
}
vec <- as.data.frame(vector)

write.csv(vec, "vector.csv")
