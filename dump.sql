--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Debian 13.3-1.pgdg100+1)
-- Dumped by pg_dump version 13.3 (Debian 13.3-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: delete_services_with_zero_price(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_services_with_zero_price()
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER PROCEDURE public.delete_services_with_zero_price() OWNER TO postgres;

--
-- Name: who_is_user(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.who_is_user(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION public.who_is_user(text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id integer NOT NULL,
    name text NOT NULL,
    price integer NOT NULL,
    owner_id integer,
    language_id integer,
    version integer,
    description text,
    contains_ads boolean
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: greedy_owners; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.greedy_owners AS
 SELECT services.owner_id,
    count(services.contains_ads) AS services_with_ads
   FROM public.services
  GROUP BY services.owner_id;


ALTER TABLE public.greedy_owners OWNER TO postgres;

--
-- Name: languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages (
    language_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.languages OWNER TO postgres;

--
-- Name: languages_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.languages_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.languages_language_id_seq OWNER TO postgres;

--
-- Name: languages_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.languages_language_id_seq OWNED BY public.languages.language_id;


--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    owner_id integer NOT NULL,
    name text NOT NULL,
    capitalization bigint
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: owners_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.owners_owner_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.owners_owner_id_seq OWNER TO postgres;

--
-- Name: owners_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.owners_owner_id_seq OWNED BY public.owners.owner_id;


--
-- Name: services_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_service_id_seq OWNER TO postgres;

--
-- Name: services_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_service_id_seq OWNED BY public.services.service_id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    service_id integer NOT NULL,
    user_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    name text,
    age integer,
    balance integer,
    language_id integer,
    CONSTRAINT balance_positive_check CHECK ((balance > 0))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: users_with_their_countries; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.users_with_their_countries AS
 SELECT users.name,
    users.balance,
    l.name AS language
   FROM (public.users
     JOIN public.languages l ON ((l.language_id = users.language_id)));


ALTER TABLE public.users_with_their_countries OWNER TO postgres;

--
-- Name: languages language_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages ALTER COLUMN language_id SET DEFAULT nextval('public.languages_language_id_seq'::regclass);


--
-- Name: owners owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners ALTER COLUMN owner_id SET DEFAULT nextval('public.owners_owner_id_seq'::regclass);


--
-- Name: services service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.services_service_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.languages (language_id, name) FROM stdin;
1	English
2	French
3	Russian
4	Spanish
5	Chinese
6	German
7	Italian
8	Portuguese
9	Arabic
10	Japanese
\.


--
-- Data for Name: owners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.owners (owner_id, name, capitalization) FROM stdin;
1	John Doe	10000
2	Jane Smith	50000
3	Michael Johnson	75000
4	Emma Wilson	20000
5	Andrew Davis	15000
6	Jessica Lee	40000
7	Daniel Brown	100000
8	Olivia Jackson	30000
9	William Thompson	80000
10	Sophia Taylor	60000
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (service_id, name, price, owner_id, language_id, version, description, contains_ads) FROM stdin;
1	Service 1	10	1	1	1	1	f
2	Service 2	20	2	2	2	2	t
3	Service 3	30	3	3	3	3	f
4	Service 4	40	4	4	4	4	t
5	Service 5	50	5	5	5	5	f
6	Service 6	60	6	6	6	6	t
7	Service 7	70	7	7	7	7	f
8	Service 8	80	8	8	8	8	t
9	Service 9	90	9	9	9	9	f
10	Service 1	90	9	2	9	39	f
11	Service 12	120	3	6	9	29	t
12	Service 10	100	10	10	10	10	t
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscriptions (service_id, user_id, start_date, end_date) FROM stdin;
2	2	2022-02-01	2022-07-31
3	3	2022-03-01	2022-08-31
4	4	2022-04-01	2022-09-30
5	5	2022-05-01	2022-10-31
1	1	2022-01-01	2022-12-31
6	6	2022-01-01	2022-12-31
7	7	2022-01-01	2022-12-31
8	8	2022-01-01	2022-12-31
9	9	2022-01-01	2022-12-31
10	10	2022-01-01	2022-12-31
1	2	2022-01-01	2022-12-31
2	3	2022-01-01	2022-12-31
3	4	2022-01-01	2022-12-31
4	5	2022-01-01	2022-12-31
5	6	2022-01-01	2022-12-31
6	7	2022-01-01	2022-12-31
7	8	2022-01-01	2022-12-31
8	9	2022-01-01	2022-12-31
9	10	2022-01-01	2022-12-31
10	1	2022-01-01	2022-12-31
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, age, balance, language_id) FROM stdin;
1	Alice Johnson	25	500	1
2	Bob Williams	30	1000	2
3	Catherine Davis	35	1500	3
4	David Wilson	40	2000	4
5	Emily Brown	45	2500	5
6	Frank Thompson	50	3000	6
7	Grace Lee	55	3500	7
8	Henry Jackson	60	4000	8
9	Isabella Taylor	65	4500	9
10	Jacob Smith	70	5000	10
\.


--
-- Name: languages_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.languages_language_id_seq', 10, true);


--
-- Name: owners_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.owners_owner_id_seq', 10, true);


--
-- Name: services_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_service_id_seq', 13, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 10, true);


--
-- Name: services description_unique_constraint; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT description_unique_constraint UNIQUE (description);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (language_id);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (owner_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (service_id, user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: services services_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(language_id);


--
-- Name: services services_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(owner_id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: subscriptions subscriptions_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(service_id);


--
-- Name: subscriptions subscriptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: users users_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(language_id) ON DELETE SET NULL;


--
-- Name: TABLE services; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.services TO test;


--
-- Name: TABLE languages; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE public.languages TO test;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.users TO test;


--
-- Name: SEQUENCE users_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON SEQUENCE public.users_user_id_seq TO test;


--
-- Name: TABLE users_with_their_countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.users_with_their_countries TO test;


--
-- Name: COLUMN users_with_their_countries.balance; Type: ACL; Schema: public; Owner: postgres
--

GRANT UPDATE(balance) ON TABLE public.users_with_their_countries TO test;


--
-- PostgreSQL database dump complete
--

