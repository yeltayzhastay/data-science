library(readr)
group_posts <- read_csv("PathToSolving/group_posts.csv",
                        col_types = cols(id = col_integer(),
                                         owner_id = col_integer()))

groups <- read_csv("PathToSolving/groups.csv",
                   col_types = cols(subscribed_group_id = col_integer()))

group_posts <- group_posts[complete.cases(group_posts), ]

rf <- group_posts[,2]

tab <- unique(rf)

length(tab$owner_id)

tab[,2] <- NA

for(i in 1:length(tab$owner_id)) {
  s <- ''
  for(j in 1:length(group_posts$owner_id)) {
    if(tab[i,1] == group_posts[j,2]) {
      s <- paste(s, group_posts[j,3])
    }
  }
  tab[i,2] <- s
}


rm(tab, rf)
