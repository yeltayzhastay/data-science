SELECT u.id, p.political, p.people_main, p.life_main, p.smoking, p.alcohol FROM gitlab.vk_users u
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
order by u.id;