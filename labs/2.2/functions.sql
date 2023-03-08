create function who_is_user(text) returns text as
$$
declare
    balance integer := (select balance
                        from users
                        where name = $1);
    msg     text;
begin
    case
        when balance between 0 and 1999 then msg := 'нищеброд';
        when balance between 2000 and 4000 then msg := 'среднячок';
        when balance between 4000 and 10000 then msg := 'мажор';
        else msg := 'неопознанный товарищ';
        end case;
    return msg;
end;
$$ language plpgsql;


create procedure delete_services_with_zero_price() as
$$
declare
    id integer;
    cr1 cursor for select service_id
                   from services
                   where price = 0;
begin
    open cr1;
    fetch cr1 into id;
    if not found then
        raise exception 'нет бесплатных сервисов';
    else
        loop
            delete from services where service_id = id;
            delete from subscriptions where service_id = id;
            fetch cr1 into id;
            if not found then
                exit;
            end if;
        end loop;
    end if;
end;
$$ language plpgsql;

select who_is_user('Grace Lee');

begin;
insert into services (name, price, owner_id, language_id, version, description, contains_ads)
values ('Apple',
        0, 2, 2,
        312, 'one unknown phone manufacturer', false);
select *
from services where price=0;
call delete_services_with_zero_price();

select *
from services where price=0;
rollback;


