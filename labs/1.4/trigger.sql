--Триггер проверяет, что обновлённое значение капитализации является
--позитивным числом, в противном случае выбрасывает исключение
create or replace function check_positive_capitalization() returns trigger as
$$
begin
    if new.capitalization <= 0 then
        raise exception 'capitalization cannot be negative or zero';
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger check_positive_capitalization_trigger
    before insert or update of capitalization
    on owners
    for each row
execute function check_positive_capitalization();

begin;
update owners set capitalization=-1 where owner_id=2;
rollback;
