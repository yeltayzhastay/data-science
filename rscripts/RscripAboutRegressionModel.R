#�������� ��� ������� � ������� ������ Run

setwd("C:/Users/Edd/Desktop/������������� ������")
library(readr)
dataset <- read_csv("converted.csv")#������


library(car)
head(dataset)


#scatterplotMatrix(dataset,spread = FALSE, lty.smooth = 2, main ='����������� ���� ����������')#plot view


#cor(dataset)


fit1 <- lm(formula = ldc.ettas8_10_0 ~ ldc.poro+ldc.visc+ldc.ettas7_0+ldc.ettas7_1+ldc.ettas7_2+ldc.ettas7_3+ldc.ettas7_4+ldc.ettas7_5+ldc.ettas7_6 ,data = dataset) #������������� ������
fit2 <- lm(formula = ldc.ettas8_10_1 ~ ldc.poro+ldc.visc+ldc.ettas7_0+ldc.ettas7_1+ldc.ettas7_2+ldc.ettas7_3+ldc.ettas7_4+ldc.ettas7_5+ldc.ettas7_6+ldc.ettas8_10_0 ,data = dataset) #������������� ������
fit3 <- lm(formula = ldc.ettas8_10_2 ~ ldc.poro+ldc.visc+ldc.ettas7_0+ldc.ettas7_1+ldc.ettas7_2+ldc.ettas7_3+ldc.ettas7_4+ldc.ettas7_5+ldc.ettas7_6+ldc.ettas8_10_0+ldc.ettas8_10_1 ,data = dataset) #������������� ������




#summary(fit)#������ ������������� ���������
#confint(fit)#������������� ���������
#durbinWatsonTest(fit)#���� �������-�������
#crPlots(fit)#������� ��������� ��������



library(ISLR)
#attach(dataset)
#smp_siz = floor(0.75*nrow(dataset))#���������� ������(75% - train, 25% - test)
#set.seed(123)  
#train_ind = sample(seq_len(nrow(dataset)),size = smp_siz)  
#train = dataset[train_ind,]
#test = dataset[-train_ind,]
#��� ������������ ����� 3 �������� �����e(poro, visc, time)


testwithoutetta1 <- subset(dataset, select = -ldc.ettas8_10_2 )#������ ��� ����
testwithoutetta2 <- subset(testwithoutetta1, select = -ldc.ettas8_10_1 )#������ ��� ����
testwithoutetta3 <- subset(testwithoutetta2, select = -ldc.ettas8_10_0 )#������ ��� ����

set.seed(1)  
#1 - 8 month
smp_siz1 = floor(0.75*nrow(testwithoutetta3))#���������� ������(75% - train, 25% - test) ��� ����
train_ind1 = sample(seq_len(nrow(testwithoutetta3)),size = smp_siz1)
test1 = dataset[-train_ind1,] #������ �� ������������
predswithoutetta1 <- as.data.frame(predict(fit1, newdata = test1))#������������ ������(poro, visc, time)

set.seed(1)
#2 - 9 month
smp_siz2 = floor(0.75*nrow(testwithoutetta2))#���������� ������(75% - train, 25% - test) ��� ����
train_ind2 = sample(seq_len(nrow(testwithoutetta2)),size = smp_siz2)
test2 = dataset[-train_ind2,] #������ �� ������������
predswithoutetta2 <- as.data.frame(predict(fit2, newdata = test2))#������������ ������(poro, visc, time)

set.seed(1)
#3 - 10 month
smp_siz3 = floor(0.75*nrow(testwithoutetta1))#���������� ������(75% - train, 25% - test) ��� ����
train_ind3 = sample(seq_len(nrow(testwithoutetta1)),size = smp_siz3)
test3 = dataset[-train_ind3,] #������ �� ������������
predswithoutetta3 <- as.data.frame(predict(fit3, newdata = test3))#������������ ������(poro, visc, time)

toptest1 <- test1

toptest1$pred8 <- predswithoutetta1$`predict(fit1, newdata = test1)`
toptest1$pred9 <- predswithoutetta2$`predict(fit2, newdata = test2)`
toptest1$pred10 <- predswithoutetta3$`predict(fit3, newdata = test3)`


#View(predswithoutetta)#���������!!!



scatterplotMatrix(toptest1,spread = FALSE, lty.smooth = 2, main ='����������� ���� ����������')#plot view



library(writexl)
write_csv(x = as.data.frame(transport), path = "Pred.csv", col_names = TRUE)
write_xlsx(x = as.data.frame(transport), path = "Pred.xlsx", col_names = TRUE)



scatter3d(x = toptest1$ldc.poro, y = toptest1$ldc.visc,z =  toptest1$pred8 )


library("car")
t1 <- subset(subset(subset(subset(subset(toptest1, select = -pred10 ), select = -pred9 ), select = -pred8 ), select = -ldc.poro ), select = -ldc.visc )
#names(t1)<-c("1","2","3","4","5","6","7","8","9","10","11","12","13")
#t1[nrow(t1) + 1,] = c("1","2","3","4","5","6","7","8","9","10","11","12","13")

transport <- as.matrix(t1)


#plot(0:9, vector, col = 'blue')



scatter3d(  y = peace$iteratio, x = peace$times ,z = peace$etta)













vector <- matrix(nrow = 1000,ncol = 3)
n = 1

s = 1

i = 1

h = 1
repeat
{
  vector[s, 1] <- n
  vector[s, 2] <- i
  vector[s, 3] <- transport[n, i]
  
  s = s + 1
  i = i + 1
  if(i == 11) {
    n = n + 1
    i = 1
  }
  if (s == 1001) break
}




