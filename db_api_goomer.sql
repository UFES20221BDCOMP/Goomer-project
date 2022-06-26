--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

-- Started on 2022-06-25 07:50:35

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
-- TOC entry 3374 (class 1262 OID 24624)
-- Name: api_goomer; Type: DATABASE; Schema: -; Owner: Abe
--

CREATE DATABASE api_goomer WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE api_goomer OWNER TO "Abe";

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
-- TOC entry 225 (class 1255 OID 24740)
-- Name: check_category_func(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- TOC entry 226 (class 1255 OID 24800)
-- Name: check_promo_func(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- TOC entry 224 (class 1255 OID 24738)
-- Name: interval_func(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- TOC entry 236 (class 1255 OID 24789)
-- Name: interval_promo_func(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- TOC entry 220 (class 1255 OID 24731)
-- Name: minute_func(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- TOC entry 235 (class 1255 OID 24780)
-- Name: minute_promo_func(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- TOC entry 214 (class 1259 OID 24665)
-- Name: category_prod; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.category_prod (
    cat_id integer NOT NULL,
    cat_name character varying(30) NOT NULL
);


ALTER TABLE public.category_prod OWNER TO "Abe";

--
-- TOC entry 213 (class 1259 OID 24664)
-- Name: category_prod_cat_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.category_prod_cat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_prod_cat_id_seq OWNER TO "Abe";

--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 213
-- Name: category_prod_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.category_prod_cat_id_seq OWNED BY public.category_prod.cat_id;


--
-- TOC entry 215 (class 1259 OID 24684)
-- Name: opening_hours; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.opening_hours (
    rest_id integer NOT NULL,
    op_opening time(0) without time zone NOT NULL,
    op_closing time(0) without time zone NOT NULL,
    op_day character varying(10) NOT NULL,
    op_id integer NOT NULL
);


ALTER TABLE public.opening_hours OWNER TO "Abe";

--
-- TOC entry 219 (class 1259 OID 24791)
-- Name: opening_hours_op_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.opening_hours_op_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.opening_hours_op_id_seq OWNER TO "Abe";

--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 219
-- Name: opening_hours_op_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.opening_hours_op_id_seq OWNED BY public.opening_hours.op_id;


--
-- TOC entry 212 (class 1259 OID 24646)
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


ALTER TABLE public.product OWNER TO "Abe";

--
-- TOC entry 211 (class 1259 OID 24645)
-- Name: product_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.product_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_prod_id_seq OWNER TO "Abe";

--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 211
-- Name: product_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.product_prod_id_seq OWNED BY public.product.prod_id;


--
-- TOC entry 216 (class 1259 OID 24743)
-- Name: promo_product; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.promo_product (
    prod_id integer NOT NULL,
    promo_description character varying(100) NOT NULL,
    promo_price numeric NOT NULL
);


ALTER TABLE public.promo_product OWNER TO "Abe";

--
-- TOC entry 218 (class 1259 OID 24764)
-- Name: promo_time; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.promo_time (
    proti_id integer NOT NULL,
    prod_id integer NOT NULL,
    proti_timeinit time(0) without time zone NOT NULL,
    proti_timeend time(0) without time zone NOT NULL,
    proti_day character varying(10) NOT NULL
);


ALTER TABLE public.promo_time OWNER TO "Abe";

--
-- TOC entry 217 (class 1259 OID 24763)
-- Name: promo_time_proti_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.promo_time_proti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promo_time_proti_id_seq OWNER TO "Abe";

--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 217
-- Name: promo_time_proti_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.promo_time_proti_id_seq OWNED BY public.promo_time.proti_id;


--
-- TOC entry 210 (class 1259 OID 24635)
-- Name: restaurant; Type: TABLE; Schema: public; Owner: Abe
--

CREATE TABLE public.restaurant (
    rest_id integer NOT NULL,
    rest_name character varying(50) NOT NULL,
    rest_adress character varying(50) NOT NULL,
    rest_photo bytea
);


ALTER TABLE public.restaurant OWNER TO "Abe";

--
-- TOC entry 209 (class 1259 OID 24634)
-- Name: restaurant_rest_id_seq; Type: SEQUENCE; Schema: public; Owner: Abe
--

CREATE SEQUENCE public.restaurant_rest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restaurant_rest_id_seq OWNER TO "Abe";

--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 209
-- Name: restaurant_rest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Abe
--

ALTER SEQUENCE public.restaurant_rest_id_seq OWNED BY public.restaurant.rest_id;


--
-- TOC entry 3196 (class 2604 OID 24668)
-- Name: category_prod cat_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.category_prod ALTER COLUMN cat_id SET DEFAULT nextval('public.category_prod_cat_id_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 24792)
-- Name: opening_hours op_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours ALTER COLUMN op_id SET DEFAULT nextval('public.opening_hours_op_id_seq'::regclass);


--
-- TOC entry 3195 (class 2604 OID 24649)
-- Name: product prod_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product ALTER COLUMN prod_id SET DEFAULT nextval('public.product_prod_id_seq'::regclass);


--
-- TOC entry 3198 (class 2604 OID 24767)
-- Name: promo_time proti_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time ALTER COLUMN proti_id SET DEFAULT nextval('public.promo_time_proti_id_seq'::regclass);


--
-- TOC entry 3194 (class 2604 OID 24638)
-- Name: restaurant rest_id; Type: DEFAULT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.restaurant ALTER COLUMN rest_id SET DEFAULT nextval('public.restaurant_rest_id_seq'::regclass);


--
-- TOC entry 3206 (class 2606 OID 24672)
-- Name: category_prod cat_name_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.category_prod
    ADD CONSTRAINT cat_name_unique UNIQUE (cat_name);


--
-- TOC entry 3208 (class 2606 OID 24670)
-- Name: category_prod category_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.category_prod
    ADD CONSTRAINT category_prod_pkey PRIMARY KEY (cat_id);


--
-- TOC entry 3210 (class 2606 OID 24721)
-- Name: opening_hours day_work_rest_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT day_work_rest_unique UNIQUE (op_day, rest_id);


--
-- TOC entry 3212 (class 2606 OID 24798)
-- Name: opening_hours opening_hours_PK; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT "opening_hours_PK" PRIMARY KEY (op_id, rest_id);


--
-- TOC entry 3202 (class 2606 OID 24683)
-- Name: product prod_per_rest_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT prod_per_rest_unique UNIQUE (rest_id, prod_name);


--
-- TOC entry 3204 (class 2606 OID 24662)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (prod_id);


--
-- TOC entry 3216 (class 2606 OID 24773)
-- Name: promo_time promotion_per_day_unique; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time
    ADD CONSTRAINT promotion_per_day_unique UNIQUE (proti_day, prod_id);


--
-- TOC entry 3218 (class 2606 OID 24783)
-- Name: promo_time proti_id_pk; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time
    ADD CONSTRAINT proti_id_pk PRIMARY KEY (proti_id);


--
-- TOC entry 3200 (class 2606 OID 24642)
-- Name: restaurant restaurant_pkey; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_pkey PRIMARY KEY (rest_id);


--
-- TOC entry 3214 (class 2606 OID 24771)
-- Name: promo_product weak_prod_promo_id; Type: CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_product
    ADD CONSTRAINT weak_prod_promo_id PRIMARY KEY (prod_id);


--
-- TOC entry 3224 (class 2620 OID 24741)
-- Name: category_prod check_category_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER check_category_trigger BEFORE DELETE OR UPDATE ON public.category_prod FOR EACH ROW EXECUTE FUNCTION public.check_category_func();


--
-- TOC entry 3227 (class 2620 OID 24801)
-- Name: promo_time check_promo_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER check_promo_trigger BEFORE INSERT OR UPDATE ON public.promo_time FOR EACH ROW EXECUTE FUNCTION public.check_promo_func();


--
-- TOC entry 3228 (class 2620 OID 24790)
-- Name: promo_time interval_promo_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER interval_promo_trigger BEFORE INSERT OR UPDATE ON public.promo_time FOR EACH ROW EXECUTE FUNCTION public.interval_promo_func();


--
-- TOC entry 3225 (class 2620 OID 24739)
-- Name: opening_hours interval_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER interval_trigger BEFORE INSERT OR UPDATE ON public.opening_hours FOR EACH ROW EXECUTE FUNCTION public.interval_func();


--
-- TOC entry 3229 (class 2620 OID 24781)
-- Name: promo_time minute_promo_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER minute_promo_trigger BEFORE INSERT OR UPDATE ON public.promo_time FOR EACH ROW EXECUTE FUNCTION public.minute_promo_func();


--
-- TOC entry 3226 (class 2620 OID 24732)
-- Name: opening_hours minute_trigger; Type: TRIGGER; Schema: public; Owner: Abe
--

CREATE TRIGGER minute_trigger BEFORE INSERT OR UPDATE ON public.opening_hours FOR EACH ROW EXECUTE FUNCTION public.minute_func();


--
-- TOC entry 3219 (class 2606 OID 24675)
-- Name: product cat_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT cat_id_fk FOREIGN KEY (cat_id) REFERENCES public.category_prod(cat_id) NOT VALID;


--
-- TOC entry 3222 (class 2606 OID 24751)
-- Name: promo_product prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_product
    ADD CONSTRAINT prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.product(prod_id) ON DELETE CASCADE;


--
-- TOC entry 3223 (class 2606 OID 24784)
-- Name: promo_time promo_product_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.promo_time
    ADD CONSTRAINT promo_product_id_fk FOREIGN KEY (prod_id) REFERENCES public.promo_product(prod_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3220 (class 2606 OID 24710)
-- Name: product rest_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT rest_id_fk FOREIGN KEY (rest_id) REFERENCES public.restaurant(rest_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3221 (class 2606 OID 24715)
-- Name: opening_hours rest_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: Abe
--

ALTER TABLE ONLY public.opening_hours
    ADD CONSTRAINT rest_id_fk FOREIGN KEY (rest_id) REFERENCES public.restaurant(rest_id) ON DELETE CASCADE NOT VALID;


-- Completed on 2022-06-25 07:50:35

--
-- PostgreSQL database dump complete
--

