--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alerta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerta (
    mensaje character varying(200) NOT NULL,
    id_alerta uuid NOT NULL,
    id_silo uuid,
    "fecha_ḧora_alerta" timestamp without time zone,
    correoenviado boolean DEFAULT false
);


ALTER TABLE public.alerta OWNER TO postgres;

--
-- Name: caja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caja (
    ubicacion_en_silo integer NOT NULL,
    id_caja uuid NOT NULL,
    id_silo uuid
);


ALTER TABLE public.caja OWNER TO postgres;

--
-- Name: grano; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grano (
    id integer NOT NULL,
    descripcion character varying(200) NOT NULL,
    humedad_max double precision NOT NULL,
    humedad_min double precision NOT NULL,
    temp_max double precision NOT NULL,
    temp_min double precision NOT NULL,
    nivel_dioxido_max double precision NOT NULL,
    nivel_dioxido_min double precision NOT NULL
);


ALTER TABLE public.grano OWNER TO postgres;

--
-- Name: lectura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lectura (
    temp double precision NOT NULL,
    humedad double precision NOT NULL,
    dioxido_de_carbono double precision NOT NULL,
    id_caja uuid,
    id_lectura uuid NOT NULL,
    fecha_hora_lectura timestamp without time zone
);


ALTER TABLE public.lectura OWNER TO postgres;

--
-- Name: silo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silo (
    latitud double precision NOT NULL,
    longitud double precision NOT NULL,
    capacidad integer,
    tipo_grano integer NOT NULL,
    id_silo uuid NOT NULL,
    descripcion character varying(200)
);


ALTER TABLE public.silo OWNER TO postgres;

--
-- Data for Name: alerta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerta (mensaje, id_alerta, id_silo, "fecha_ḧora_alerta", correoenviado) FROM stdin;
Condiciones extremas en el silo trigo 2025: Temperatura=27,16007ºC, Humedad=50,41676%	6fd7f911-bc14-4ddd-9aa7-341246d9d6e4	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-19 21:06:20.496015	f
Condiciones extremas en el silo trigo 2025: Temperatura=27,21024ºC, Humedad=50,12856%	760d8323-183a-4398-ae1a-961430cf6580	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-19 21:06:20.594086	f
Condiciones extremas en el silo trigo 2025: Temperatura=27,23026ºC, Humedad=50,66175%	981217ad-d7ad-4b49-a5db-2006851d3c93	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-19 21:06:20.610184	f
alertaalerta	7e9309da-9540-4c3e-adef-7fb6624b00af	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-22 20:49:48.793	f
alerta alertita	d4a6e466-6e04-4ef3-9dfd-1fd0c3d8f0a6	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 09:23:30.284	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	e4ec8e99-4aa3-46a0-b677-e922145f20ea	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 09:38:31.561066	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	96006401-53cc-457f-9abb-48962186c256	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 09:48:32.039414	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	41450d79-7e1b-4917-bc54-03750299c29f	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 09:49:19.898703	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	e6f31e98-0b3a-442f-86c2-977c3495b6c1	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 09:59:20.967484	f
Condiciones extremas en el silo trigo 2025: Temperatura=110ºC, Humedad=0%	a43d1ba1-8cae-4bc0-be2b-0fdb8dc0b476	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 09:59:21.011471	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	9e2ffd77-5b79-4705-bcbc-a4a6ec389608	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:09:22.174036	f
Condiciones extremas en el silo trigo 2025: Temperatura=110ºC, Humedad=0%	e08e471d-5a4a-4120-8a05-da9baa94cb9d	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:09:22.272084	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	c0e6c62b-c6b8-47ce-b058-68984d22070f	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:19:22.615187	f
Condiciones extremas en el silo trigo 2025: Temperatura=110ºC, Humedad=0%	931c4aa1-17a9-4cf9-a295-562831a66401	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:19:22.633891	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	fa571681-6e29-41de-8a69-0569a9613170	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:55:14.252932	f
Condiciones extremas en el silo trigo 2025: Temperatura=110ºC, Humedad=0%	e1888b96-0ff3-4207-b8c4-4d184b36d9a3	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:55:14.708839	f
Condiciones extremas en el silo trigo 2025: Temperatura=100ºC, Humedad=0%	36b222cd-2fe3-422f-8a69-cebc7097172f	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:59:56.541712	t
Condiciones extremas en el silo trigo 2025: Temperatura=110ºC, Humedad=0%	2ac5abe2-c697-446f-b0b9-8595ac4d6847	f62ed337-f74f-40ad-96e2-429e896e3d98	2024-10-23 10:59:56.890174	t
\.


--
-- Data for Name: caja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caja (ubicacion_en_silo, id_caja, id_silo) FROM stdin;
1	cac70d5d-4df3-451f-bba9-59bcea039425	f62ed337-f74f-40ad-96e2-429e896e3d98
\.


--
-- Data for Name: grano; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grano (id, descripcion, humedad_max, humedad_min, temp_max, temp_min, nivel_dioxido_max, nivel_dioxido_min) FROM stdin;
2	Maíz	100	80	100	50	1000	600
3	Girasol	100	80	100	50	1000	600
4	Soja	100	80	100	50	1000	600
5	Arroz	100	80	100	50	1000	600
6	Cebada	100	80	100	50	1000	600
1	Trigo	100	0	50	0	1000	0
\.


--
-- Data for Name: lectura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lectura (temp, humedad, dioxido_de_carbono, id_caja, id_lectura, fecha_hora_lectura) FROM stdin;
27.16007	50.41676	38690.49	cac70d5d-4df3-451f-bba9-59bcea039425	cc350cb6-eab8-4f82-b5bb-64ec000cb7bf	2106-02-07 00:29:05
27.21024	50.12856	11768.1	cac70d5d-4df3-451f-bba9-59bcea039425	4f2a5037-85c2-4e02-84db-2b7b57917179	2024-10-19 18:04:28
27.23026	50.66175	4763.739	cac70d5d-4df3-451f-bba9-59bcea039425	d82307d2-f6f0-43b8-8dfa-9195d28133d6	2024-10-19 18:05:52
27.26154	49.03278	2413.914	cac70d5d-4df3-451f-bba9-59bcea039425	3acd5700-9b49-4b70-9f55-8166c41c7b16	2024-10-19 18:06:42
27.28615	48.40221	2023.831	cac70d5d-4df3-451f-bba9-59bcea039425	c6a8bf75-d013-49d2-9580-91b25a433a4a	2024-10-19 18:07:32
27.29893	49.24164	1344.85	cac70d5d-4df3-451f-bba9-59bcea039425	53887336-9811-47cc-932c-cca636f00f32	2024-10-19 18:08:23
27.33574	49.34101	1640.38	cac70d5d-4df3-451f-bba9-59bcea039425	0b495030-90eb-466a-ab02-16077beffa9d	2024-10-19 18:09:13
27.36187	49.59745	1244.289	cac70d5d-4df3-451f-bba9-59bcea039425	4c9794bc-e279-4c96-9551-6dbbc95ae43d	2024-10-19 18:10:03
27.39143	49.69606	1562.647	cac70d5d-4df3-451f-bba9-59bcea039425	82122318-8d32-4288-bf29-c29d5a012613	2024-10-19 18:10:53
27.42138	49.82958	1180.219	cac70d5d-4df3-451f-bba9-59bcea039425	533b598a-b3c0-4ed2-918e-d0019c5db781	2024-10-19 18:11:43
27.46334	49.80049	1524.76	cac70d5d-4df3-451f-bba9-59bcea039425	4c9e5abb-cd01-4301-93f4-5164429e44e6	2024-10-19 18:12:33
27.49119	49.75786	1180.219	cac70d5d-4df3-451f-bba9-59bcea039425	d986976c-bcb7-4edd-9690-1231f76a9c46	2024-10-19 18:13:24
27.50683	49.47433	1450.911	cac70d5d-4df3-451f-bba9-59bcea039425	0147d0f8-2532-4727-a613-6ea468953633	2024-10-19 18:14:14
100	0	1000	cac70d5d-4df3-451f-bba9-59bcea039425	4335ce9a-2552-4293-8a79-341c7c2b6895	2024-10-23 09:27:34.672
110	0	1110	cac70d5d-4df3-451f-bba9-59bcea039425	4c1ef109-9f7f-4bc0-ab73-38953c210a51	2024-10-23 09:50:13.581
\.


--
-- Data for Name: silo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.silo (latitud, longitud, capacidad, tipo_grano, id_silo, descripcion) FROM stdin;
-35.92895371022712	-64.2839241027832	100	1	f62ed337-f74f-40ad-96e2-429e896e3d98	trigo 2025
-35.99723484992833	-64.59865252750838	100	4	f6422a80-5141-435f-821a-3d9c12f75696	soja 2024
-35.91870164968451	-64.28220748901367	200	4	87ce2a69-d956-49d7-8d0e-0e8790f79b79	soja 2024
34	33	100	2	956425d6-b929-4c8c-b205-c96115cf365e	TRIGO 2028
\.


--
-- Name: alerta alerta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT alerta_pkey PRIMARY KEY (id_alerta);


--
-- Name: grano grano_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grano
    ADD CONSTRAINT grano_pkey PRIMARY KEY (id);


--
-- Name: lectura pk_lectura; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectura
    ADD CONSTRAINT pk_lectura PRIMARY KEY (id_lectura);


--
-- Name: caja pk_sensores; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT pk_sensores PRIMARY KEY (id_caja);


--
-- Name: silo silo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silo
    ADD CONSTRAINT silo_pkey PRIMARY KEY (id_silo);


--
-- Name: lectura fk_caja; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectura
    ADD CONSTRAINT fk_caja FOREIGN KEY (id_caja) REFERENCES public.caja(id_caja);


--
-- Name: silo fk_grano; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silo
    ADD CONSTRAINT fk_grano FOREIGN KEY (tipo_grano) REFERENCES public.grano(id);


--
-- Name: alerta fk_silo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT fk_silo FOREIGN KEY (id_silo) REFERENCES public.silo(id_silo);


--
-- Name: caja fk_silo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caja
    ADD CONSTRAINT fk_silo FOREIGN KEY (id_silo) REFERENCES public.silo(id_silo);


--
-- PostgreSQL database dump complete
--

