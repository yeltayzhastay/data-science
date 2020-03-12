library(RMySQL)

MyDataBase = dbConnect(MySQL(), user='netuser', password='987', dbname='gitlab', host='95.161.225.75')

dbGetQuery(MyDataBase,'set character set "utf8"')

DataDB = dbGetQuery(MyDataBase, "

SELECT id, owner_id, text FROM gitlab.vk_posts
where owner_id in (
	SELECT distinct (-1)*subscribed_group_id FROM gitlab.vk_user_subscriptions us
	left join gitlab.vk_groups g
	on us.subscribed_group_id = g.id
	where 
	subscribed_group_id is not null
	and subscribed_group_id != ''
	and user_id in 
	(
		SELECT vk_id FROM gitlab.quiz_user qu
		left join gitlab.r_vector rv
		on qu.user_id = rv.quiz_id
		where v1 is not null
		order by vk_id
	)
	and name != ''
)
and text != ''
and post_type = 'post' 
limit 500000;
                  
"
)


dbDisconnect(MyDataBase)


for(i in row.names(DataDB)) {
  Encoding(DataDB[i,3]) <- "UTF-8"
  DataDB[i,2] <- abs(DataDB[i,2])
}






