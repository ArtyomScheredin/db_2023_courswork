
alter table services add constraint description_unique_constraint unique (description);
alter table users add constraint balance_positive_check check ( balance > 0 );
