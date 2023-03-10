begin;
drop table owners, languages, services, users, subscriptions;

create table if not exists owners
(
    owner_id       serial primary key,
    name           text not null,
    capitalization bigint
);

create table if not exists languages
(
    language_id serial primary key,
    name        text not null
);

create table if not exists services
(
    service_id   serial primary key,
    name         text    not null,
    price        integer not null,
    owner_id     integer references owners (owner_id) on delete set null,
    language_id  integer references languages (language_id) on delete set null,
    version         integer,
    description  text,
    contains_ads boolean
);

create table if not exists users
(
    user_id     serial primary key,
    name        text,
    age         integer,
    balance     integer,
    language_id integer references languages (language_id) on delete set null
);

create table if not exists subscriptions
(
    service_id integer REFERENCES services (service_id) on delete set null,
    user_id    integer REFERENCES users (user_id) on delete set null,
    start_date date not null,
    end_date   date not null,
    PRIMARY KEY (service_id, user_id)
);

end;

