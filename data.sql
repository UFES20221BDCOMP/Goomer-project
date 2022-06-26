--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

-- Started on 2022-06-26 04:30:58

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
-- TOC entry 3369 (class 0 OID 24665)
-- Dependencies: 214
-- Data for Name: category_prod; Type: TABLE DATA; Schema: public; Owner: Abe
--

COPY public.category_prod (cat_id, cat_name) FROM stdin;
1	Bebidas
2	Lanches
3	Acompanhamentos
4	Sobremesa
5	Pizza
6	Vegetariano
7	Vegano
8	Massas
9	Sorvete
10	Almoco/Janta
\.


--
-- TOC entry 3365 (class 0 OID 24635)
-- Dependencies: 210
-- Data for Name: restaurant; Type: TABLE DATA; Schema: public; Owner: Abe
--

COPY public.restaurant (rest_id, rest_name, rest_adress, rest_photo) FROM stdin;
1	Burger King 	Av. Nossa Senhora da Penha, 2534	\N
2	Subway Ufes	R. Darcy Grijó, 50	\N
3	Rock Burger 	R. Silvino Grecco, 800	\N
5	Pizza Hut	Av. Américo Buaiz, 200	\N
6	Chiquinho Sorvetes	R. João da Cruz, 340	\N
8	Chiquinho Sorvetes	Av. Anisio Fernandes Coelho, 1715	\N
7	Burger King 	Av. Américo Buaiz, 200	\N
4	Paladar de Mel	Santa Tereza, 321	\N
9	teste	rua teste	\N
\.


--
-- TOC entry 3370 (class 0 OID 24684)
-- Dependencies: 215
-- Data for Name: opening_hours; Type: TABLE DATA; Schema: public; Owner: Abe
--

COPY public.opening_hours (rest_id, op_opening, op_closing, op_day, op_id) FROM stdin;
1	09:00:00	18:00:00	Segunda	1
1	09:00:00	18:00:00	Terça	2
1	09:00:00	18:00:00	Quarta	3
1	10:00:00	18:00:00	Quinta	5
1	10:00:00	18:00:00	Sexta	6
2	08:00:00	16:00:00	Segunda	7
2	08:00:00	16:00:00	Terça	8
2	08:00:00	16:00:00	Quarta	9
2	08:00:00	16:00:00	Quinta	10
2	08:00:00	16:00:00	Sexta	11
3	15:00:00	21:00:00	Segunda	12
3	15:00:00	21:00:00	Terça	13
3	15:00:00	21:00:00	Quarta	14
3	15:00:00	21:00:00	Quinta	15
3	15:00:00	21:00:00	Sexta	16
4	09:00:00	21:00:00	Segunda	17
4	09:00:00	21:00:00	Terça	18
4	09:00:00	21:00:00	Quarta	19
4	09:00:00	21:00:00	Quinta	20
4	09:00:00	21:00:00	Sexta	21
\.


--
-- TOC entry 3367 (class 0 OID 24646)
-- Dependencies: 212
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: Abe
--

COPY public.product (prod_id, rest_id, prod_name, prod_price, prod_photo, cat_id) FROM stdin;
1	1	Duplo Cheddar	15.90	\N	2
2	1	Duplo Rodeio	15.90	\N	2
3	3	Refrigerante Lata	6.90	\N	1
4	7	Suco 	14.90	\N	1
5	7	Batata Frita	26.50	\N	2
6	5	Pizza Média	35.90	\N	5
7	5	Pizza Grande	45.90	\N	5
8	6	Sorvete Casquinha	4.00	\N	9
9	8	Milk Shake	8.00	\N	9
10	7	Refrigerante Lata	10.90	\N	1
11	1	Refrigerante Lata	11.90	\N	1
12	4	Refrigerante 1L	16.90	\N	1
13	5	Refrigerante 1L	14.50	\N	1
14	1	Duplo Cheeseburger	15.90	\N	2
15	2	Sanduiche 15cm	15.90	\N	2
16	2	Sanduiche 30cm	21.90	\N	2
17	2	Refrigerante Lata	7.60	\N	1
18	4	Marmita Pequena	10.90	\N	10
19	4	Marmita Grande	16.90	\N	10
20	4	Prato Feito 250g	13.75	\N	10
22	5	Pizza Doce	49.90	\N	5
\.


--
-- TOC entry 3371 (class 0 OID 24743)
-- Dependencies: 216
-- Data for Name: promo_product; Type: TABLE DATA; Schema: public; Owner: Abe
--

COPY public.promo_product (prod_id, promo_description, promo_price) FROM stdin;
2	Duplo Rodeio com desconto imperdivel!	13.50
\.


--
-- TOC entry 3373 (class 0 OID 24764)
-- Dependencies: 218
-- Data for Name: promo_time; Type: TABLE DATA; Schema: public; Owner: Abe
--

COPY public.promo_time (proti_id, prod_id, proti_timeinit, proti_timeend, proti_day) FROM stdin;
11	2	10:00:00	20:00:00	Segunda
14	2	10:00:00	20:00:00	Terça
16	2	10:00:00	20:00:00	Quarta
\.


--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 213
-- Name: category_prod_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.category_prod_cat_id_seq', 11, true);


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 219
-- Name: opening_hours_op_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.opening_hours_op_id_seq', 22, true);


--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 211
-- Name: product_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.product_prod_id_seq', 24, true);


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 217
-- Name: promo_time_proti_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.promo_time_proti_id_seq', 19, true);


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 209
-- Name: restaurant_rest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Abe
--

SELECT pg_catalog.setval('public.restaurant_rest_id_seq', 10, true);


-- Completed on 2022-06-26 04:31:03

--
-- PostgreSQL database dump complete
--

