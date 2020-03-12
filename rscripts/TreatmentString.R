library("stringr")

text <- stringr::str_trunc(as.character(group_tf_idf[1,2]), 500)

for(i in length(group_tf_idf$group_id)) {
  text <- stringr::str_trunc(as.character(group_tf_idf[i,2]), 200)
  group_tf_idf[i,2] < text
}

sentences <- sub("http://([[:alnum:]|[:punct:]])+", '', group_tf_idf$text)
corpus = tm::Corpus(tm::VectorSource(sentences))

corpus <- tm::tm_map(corpus, function(x) iconv(x, to = 'UTF-8', sub = 'byte'))
corpus <- tm::tm_map(corpus, tm::stripWhitespace)

write.csv(group_tf_idf,"treat.csv")

text <- stringr::str_trunc(as.character(neut[1,2]), 500)

first<-sub('\\[.*]','',text)
second<-sub('.*\\[(.*)\\]','\\1',text)
paste(first,'[',first,'==',second,']',sep='')

text <- stringr::str_trunc(, 500)






setwd("C:/Zhastay's files/PythonProjects/Trainer/dataset")


my_data <- read.delim("neutral.txt", encoding='UTF-8')
neut <- data.frame(1:6236)
neut$text <- my_data[,1]
for(i in 1:6236) {
  neut[i,1] = 0
}
colnames(neut)[1] <- "sample"



my_data <- read.delim("extra.txt", encoding='UTF-8')
extra <- data.frame(1:163)
extra$text <- my_data[,1]
for(i in 1:163) {
  extra[i,1] = 1
}
colnames(extra)[1] <- "sample"


library(dplyr)
finish <- union_all(neut,extra)

write.csv(finish, "finish.csv", fileEncoding = "utf8", row.names = FALSE, col.names = FALSE)

write_utf8_csv <- function(df, file) {
  firstline <- paste('"', names(df), '"', sep = "", collapse = ",")
  data <- apply(df, 1, function(x) {paste('', x, '', sep = "", collapse = ",")})
  writeLines(c(firstline, data), file , useBytes = TRUE)
}

write_utf8_csv(finish, "finish.csv")

text <- finish[1,2]

for(i in 1:6399) {
  finish[i,2] <- gsub('"', "", gsub(',', "", gsub('ׁ??נא??:', "", gsub('ׁ??׀ְ??:', "", finish[i,2]))))
}
