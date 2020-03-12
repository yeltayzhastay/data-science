#Выделите все команды и нажмите кнопку Run

setwd("C:/sample_dataset")
library(readr)
du <- read_csv("pcfdev_user.csv")#Данные
devices <- read_csv("pcfdevice.csv")#Данные
users <- read_csv("pcfuser.csv")#Данные


du$device_row <- match(du$product_id,devices$product_id)
du$user_row <- match(du$user_id,users$id)

require(Matrix)
M <- sparseMatrix(i=du$device_row, j=du$user_row,
                  x=1)


#repeat {
#  i <- sum(dim(M))
#  M <- M[rowSums(M) >= 50, colSums(M) >= 150]
#  if (sum(dim(M)) == i) break
#}

#devices1 <- devices[match(rownames(M),
#                          devices$product_id),]



set.seed(seed = 68)
library(irlba)
Msvd <- irlba(M, nv = 5)
u <- Msvd$u
v <- Msvd$v

M <- scale(M, scale = F)


v_rot <- unclass(varimax(Msvd$v)$loadings)
u_rot <- as.matrix(M %*% v_rot)

devices1 <- subset(devices, select = -name )

res1 <- cor(u_rot, devices1[,-1], use = "pairwise")
#res <- cor(u_rot, devices1[,-1], use = "pairwise", method = "spearman")
#res <- cor(u_rot, devices1[,-1], use = "pairwise", method = "pearson")
#res <- cor(u_rot, devices1[,-1], use = "pairwise", method="kendall")

res1 <- t(res1)

corrplot(res1, method = "color", cl.lim = c(-0.5,0.5))








#Выделите все команды и нажмите кнопку Run

setwd("C:/sample_dataset")
library(readr)
du <- read_csv("pcfdev_user.csv")#Данные
devices <- read_csv("pcfdevice.csv")#Данные
users <- read_csv("pcfuser.csv")#Данные


du$device_row <- match(du$product_id,devices$product_id)
du$user_row <- match(du$user_id,users$id)

require(Matrix)
M <- sparseMatrix(i=du$device_row, j=du$user_row,
                  x=1)


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

devices1 <- subset(devices, select = -name )

res <- cor(gamma, devices1[,-1], use = "pairwise")

res <- t(res)



library(corrplot)
corrplot(res, method = "number", cl.lim = c(-0.1,0.1))