--Пользователи которые говорят на немецком или русском языках
select users.name, l.name
from users
         join languages l on l.language_id = users.language_id
where l.name in ('German', 'Russian');


--Топ 3 пользователя по потраченным деньгам
select u.user_id, first_value(u.name) over (PARTITION BY u.user_id), sum(s2.price) as money_spent
from users as u
         left join subscriptions s on u.user_id = s.user_id
         left join services s2 on s.service_id = s2.service_id
group by u.user_id
order by money_spent desc
limit 3;

--Владельцы с сервисами на двух и более различных языках
with owners_language_services as (select rank() over (partition by ow.name order by language_id) as language_count,
                                         ow.owner_id,
                                         ow.name
                                  from owners as ow
                                           join services s on ow.owner_id = s.owner_id)
select name, language_count
from owners_language_services
where language_count > 1;


--долой буржуев! удаляем владельцев продуктов с нативной рекламой
begin;
DELETE
from owners
where owner_id in (select owner_id from services where contains_ads = true);
select owners.owner_id, contains_ads
from owners
         join services s on owners.owner_id = s.owner_id;
rollback;

--Повышаем баланс русскоговорящим
begin;
update users
set balance=balance + 50510
where language_id = 3;
select *
from users where language_id=3;
rollback;

--добавляем предупреждение о том, что в сервисе содержится реклама
begin;
update services
set description=concat('contains ads! ', description)
where contains_ads = true;
select description
from services;
rollback;

--продлеваем подписки на 8 месяцев
begin;
update subscriptions
set end_date=end_date::date + interval '8 MONTH'
where service_id
          in (select service_id from services where owner_id=3);
select * from subscriptions where service_id
                                      in (select service_id from services where owner_id=3);
rollback;