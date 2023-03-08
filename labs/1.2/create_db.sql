begin;

create table owners
(
    owner_id       serial primary key,
    name           text not null,
    capitalization bigint
);

create table languages
(
    language_id serial primary key,
    name        text not null
);

create table services
(
    service_id   serial primary key,
    name         text    not null,
    price        integer not null,
    owner_id     integer references owners (owner_id),
    language_id  integer references languages (language_id),
    version      integer,
    description  text,
    contains_ads boolean
);

create table users
(
    user_id     serial primary key,
    name        text,
    age         integer,
    balance     integer,
    language_id integer references languages (language_id) on delete set null
);

create table subscriptions
(
    service_id integer REFERENCES services (service_id),
    user_id    integer REFERENCES users (user_id),
    start_date date not null,
    end_date   date not null,
    PRIMARY KEY (service_id, user_id)
);

end;

