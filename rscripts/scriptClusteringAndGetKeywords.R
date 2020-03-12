truth.k = 5

#Начало скрипта
library(readxl)
dataset <- read_excel("Обращения граждан.xlsx")
id <- subset(dataset$id,!is.na(dataset$id))
sentences <- subset(dataset$Обращение,!is.na(dataset$Обращение))
data <- data.frame(id,sentences)
#Получение чистых данных

#Начало класстеризации
sentences <- sub("http://([[:alnum:]|[:punct:]])+", '', data$sentences)
#Получение предложении
corpus = tm::Corpus(tm::VectorSource(sentences))
#Получение корпуса

# Cleaning up 
# Handling UTF-8 encoding problem from the dataset 
#corpus.cleaned <- tm::tm_map(corpus, function(x) iconv(x, to = 'UTF-8', sub = 'byte'))  
corpus.cleaned <- tm::tm_map(corpus, tm::removeWords, tm::stopwords('russian')) 
# Removing stop-words 
corpus.cleaned <- tm::tm_map(corpus.cleaned, tm::stemDocument, language = "russian") 
# Stemming the words  
corpus.cleaned <- tm::tm_map(corpus.cleaned, tm::stripWhitespace) 
# Trimming excessive whitespaces

#Нахождение TF-IDF
tdm <- tm::DocumentTermMatrix(corpus.cleaned) 
tdm.tfidf <- tm::weightTfIdf(tdm)
tdm.tfidf <- tm::removeSparseTerms(tdm.tfidf, 0.999)
tfidf.matrix <- as.matrix(tdm.tfidf) 
# Cosine distance matrix (useful for specific clustering algorithms) 
dist.matrix = proxy::dist(tfidf.matrix, method = "cosine")

#Алгоритм кластеризации
clustering.kmeans <- kmeans(tfidf.matrix, truth.k)
#truth.K = количество кластера

#Get the cluster data
dataframe <- as.data.frame(tfidf.matrix)
dataframe$cluster <- clustering.kmeans$cluster

#Получение ключевых слов
keywordlist = list()
n = 0
repeat
{
  n = n + 1
  keywordm <- as.matrix(subset(dataframe,dataframe$cluster == n))
  keywordmt = t(keywordm)
  #keywordmt = head(keywordmt,-1)
  keywordclear <- as.matrix(keywordmt[rowSums(keywordmt)>0,])
  #keywordclear <- keywordclear[,order(keywordclear)]
  keywordrn <- row.names(keywordclear)
  keywordlist[n] <- list(keywordrn)
  if(n == truth.k) break
}
n = 0
rm(dataset,dataframe,keywordclear,keywordm,keywordmt,keywordrn,tfidf.matrix,clustering.kmeans,corpus,corpus.cleaned,dist.matrix,id,n,tdm,tdm.tfidf,truth.k,sentences)
