--Dirty read
begin;
update owners
set capitalization=capitalization + 1000
where name = 'John Doe';--2
rollback;
--4

--Non-repeatable read
begin;
update owners
set capitalization=capitalization + 1000
where name = 'John Doe';
end;
--2

--Lost update
begin;
update owners
set capitalization=capitalization + 1000
where name = 'John Doe';--1
end;

begin;
select capitalization
from owners
where name = 'John Doe'; --3
end;


--phantoms
begin;
update owners
set name='Jane Smith'
where owner_id = 3;
end;--2

begin;
update owners
set name='Bob Marley'
where owner_id = 3;
commit;
--4


--serialization anomaly
begin;
select owner_id, name
from owners
where owner_id in (1, 2);

update owners
set name='John Doe'
where name = 'Jane Smith';
end;