--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

-- Started on 2022-06-26 08:27:01

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
-- TOC entry 3385 (class 1262 OID 16578)
-- Name: api_goomer; Type: DATABASE; Schema: -; Owner: Abe
--

CREATE DATABASE api_goomer WITH TEMPLATE = template0 ENCODING = 'UTF8';



\connect api_goomer

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
-- TOC entry 220 (class 1255 OID 16579)
-- Name: check_category_func(); Type: FUNCTION; Schema: public; Owner: Abe
--

CREATE FUNCTION public.check_category_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--trata o intervalo de tempo para ser valido
	if ( EXISTS(SELECT * FROM product WHERE OLD.cat_id = product.cat_id)) then
		raise exception 'cannot delete or change the category being used';
	elsif (TG_OP = 'DELETE') THEN
            return old;
    ELSIF (TG_OP = 'UPDATE') THEN
        	return new;
	end if;
END
$$;


ALTER FUNCTION public.check_category_func() OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 16580)
-- Name: check_promo_func(); Type: FUNCTION; Schema: public; Owner: Abe
--

CREATE FUNCTION public.check_promo_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--verifica a existencia da promocao antes de inserir horas
	if ( EXISTS(SELECT * FROM promo_product as pp WHERE new.prod_id = pp.prod_id)) then
		return new;
	else 
        raise exception 'cannot insert or change a promo_time without prod_id in promotion';
	end if;
END
$$;


ALTER FUNCTION public.check_promo_func() OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 16581)
-- Name: interval_func(); Type: FUNCTION; Schema: public; Owner: Abe
--

CREATE FUNCTION public.interval_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--trata o intervalo de tempo para ser valido
	if ( NEW.op_opening >= NEW.op_closing) then
		raise exception 'Interval time incorect!!';
	else 
		return new;
	end if;
END
$$;


ALTER FUNCTION public.interval_func() OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 16582)
-- Name: interval_promo_func(); Type: FUNCTION; Schema: public; Owner: Abe
--

CREATE FUNCTION public.interval_promo_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--trata o intervalo de tempo para ser valido
	if ( NEW.proti_timeinit >= NEW.proti_timeend) then
		raise exception 'Interval time incorect!!';
	else 
		return new;
	end if;
END
$$;


ALTER FUNCTION public.interval_promo_func() OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 16583)
-- Name: minute_func(); Type: FUNCTION; Schema: public; Owner: Abe
--

CREATE FUNCTION public.minute_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--trata os minutos para serem multiplos de 15 (0, 15, 30, 45)
	if (SELECT EXTRACT(MINUTE FROM NEW.op_opening))%15 != 0 then
		raise exception 'Minute value op_opening not multiple of 15';
	end if; 
	if (SELECT EXTRACT(MINUTE FROM NEW.op_closing))%15 != 0 then
		raise exception 'Minute value op_closing not multiple of 15';
	else
		return new;
	end if;
END
$$;


ALTER FUNCTION public.minute_func() OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 16584)
-- Name: minute_promo_func(); Type: FUNCTION; Schema: public; Owner: Abe
--

CREATE FUNCTION public.minute_promo_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--trata os minutos para serem multiplos de 15 (0, 15, 30, 45)
	if (SELECT EXTRACT(MINUTE FROM NEW.proti_timeinit))%15 != 0 then
		raise exception 'Minute value proti_timeinit not multiple of 15';
	end if; 
	if (SELECT EXTRACT(MINUTE FROM NEW.proti_timeend))%15 != 0 then
		raise exception 'Minute value proti_timeend not multiple of 15';
	else
		return new;
	end if;
END
$$;


ALTER FUNCTION public.minute_promo_func() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16585)
-- Name: category_prod; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.category_prod (
    cat_id integer NOT NULL,
    cat_name character varying(30) NOT NULL
);


ALTER TABLE public.category_prod OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16588)
-- Name: category_prod_cat_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.category_prod_cat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_prod_cat_id_seq OWNER TO postgres;

--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 210
-- Name: category_prod_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.category_prod_cat_id_seq OWNED BY public.category_prod.cat_id;


--
-- TOC entry 211 (class 1259 OID 16589)
-- Name: opening_hours; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.opening_hours (
    rest_id integer NOT NULL,
    op_opening time(0) without time zone NOT NULL,
    op_closing time(0) without time zone NOT NULL,
    op_day character varying(10) NOT NULL,
    op_id integer NOT NULL
);


ALTER TABLE public.opening_hours OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16592)
-- Name: opening_hours_op_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.opening_hours_op_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.opening_hours_op_id_seq OWNER TO postgres;

--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 212
-- Name: opening_hours_op_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.opening_hours_op_id_seq OWNED BY public.opening_hours.op_id;


--
-- TOC entry 213 (class 1259 OID 16593)
-- Name: product; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.product (
    prod_id integer NOT NULL,
    rest_id integer NOT NULL,
    prod_name character varying NOT NULL,
    prod_price numeric NOT NULL,
    prod_photo bytea,
    cat_id integer NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16598)
-- Name: product_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.product_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_prod_id_seq OWNER TO postgres;

--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 214
-- Name: product_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.product_prod_id_seq OWNED BY public.product.prod_id;


--
-- TOC entry 215 (class 1259 OID 16599)
-- Name: promo_product; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.promo_product (
    prod_id integer NOT NULL,
    promo_description character varying(100) NOT NULL,
    promo_price numeric NOT NULL
);


ALTER TABLE public.promo_product OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16604)
-- Name: promo_time; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.promo_time (
    proti_id integer NOT NULL,
    prod_id integer NOT NULL,
    proti_timeinit time(0) without time zone NOT NULL,
    proti_timeend time(0) without time zone NOT NULL,
    proti_day character varying(10) NOT NULL
);


ALTER TABLE public.promo_time OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16607)
-- Name: promo_time_proti_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.promo_time_proti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promo_time_proti_id_seq OWNER TO postgres;

--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 217
-- Name: promo_time_proti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.promo_time_proti_id_seq OWNED BY public.promo_time.proti_id;


--
-- TOC entry 218 (class 1259 OID 16608)
-- Name: restaurant; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.restaurant (
    rest_id integer NOT NULL,
    rest_name character varying(50) NOT NULL,
    rest_adress character varying(50) NOT NULL,
    rest_photo bytea
);


ALTER TABLE public.restaurant OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16613)
-- Name: restaurant_rest_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.restaurant_rest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restaurant_rest_id_seq OWNER TO postgres;

--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 219
-- Name: restaurant_rest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.restaurant_rest_id_seq OWNED BY public.restaurant.rest_id;


--
-- TOC entry 3194 (class 2604 OID 16614)
-- Name: category_prod cat_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.category_prod ALTER COLUMN cat_id SET DEFAULT nextval('public.category_prod_cat_id_seq'::regclass);


--
-- TOC entry 3195 (class 2604 OID 16615)
-- Name: opening_hours op_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours ALTER COLUMN op_id SET DEFAULT nextval('public.opening_hours_op_id_seq'::regclass);


--
-- TOC entry 3196 (class 2604 OID 16616)
-- Name: product prod_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product ALTER COLUMN prod_id SET DEFAULT nextval('public.product_prod_id_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 16617)
-- Name: promo_time proti_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time ALTER COLUMN proti_id SET DEFAULT nextval('public.promo_time_proti_id_seq'::regclass);


--
-- TOC entry 3198 (class 2604 OID 16618)
-- Name: restaurant rest_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.restaurant ALTER COLUMN rest_id SET DEFAULT nextval('public.restaurant_rest_id_seq'::regclass);


--
-- TOC entry 3369 (class 0 OID 16585)
-- Dependencies: 209
-- Data for Name: category_prod; Type: TABLE DATA; Schema: public; Owner: Abe
--

INSERT INTO public.category_prod VALUES (1, 'Bebidas');
INSERT INTO public.category_prod VALUES (2, 'Lanches');
INSERT INTO public.category_prod VALUES (3, 'Acompanhamentos');
INSERT INTO public.category_prod VALUES (4, 'Sobremesa');
INSERT INTO public.category_prod VALUES (5, 'Pizza');
INSERT INTO public.category_prod VALUES (6, 'Vegetariano');
INSERT INTO public.category_prod VALUES (7, 'Vegano');
INSERT INTO public.category_prod VALUES (8, 'Massas');
INSERT INTO public.category_prod VALUES (9, 'Sorvete');
INSERT INTO public.category_prod VALUES (10, 'Almoco/Janta');


--
-- TOC entry 3371 (class 0 OID 16589)
-- Dependencies: 211
-- Data for Name: opening_hours; Type: TABLE DATA; Schema: public; Owner: Abe
--

INSERT INTO public.opening_hours VALUES (1, '09:00:00', '18:00:00', 'Segunda', 1);
INSERT INTO public.opening_hours VALUES (1, '09:00:00', '18:00:00', 'Terça', 2);
INSERT INTO public.opening_hours VALUES (1, '09:00:00', '18:00:00', 'Quarta', 3);
INSERT INTO public.opening_hours VALUES (1, '10:00:00', '18:00:00', 'Quinta', 5);
INSERT INTO public.opening_hours VALUES (1, '10:00:00', '18:00:00', 'Sexta', 6);
INSERT INTO public.opening_hours VALUES (2, '08:00:00', '16:00:00', 'Segunda', 7);
INSERT INTO public.opening_hours VALUES (2, '08:00:00', '16:00:00', 'Terça', 8);
INSERT INTO public.opening_hours VALUES (2, '08:00:00', '16:00:00', 'Quarta', 9);
INSERT INTO public.opening_hours VALUES (2, '08:00:00', '16:00:00', 'Quinta', 10);
INSERT INTO public.opening_hours VALUES (2, '08:00:00', '16:00:00', 'Sexta', 11);
INSERT INTO public.opening_hours VALUES (3, '15:00:00', '21:00:00', 'Segunda', 12);
INSERT INTO public.opening_hours VALUES (3, '15:00:00', '21:00:00', 'Terça', 13);
INSERT INTO public.opening_hours VALUES (3, '15:00:00', '21:00:00', 'Quarta', 14);
INSERT INTO public.opening_hours VALUES (3, '15:00:00', '21:00:00', 'Quinta', 15);
INSERT INTO public.opening_hours VALUES (3, '15:00:00', '21:00:00', 'Sexta', 16);
INSERT INTO public.opening_hours VALUES (4, '09:00:00', '21:00:00', 'Segunda', 17);
INSERT INTO public.opening_hours VALUES (4, '09:00:00', '21:00:00', 'Terça', 18);
INSERT INTO public.opening_hours VALUES (4, '09:00:00', '21:00:00', 'Quarta', 19);
INSERT INTO public.opening_hours VALUES (4, '09:00:00', '21:00:00', 'Quinta', 20);
INSERT INTO public.opening_hours VALUES (4, '09:00:00', '21:00:00', 'Sexta', 21);
INSERT INTO public.opening_hours VALUES (5, '08:00:00', '10:00:00', 'Segunda', 27);


--
-- TOC entry 3373 (class 0 OID 16593)
-- Dependencies: 213
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: Abe
--

INSERT INTO public.product VALUES (1, 1, 'Duplo Cheddar', 15.90, NULL, 2);
INSERT INTO public.product VALUES (2, 1, 'Duplo Rodeio', 15.90, NULL, 2);
INSERT INTO public.product VALUES (3, 3, 'Refrigerante Lata', 6.90, NULL, 1);
INSERT INTO public.product VALUES (4, 7, 'Suco ', 14.90, NULL, 1);
INSERT INTO public.product VALUES (5, 7, 'Batata Frita', 26.50, NULL, 2);
INSERT INTO public.product VALUES (6, 5, 'Pizza Média', 35.90, NULL, 5);
INSERT INTO public.product VALUES (7, 5, 'Pizza Grande', 45.90, NULL, 5);
INSERT INTO public.product VALUES (8, 6, 'Sorvete Casquinha', 4.00, NULL, 9);
INSERT INTO public.product VALUES (9, 8, 'Milk Shake', 8.00, NULL, 9);
INSERT INTO public.product VALUES (10, 7, 'Refrigerante Lata', 10.90, NULL, 1);
INSERT INTO public.product VALUES (11, 1, 'Refrigerante Lata', 11.90, NULL, 1);
INSERT INTO public.product VALUES (12, 4, 'Refrigerante 1L', 16.90, NULL, 1);
INSERT INTO public.product VALUES (13, 5, 'Refrigerante 1L', 14.50, NULL, 1);
INSERT INTO public.product VALUES (14, 1, 'Duplo Cheeseburger', 15.90, NULL, 2);
INSERT INTO public.product VALUES (15, 2, 'Sanduiche 15cm', 15.90, NULL, 2);
INSERT INTO public.product VALUES (16, 2, 'Sanduiche 30cm', 21.90, NULL, 2);
INSERT INTO public.product VALUES (17, 2, 'Refrigerante Lata', 7.60, NULL, 1);
INSERT INTO public.product VALUES (18, 4, 'Marmita Pequena', 10.90, NULL, 10);
INSERT INTO public.product VALUES (19, 4, 'Marmita Grande', 16.90, NULL, 10);
INSERT INTO public.product VALUES (20, 4, 'Prato Feito 250g', 13.75, NULL, 10);
INSERT INTO public.product VALUES (22, 5, 'Pizza Doce', 49.90, NULL, 5);


--
-- TOC entry 3375 (class 0 OID 16599)
-- Dependencies: 215
-- Data for Name: promo_product; Type: TABLE DATA; Schema: public; Owner: Abe
--

INSERT INTO public.promo_product VALUES (2, 'Duplo Rodeio com desconto imperdivel!', 13.50);


--
-- TOC entry 3376 (class 0 OID 16604)
-- Dependencies: 216
-- Data for Name: promo_time; Type: TABLE DATA; Schema: public; Owner: Abe
--

INSERT INTO public.promo_time VALUES (11, 2, '10:00:00', '20:00:00', 'Segunda');
INSERT INTO public.promo_time VALUES (14, 2, '10:00:00', '20:00:00', 'Terça');
INSERT INTO public.promo_time VALUES (16, 2, '10:00:00', '20:00:00', 'Quarta');


--
-- TOC entry 3378 (class 0 OID 16608)
-- Dependencies: 218
-- Data for Name: restaurant; Type: TABLE DATA; Schema: public; Owner: Abe
--

INSERT INTO public.restaurant VALUES (1, 'Burger King ', 'Av. Nossa Senhora da Penha, 2534', NULL);
INSERT INTO public.restaurant VALUES (2, 'Subway Ufes', 'R. Darcy Grijó, 50', NULL);
INSERT INTO public.restaurant VALUES (3, 'Rock Burger ', 'R. Silvino Grecco, 800', NULL);
INSERT INTO public.restaurant VALUES (5, 'Pizza Hut', 'Av. Américo Buaiz, 200', NULL);
INSERT INTO public.restaurant VALUES (6, 'Chiquinho Sorvetes', 'R. João da Cruz, 340', NULL);
INSERT INTO public.restaurant VALUES (8, 'Chiquinho Sorvetes', 'Av. Anisio Fernandes Coelho, 1715', NULL);
INSERT INTO public.restaurant VALUES (7, 'Burger King ', 'Av. Américo Buaiz, 200', NULL);
INSERT INTO public.restaurant VALUES (4, 'Paladar de Mel', 'Santa Tereza, 321', NULL);
INSERT INTO public.restaurant VALUES (9, 'teste', 'rua teste', NULL);


--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 210
-- Name: category_prod_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.category_prod_cat_id_seq', 11, true);


--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 212
-- Name: opening_hours_op_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.opening_hours_op_id_seq', 27, true);


--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 214
-- Name: product_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.product_prod_id_seq', 24, true);


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 217
-- Name: promo_time_proti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.promo_time_proti_id_seq', 19, true);


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 219
-- Name: restaurant_rest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.restaurant_rest_id_seq', 10, true);


--
-- TOC entry 3200 (class 2606 OID 16620)
-- Name: category_prod cat_name_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.category_prod
    ADD CONSTRAINT cat_name_unique UNIQUE (cat_name);


--
-- TOC entry 3202 (class 2606 OID 16622)
-- Name: category_prod category_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.category_prod
    ADD CONSTRAINT category_prod_pkey PRIMARY KEY (cat_id);


--
-- TOC entry 3204 (class 2606 OID 16624)
-- Name: opening_hours day_work_rest_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT day_work_rest_unique UNIQUE (op_day, rest_id);


--
-- TOC entry 3206 (class 2606 OID 16626)
-- Name: opening_hours opening_hours_PK; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT "opening_hours_PK" PRIMARY KEY (op_id, rest_id);


--
-- TOC entry 3208 (class 2606 OID 16628)
-- Name: product prod_per_rest_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT prod_per_rest_unique UNIQUE (rest_id, prod_name);


--
-- TOC entry 3210 (class 2606 OID 16630)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (prod_id);


--
-- TOC entry 3214 (class 2606 OID 16632)
-- Name: promo_time promotion_per_day_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time
    ADD CONSTRAINT promotion_per_day_unique UNIQUE (proti_day, prod_id);


--
-- TOC entry 3216 (class 2606 OID 16634)
-- Name: promo_time proti_id_pk; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time
    ADD CONSTRAINT proti_id_pk PRIMARY KEY (proti_id);


--
-- TOC entry 3218 (class 2606 OID 16636)
-- Name: restaurant restaurant_pkey; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_pkey PRIMARY KEY (rest_id);


--
-- TOC entry 3212 (class 2606 OID 16638)
-- Name: promo_product weak_prod_promo_id; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_product
    ADD CONSTRAINT weak_prod_promo_id PRIMARY KEY (prod_id);


--
-- TOC entry 3224 (class 2620 OID 16639)
-- Name: category_prod check_category_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER check_category_trigger BEFORE DELETE OR UPDATE ON public.category_prod FOR EACH ROW EXECUTE FUNCTION public.check_category_func();


--
-- TOC entry 3229 (class 2620 OID 16640)
-- Name: promo_time check_promo_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER check_promo_trigger BEFORE INSERT OR UPDATE ON public.promo_time FOR EACH ROW EXECUTE FUNCTION public.check_promo_func();


--
-- TOC entry 3228 (class 2620 OID 16641)
-- Name: promo_time interval_promo_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER interval_promo_trigger BEFORE INSERT OR UPDATE ON public.promo_time FOR EACH ROW EXECUTE FUNCTION public.interval_promo_func();


--
-- TOC entry 3226 (class 2620 OID 16642)
-- Name: opening_hours interval_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER interval_trigger BEFORE INSERT OR UPDATE ON public.opening_hours FOR EACH ROW EXECUTE FUNCTION public.interval_func();


--
-- TOC entry 3227 (class 2620 OID 16643)
-- Name: promo_time minute_promo_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER minute_promo_trigger BEFORE INSERT OR UPDATE ON public.promo_time FOR EACH ROW EXECUTE FUNCTION public.minute_promo_func();


--
-- TOC entry 3225 (class 2620 OID 16644)
-- Name: opening_hours minute_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER minute_trigger BEFORE INSERT OR UPDATE ON public.opening_hours FOR EACH ROW EXECUTE FUNCTION public.minute_func();


--
-- TOC entry 3220 (class 2606 OID 16645)
-- Name: product cat_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT cat_id_fk FOREIGN KEY (cat_id) REFERENCES public.category_prod(cat_id) NOT VALID;


--
-- TOC entry 3222 (class 2606 OID 16650)
-- Name: promo_product prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_product
    ADD CONSTRAINT prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.product(prod_id) ON DELETE CASCADE;


--
-- TOC entry 3223 (class 2606 OID 16655)
-- Name: promo_time promo_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time
    ADD CONSTRAINT promo_product_id_fk FOREIGN KEY (prod_id) REFERENCES public.promo_product(prod_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3221 (class 2606 OID 16660)
-- Name: product rest_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT rest_id_fk FOREIGN KEY (rest_id) REFERENCES public.restaurant(rest_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3219 (class 2606 OID 16665)
-- Name: opening_hours rest_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT rest_id_fk FOREIGN KEY (rest_id) REFERENCES public.restaurant(rest_id) ON DELETE CASCADE NOT VALID;


-- Completed on 2022-06-26 08:27:01

--
-- PostgreSQL database dump complete
--

