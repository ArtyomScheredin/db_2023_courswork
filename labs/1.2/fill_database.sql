begin;
--удаляем все строки
truncate subscriptions, users, services,owners,languages;

DO $$DECLARE r record;
BEGIN
    FOR r IN (SELECT relname FROM pg_class WHERE relkind = 'S') LOOP
            EXECUTE 'ALTER SEQUENCE ' || r.relname || ' RESTART WITH 1;';
        END LOOP;
END$$;


INSERT INTO owners (name, capitalization)
VALUES
    ('John Doe', 10000),
    ('Jane Smith', 50000),
    ('Michael Johnson', 75000),
    ('Emma Wilson', 20000),
    ('Andrew Davis', 15000),
    ('Jessica Lee', 40000),
    ('Daniel Brown', 100000),
    ('Olivia Jackson', 30000),
    ('William Thompson', 80000),
    ('Sophia Taylor', 60000);

INSERT INTO languages (name)
VALUES
    ('English'),
    ('French'),
    ('Russian'),
    ('Spanish'),
    ('Chinese'),
    ('German'),
    ('Italian'),
    ('Portuguese'),
    ('Arabic'),
    ('Japanese');

INSERT INTO services (name, price, owner_id, language_id, version, description, contains_ads)
VALUES
    ('Service 1', 10, 1, 1, 1, 1, false),
    ('Service 2', 20, 2, 2, 2, 2, true),
    ('Service 3', 30, 3, 3, 3, 3, false),
    ('Service 4', 40, 4, 4, 4, 4, true),
    ('Service 5', 50, 5, 5, 5, 5, false),
    ('Service 6', 60, 6, 6, 6, 6, true),
    ('Service 7', 70, 7, 7, 7, 7, false),
    ('Service 8', 80, 8, 8, 8, 8, true),
    ('Service 9', 90, 9, 9, 9, 9, false),
    ('Service 1', 90, 9, 2, 9, 39, false),
    ('Service 12', 120, 3, 6, 9, 29, true),
    ('Service 10', 100, 10, 10, 10, 10, true);

INSERT INTO users (name, age, balance, language_id)
VALUES
    ('Alice Johnson', 25, 500, 1),
    ('Bob Williams', 30, 1000, 2),
    ('Catherine Davis', 35, 1500, 3),
    ('David Wilson', 40, 2000, 4),
    ('Emily Brown', 45, 2500, 5),
    ('Frank Thompson', 50, 3000, 6),
    ('Grace Lee', 55, 3500, 7),
    ('Henry Jackson', 60, 4000, 8),
    ('Isabella Taylor', 65, 4500, 9),
    ('Jacob Smith', 70, 5000, 10);

INSERT INTO subscriptions (service_id, user_id, start_date, end_date)
VALUES
    (2, 2, '2022-02-01', '2022-07-31'),
    (3, 3, '2022-03-01', '2022-08-31'),
    (4, 4, '2022-04-01', '2022-09-30'),
    (5, 5, '2022-05-01', '2022-10-31'),
    (1, 1, '2022-01-01', '2022-12-31'),
    (6, 6, '2022-01-01', '2022-12-31'),
    (7, 7, '2022-01-01', '2022-12-31'),
    (8, 8, '2022-01-01', '2022-12-31'),
    (9, 9, '2022-01-01', '2022-12-31'),
    (10, 10, '2022-01-01', '2022-12-31'),
    (1, 2, '2022-01-01', '2022-12-31'),
    (2, 3, '2022-01-01', '2022-12-31'),
    (3, 4, '2022-01-01', '2022-12-31'),
    (4, 5, '2022-01-01', '2022-12-31'),
    (5, 6, '2022-01-01', '2022-12-31'),
    (6, 7, '2022-01-01', '2022-12-31'),
    (7, 8, '2022-01-01', '2022-12-31'),
    (8, 9, '2022-01-01', '2022-12-31'),
    (9, 10, '2022-01-01', '2022-12-31'),
    (10, 1, '2022-01-01', '2022-12-31');
end;