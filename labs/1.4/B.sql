

--Dirty read
begin;
select capitalization from owners where name = 'John Doe';--1

select capitalization from owners where name = 'John Doe';--3
end;

--Non-repeatable read
begin;
select capitalization from owners where name = 'John Doe';--1

select capitalization from owners where name = 'John Doe';--3
end;

--Lost changes
begin;
update owners set capitalization=capitalization+1000 where name = 'John Doe';--2
end;

--phantoms
begin;
select owner_id from owners where name='Jane Smith';--1

select owner_id from owners where name='Jane Smith';--3
end;
