-- Database: api_goomer

-- DROP DATABASE IF EXISTS api_goomer;

CREATE DATABASE api_goomer
    WITH
    OWNER = "Abe"
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;


-- SCHEMA: public

-- DROP SCHEMA IF EXISTS public ;

CREATE SCHEMA IF NOT EXISTS public
    AUTHORIZATION postgres;

COMMENT ON SCHEMA public
    IS 'standard public schema';

GRANT ALL ON SCHEMA public TO PUBLIC;

GRANT ALL ON SCHEMA public TO postgres;



----------------------------TABLES---------------------------------

-- Table: public.restaurant

-- DROP TABLE IF EXISTS public.restaurant;

CREATE TABLE IF NOT EXISTS public.restaurant
(
    rest_id integer NOT NULL DEFAULT nextval('restaurant_rest_id_seq'::regclass),
    rest_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    rest_adress character varying(50) COLLATE pg_catalog."default" NOT NULL,
    rest_photo bytea,
    CONSTRAINT restaurant_pkey PRIMARY KEY (rest_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.restaurant
    OWNER to "Abe";


-- Table: public.category_prod

-- DROP TABLE IF EXISTS public.category_prod;

CREATE TABLE IF NOT EXISTS public.category_prod
(
    cat_id integer NOT NULL DEFAULT nextval('category_prod_cat_id_seq'::regclass),
    cat_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT category_prod_pkey PRIMARY KEY (cat_id),
    CONSTRAINT cat_name_unique UNIQUE (cat_name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.category_prod
    OWNER to "Abe";

-- Trigger: check_category_trigger

-- DROP TRIGGER IF EXISTS check_category_trigger ON public.category_prod;

CREATE TRIGGER check_category_trigger
    BEFORE DELETE OR UPDATE 
    ON public.category_prod
    FOR EACH ROW
    EXECUTE FUNCTION public.check_category_func();


-- Table: public.product

-- DROP TABLE IF EXISTS public.product;

CREATE TABLE IF NOT EXISTS public.product
(
    prod_id integer NOT NULL DEFAULT nextval('product_prod_id_seq'::regclass),
    rest_id integer NOT NULL,
    prod_name character varying COLLATE pg_catalog."default" NOT NULL,
    prod_price numeric NOT NULL,
    prod_photo bytea,
    cat_id integer NOT NULL,
    CONSTRAINT product_pkey PRIMARY KEY (prod_id),
    CONSTRAINT prod_per_rest_unique UNIQUE (rest_id, prod_name),
    CONSTRAINT cat_id_fk FOREIGN KEY (cat_id)
        REFERENCES public.category_prod (cat_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT rest_id_fk FOREIGN KEY (rest_id)
        REFERENCES public.restaurant (rest_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product
    OWNER to "Abe";



-- Table: public.opening_hours

-- DROP TABLE IF EXISTS public.opening_hours;

CREATE TABLE IF NOT EXISTS public.opening_hours
(
    rest_id integer NOT NULL,
    op_opening time(0) without time zone NOT NULL,
    op_closing time(0) without time zone NOT NULL,
    op_day character varying(10) COLLATE pg_catalog."default" NOT NULL,
    op_id integer NOT NULL DEFAULT nextval('opening_hours_op_id_seq'::regclass),
    CONSTRAINT "opening_hours_PK" PRIMARY KEY (op_id, rest_id),
    CONSTRAINT day_work_rest_unique UNIQUE (op_day, rest_id),
    CONSTRAINT rest_id_fk FOREIGN KEY (rest_id)
        REFERENCES public.restaurant (rest_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.opening_hours
    OWNER to "Abe";

-- Trigger: interval_trigger

-- DROP TRIGGER IF EXISTS interval_trigger ON public.opening_hours;

CREATE TRIGGER interval_trigger
    BEFORE INSERT OR UPDATE 
    ON public.opening_hours
    FOR EACH ROW
    EXECUTE FUNCTION public.interval_func();

-- Trigger: minute_trigger

-- DROP TRIGGER IF EXISTS minute_trigger ON public.opening_hours;

CREATE TRIGGER minute_trigger
    BEFORE INSERT OR UPDATE 
    ON public.opening_hours
    FOR EACH ROW
    EXECUTE FUNCTION public.minute_func();


-- Table: public.promo_product

-- DROP TABLE IF EXISTS public.promo_product;

CREATE TABLE IF NOT EXISTS public.promo_product
(
    prod_id integer NOT NULL,
    promo_description character varying(100) COLLATE pg_catalog."default" NOT NULL,
    promo_price numeric NOT NULL,
    CONSTRAINT weak_prod_promo_id PRIMARY KEY (prod_id),
    CONSTRAINT prod_id_fk FOREIGN KEY (prod_id)
        REFERENCES public.product (prod_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.promo_product
    OWNER to "Abe";

-- Table: public.promo_time

-- DROP TABLE IF EXISTS public.promo_time;

CREATE TABLE IF NOT EXISTS public.promo_time
(
    proti_id integer NOT NULL DEFAULT nextval('promo_time_proti_id_seq'::regclass),
    prod_id integer NOT NULL,
    proti_timeinit time(0) without time zone NOT NULL,
    proti_timeend time(0) without time zone NOT NULL,
    proti_day character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT proti_id_pk PRIMARY KEY (proti_id),
    CONSTRAINT promotion_per_day_unique UNIQUE (proti_day, prod_id),
    CONSTRAINT promo_product_id_fk FOREIGN KEY (prod_id)
        REFERENCES public.promo_product (prod_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.promo_time
    OWNER to "Abe";

-- Trigger: check_promo_trigger

-- DROP TRIGGER IF EXISTS check_promo_trigger ON public.promo_time;

CREATE TRIGGER check_promo_trigger
    BEFORE INSERT OR UPDATE 
    ON public.promo_time
    FOR EACH ROW
    EXECUTE FUNCTION public.check_promo_func();

-- Trigger: interval_promo_trigger

-- DROP TRIGGER IF EXISTS interval_promo_trigger ON public.promo_time;

CREATE TRIGGER interval_promo_trigger
    BEFORE INSERT OR UPDATE 
    ON public.promo_time
    FOR EACH ROW
    EXECUTE FUNCTION public.interval_promo_func();

-- Trigger: minute_promo_trigger

-- DROP TRIGGER IF EXISTS minute_promo_trigger ON public.promo_time;

CREATE TRIGGER minute_promo_trigger
    BEFORE INSERT OR UPDATE 
    ON public.promo_time
    FOR EACH ROW
    EXECUTE FUNCTION public.minute_promo_func();


----------------------------SEQUENCES---------------------------------

-- SEQUENCE: public.category_prod_cat_id_seq

-- DROP SEQUENCE IF EXISTS public.category_prod_cat_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.category_prod_cat_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY category_prod.cat_id;

ALTER SEQUENCE public.category_prod_cat_id_seq
    OWNER TO "Abe";


-- SEQUENCE: public.opening_hours_op_id_seq

-- DROP SEQUENCE IF EXISTS public.opening_hours_op_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.opening_hours_op_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY opening_hours.op_id;

ALTER SEQUENCE public.opening_hours_op_id_seq
    OWNER TO "Abe";


-- SEQUENCE: public.product_prod_id_seq

-- DROP SEQUENCE IF EXISTS public.product_prod_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.product_prod_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY product.prod_id;

ALTER SEQUENCE public.product_prod_id_seq
    OWNER TO "Abe";


-- SEQUENCE: public.promo_time_proti_id_seq

-- DROP SEQUENCE IF EXISTS public.promo_time_proti_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.promo_time_proti_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY promo_time.proti_id;

ALTER SEQUENCE public.promo_time_proti_id_seq
    OWNER TO "Abe";

-- SEQUENCE: public.restaurant_rest_id_seq

-- DROP SEQUENCE IF EXISTS public.restaurant_rest_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.restaurant_rest_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY restaurant.rest_id;

ALTER SEQUENCE public.restaurant_rest_id_seq
    OWNER TO "Abe";


------------------------FUNCTIONS--------------------------------

-- FUNCTION: public.check_category_func()

-- DROP FUNCTION IF EXISTS public.check_category_func();

CREATE OR REPLACE FUNCTION public.check_category_func()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.check_category_func()
    OWNER TO postgres;



-- FUNCTION: public.check_promo_func()

-- DROP FUNCTION IF EXISTS public.check_promo_func();

CREATE OR REPLACE FUNCTION public.check_promo_func()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	--verifica a existencia da promocao antes de inserir horas
	if ( EXISTS(SELECT * FROM promo_product as pp WHERE new.prod_id = pp.prod_id)) then
		return new;
	else 
        raise exception 'cannot insert or change a promo_time without prod_id in promotion';
	end if;
END
$BODY$;

ALTER FUNCTION public.check_promo_func()
    OWNER TO postgres;


-- FUNCTION: public.interval_func()

-- DROP FUNCTION IF EXISTS public.interval_func();

CREATE OR REPLACE FUNCTION public.interval_func()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	--trata o intervalo de tempo para ser valido
	if ( NEW.op_opening >= NEW.op_closing) then
		raise exception 'Interval time incorect!!';
	else 
		return new;
	end if;
END
$BODY$;

ALTER FUNCTION public.interval_func()
    OWNER TO postgres;


-- FUNCTION: public.interval_promo_func()

-- DROP FUNCTION IF EXISTS public.interval_promo_func();

CREATE OR REPLACE FUNCTION public.interval_promo_func()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	--trata o intervalo de tempo para ser valido
	if ( NEW.proti_timeinit >= NEW.proti_timeend) then
		raise exception 'Interval time incorect!!';
	else 
		return new;
	end if;
END
$BODY$;

ALTER FUNCTION public.interval_promo_func()
    OWNER TO postgres;


-- FUNCTION: public.minute_func()

-- DROP FUNCTION IF EXISTS public.minute_func();

CREATE OR REPLACE FUNCTION public.minute_func()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.minute_func()
    OWNER TO postgres;


-- FUNCTION: public.minute_promo_func()

-- DROP FUNCTION IF EXISTS public.minute_promo_func();

CREATE OR REPLACE FUNCTION public.minute_promo_func()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
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
$BODY$;

ALTER FUNCTION public.minute_promo_func()
    OWNER TO postgres;
