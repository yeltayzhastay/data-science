library(readr)
#group_tf_idf <- read_csv("C:/sample_dataset/PathToSolving/post/onlydesc/group_tf_idf.csv")#Данные
group_tf_idf <- read_csv("C:/sample_dataset/PathToSolving/post/group_tf_idf_7.csv")#Данные
groups <- read_csv("C:/sample_dataset/PathToSolving/post/groups.csv")#Данные


sentences <- sub("http://([[:alnum:]|[:punct:]])+", '', group_tf_idf$text)
#Получение предложении
corpus = tm::Corpus(tm::VectorSource(sentences))
#Получение корпуса


# Cleaning up
# Handling UTF-8 encoding problem from the dataset
#corpus.cleaned <- tm::tm_map(corpus, function(x) iconv(x, to = 'UTF-8', sub = 'byte'))
corpus.cleaned <- tm::tm_map(corpus, tm::removeWords, tm::stopwords('russian'))
# Removing stop-words
corpus.cleaned <- tm::tm_map(corpus, tm::stemDocument, language = "russian")
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
clustering.kmeans <- kmeans(tfidf.matrix, 70)
#truth.K = количество кластера


#Get the cluster data
dataframe <- as.data.frame(tfidf.matrix)
dataframe$cluster <- clustering.kmeans$cluster


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
  if(n == 70) break
}


data.frame(table(dataframe$cluster))


library("dplyr")
datacluster %>% group_by(factor1, factor2) %>% summarize(count=n())
