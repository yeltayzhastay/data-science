SELECT distinct subscribed_group_id, g.name FROM gitlab.vk_user_subscriptions us
left join gitlab.vk_groups g
on us.subscribed_group_id = g.id
where 
subscribed_group_id is not null
and subscribed_group_id != ''
and user_id in 
(
	SELECT u.id FROM gitlab.vk_users u
	left join gitlab.vk_user_personal p
	on u.id = p.user_id
	where u.id in (
		SELECT user_id FROM gitlab.vk_user_personal
		where political != 0
		and people_main != 0
		and life_main != 0
		and smoking != 0
		and alcohol != 0
	)
	order by u.id
)
and name != ''