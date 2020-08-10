#Cхема базы лежит картинкой в этом коммите.
#Задача 1.
#Запрос без сущностей, только пользователи

select user.id, user.name,
    (select count(*)
        from social_network.`like`
        where `like`.source_user_id = user.id
    ) as likes_given,
    (    (select count(*)
        from social_network.`like`
        where `like`.destination_user_id = user.id
    ) as likes_given,
    (select count(*)
        from social_network.`like` as l1
        join social_network.`like` as l2 on l1.source_user_id = l2.destination_user_id
		and l2.source_user_id = l1.destination_user_id
		and l1.source_user_id = user.id
    ) as mutual
from social_network.user

#Запрос с сущностями. Какая-то жесть. Но я сделялъ, так что оставлю. 
#Можно ли в больших запросах использовать функции? Очень хочется

select user.id, user.name,
    (select count(*)
        from social_network.`like`
        where `like`.source_user_id = user.id
            and (select entity.entity_type_id
            from social_network.entity
            where `like`.destination_entity_id = entity.id) = 1 #здесь должна быть функция поиска id по  названию
    ) as likes_given,
    (select count(*)
        from social_network.`like`
        join social_network.entity on `like`.destination_entity_id = entity.id
        where entity.owner_id = user.id
            and entity.entity_type_id = (select entity_type.id
            from social_network.entity_type
            where entity_type.name = 'user')
    ) as likes_taken,
    (select count(*)
        from social_network.`like` as l1
        join social_network.`like` as l2 on l1.source_user_id = (select entity.owner_id
            from social_network.entity
            where entity.id = l2.destination_entity_id
            ) and l2.source_user_id = (select entity.owner_id
            from social_network.entity
            where entity.id = l1.destination_entity_id
            )
        where l1.source_user_id = user.id
            and (select entity.entity_type_id
            from social_network.entity
            where l1.destination_entity_id = entity.id) = 1 #здесь должна быть функция поиска id по  названию
    ) as mutual
from social_network.user

#Задача 2.

select user.id, user.name
from social_network.user
join social_network.`like` on user.id = `like`.source_user_id
where (select count(*)
        from social_network.`like`
        where `like`.destination_entity_id = 7
        and `like`.source_user_id = user.id) > 0
    and (select count(*)
        from social_network.`like`
        where `like`.destination_entity_id = 8
        and `like`.source_user_id = user.id) > 0
    and (select count(*)
        from social_network.`like`
        where `like`.destination_entity_id = 9
        and `like`.source_user_id = user.id) = 0
group by user.id, user.name

/*Задача 3. 
1 пользователь не может дважды лайкнуть одну и ту же сущность
Сделать первичный ключ для лайка по like.id и like.destinatation_entity_id

Остальное в структуре базы учтено.

