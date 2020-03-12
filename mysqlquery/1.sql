SELECT user_id, subscribed_group_id FROM gitlab.vk_user_subscriptions
where user_id in (
SELECT u.id FROM gitlab.vk_users u
left join gitlab.vk_user_personal p
on u.id = p.user_id
where u.id in (
SELECT user_id FROM gitlab.vk_user_personal
where political != 0
and religion != ''
and people_main != 0
and life_main != 0
and smoking != 0
and alcohol != 0
)
and followers_count > 10
and count_posts > 50
and count_friends > 10)
and subscribed_group_id is not null
and subscribed_group_id != ''
and subscribed_group_id in 
(
SELECT id FROM gitlab.vk_groups
where id in (
SELECT subscribed_group_id FROM gitlab.vk_user_subscriptions
where user_id in (
SELECT u.id FROM gitlab.vk_users u
left join gitlab.vk_user_personal p
on u.id = p.user_id
where u.id in (
SELECT user_id FROM gitlab.vk_user_personal
where political != 0
and religion != ''
and people_main != 0
and life_main != 0
and smoking != 0
and alcohol != 0
)
and followers_count > 10
and count_posts > 50
and count_friends > 10)
)
and name != ''
)