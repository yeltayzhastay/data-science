set.seed(20)
usersCluster <- kmeans(users[, -1], 5, nstart = 20)

library(ggplot2)
usersCluster$cluster <- as.factor(usersCluster$cluster)
ggplot(users, aes(usersCluster$cluster, 1:75, color = iris$cluster)) + geom_point()


data("AirPassengers")


good_months <- as.vector()
it = 1
for (i in 2:144) {
  if(AirPassengers[i] > AirPassengers[i-1]){
    good_months[it] <- AirPassengers[i]
    it = it + 1
  }
}


vector1 <- as.vector(AirPassengers)
vector2 <- c(vector1[length(vector1)],vector1[-length(vector1)])
diffs <- vector1-vector2
output = vector1[diffs>0]
good_months <- output


good_months <- AirPassengers[-1][AirPassengers[-1] > AirPassengers[-144]]


good_months <- as.vector(1:135)
for (i in 1:135) {
  l = i + 9
  good_months[i] <- mean(AirPassengers[i:l])
}


arr <- AirPassengers[1:10]
good <- mean(arr)
