--Создать пользователя test и выдать ему доступ к базе данных.
create user test login password '123';
grant connect on database postgres to test;

--Составить и выполнить скрипты присвоения новому пользователю
-- прав доступа к таблицам, созданным в практическом задании
-- №1.1. При этом права доступа к различным таблицам должны быть различными, а именно:
--По крайней мере, для одной таблицы новому пользователю
-- присваиваются права SELECT, INSERT, UPDATE в полном объеме.

grant update, select, insert on users to test;
grant update, select, insert on users_user_id_seq to test;
--По крайней мере, для одной таблицы новому пользователю
-- присваиваются права SELECT и UPDATE только избранных столбцов.
grant update, select on languages to test;

--По крайней мере, для одной таблицы новому пользователю присваивается только право SELECT.
grant select on services to test;

--Составить SQL-скрипты для создания нескольких представлений, которые позволяли
-- бы упростить манипуляции с данными или позволяли бы ограничить доступ к данным,
-- предоставляя только необходимую информацию.

create view users_with_their_countries as
select users.name, users.balance, l.name as language
from users
         join languages l on l.language_id = users.language_id;

create view greedy_owners as
select owner_id, count(contains_ads) as services_with_ads
from services group by owner_id;

--Присвоить новому пользователю право доступа (SELECT) к одному из представлений
grant select on users_with_their_countries to test;

--Создать стандартную роль уровня базы данных,
create role update_view_role;
-- присвоить ей право доступа (UPDATE на некоторые столбцы)
grant update(balance) on users_with_their_countries to test;
-- к одному из представлений, назначить новому пользователю созданную роль.
grant update_view_role to test;
--Выполнить от имени нового пользователя некоторые выборки из таблиц и представлений.
-- Убедиться в правильности контроля прав доступа.
set role test;
select * from users_with_their_countries;
select * from owners;


--Выполнить от имени нового пользователя операторы изменения
-- таблиц с ограниченными правами доступа. Убедиться в
-- правильности контроля прав доступа
INSERT INTO users (name, age, balance, language_id)
VALUES
    ('Alice Johnsonon', 25, 550, 2);

INSERT INTO languages (name)
                VALUES
                    ('Frakish');

set role postgres;


SELECT * FROM information_schema.role_column_grants where grantee='test';
\du