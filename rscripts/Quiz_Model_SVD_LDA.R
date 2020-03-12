setwd("C:/sample_dataset")
library(readr)
users <- read_csv("C:/sample_dataset/quiz_vk/users.csv")#Данные
ug <- read_csv("C:/sample_dataset/quiz_vk/ug.csv")#Данные
groups <- read_csv("C:/sample_dataset/quiz_vk/groups.csv")#Данные


ug$user_row <- match(ug$user_id,users$vk_id)
ug$group_row <- match(ug$subscribed_group_id,groups$subscribed_group_id)

ug <- ug[complete.cases(ug), ]


require(Matrix)
M <- sparseMatrix(i=ug$user_row, j=ug$group_row,
                  x=1)

#users <- users[match(rownames(M), users$id),]

set.seed(seed = 68)
library(irlba)
Msvd <- irlba(M, nv = 5)
u <- Msvd$u
v <- Msvd$v

#M <- scale(M, scale = F)

v_rot <- unclass(varimax(Msvd$v)$loadings)
u_rot <- as.matrix(M %*% v_rot)

res <- cor(u_rot, users[,-1], use = "pairwise")
res <- t(res)

library(corrplot)
corrplot(res, method = "number")





groups <- groups[complete.cases(groups), ]







setwd("C:/sample_dataset")
library(readr)
users <- read_csv("C:/sample_dataset/vk/users.csv")#Данные
ug <- read_csv("C:/sample_dataset/vk/ug.csv")#Данные
groups <- read_csv("C:/sample_dataset/vk/groups.csv")#Данные


ug$user_row <- match(ug$user_id,users$id)
ug$group_row <- match(ug$subscribed_group_id,groups$id)

#users <- users[match(rownames(M),users$id),]

ug <- ug[complete.cases(ug), ]

require(Matrix)
M <- sparseMatrix(i=ug$user_row, j=ug$group_row,
                  x=1)



rowTotals <- apply(M , 1, sum) #Find the sum of words in each Document
M  <- M[rowTotals> 0, ] 



library(topicmodels)
Mlda <- LDA(M, k = 5, control = list(alpha = 10, delta = .1, seed = 68), method = "Gibbs")
gamma <- Mlda@gamma
beta <- exp(Mlda@beta)

lg <- list()
for (i in 2:5) {
  Mlda <- LDA(M, k = i, control =
                list(alpha = 10, delta = .1, seed = 68),
              method = "Gibbs")
  lg[[i]] <- logLik(Mlda)
}

res <- cor(gamma, users[,-1], use = "pairwise")
res <- t(res)

library(corrplot)
corrplot(res, method = "number")











users <- read.csv("users.csv")
likes <- read.csv("likes.csv")
ul <- read.csv("users-likes.csv")

ul$user_row <- match(ul$userid,users$userid)
ul$like_row <- match(ul$likeid,likes$likeid)

require(Matrix)
M <- sparseMatrix(i=ul$user_row, j=ul$like_row,
                  x=1)
repeat {
  i <- sum(dim(M))
  M <- M[rowSums(M) >= 50, colSums(M) >= 150]
  if (sum(dim(M)) == i) break
}

users <- users[match(rownames(M),
                     users$userid),]

library(topicmodels)
Mlda <- LDA(M, k = 5, control = list(alpha =
                                       10, delta = .1, seed = 68), method =
              "Gibbs")
gamma <- Mlda@gamma
beta <- exp(Mlda@beta)

lg <- list()
for (i in 2:5) {
  Mlda <- LDA(M, k = i, control =
                list(alpha = 10, delta = .1, seed = 68),
              method = "Gibbs")
  lg[[i]] <- logLik(Mlda)
}
plot(2:5, unlist(lg))

cor(gamma, users[,-1], use = "pairwise")