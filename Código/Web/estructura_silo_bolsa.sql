--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alerta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerta (
    id_alerta integer NOT NULL,
    fecha_alerta date NOT NULL,
    hora_alerta time without time zone NOT NULL,
    mensaje character varying(200) NOT NULL,
    id_silo integer
);


ALTER TABLE public.alerta OWNER TO postgres;

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
    id_lectura integer NOT NULL,
    temp integer NOT NULL,
    fecha_lectura date,
    hora_lectura time without time zone NOT NULL,
    humedad double precision NOT NULL,
    dioxido_de_carbono double precision NOT NULL,
    id_caja integer
);


ALTER TABLE public.lectura OWNER TO postgres;

--
-- Name: sensores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensores (
    id_caja integer NOT NULL,
    ubicacion_en_silo integer NOT NULL,
    id_silo integer
);


ALTER TABLE public.sensores OWNER TO postgres;

--
-- Name: silo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silo (
    id integer NOT NULL,
    latitud double precision NOT NULL,
    longitud double precision NOT NULL,
    capacidad integer,
    tipo_grano integer NOT NULL
);


ALTER TABLE public.silo OWNER TO postgres;

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
-- Name: lectura lectura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectura
    ADD CONSTRAINT lectura_pkey PRIMARY KEY (id_lectura);


--
-- Name: sensores sensores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensores
    ADD CONSTRAINT sensores_pkey PRIMARY KEY (id_caja);


--
-- Name: silo silo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silo
    ADD CONSTRAINT silo_pkey PRIMARY KEY (id);


--
-- Name: alerta alerta_id_silo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT alerta_id_silo_fkey FOREIGN KEY (id_silo) REFERENCES public.silo(id);


--
-- Name: lectura lectura_id_caja_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectura
    ADD CONSTRAINT lectura_id_caja_fkey FOREIGN KEY (id_caja) REFERENCES public.sensores(id_caja);


--
-- Name: sensores sensores_id_silo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensores
    ADD CONSTRAINT sensores_id_silo_fkey FOREIGN KEY (id_silo) REFERENCES public.silo(id);


--
-- PostgreSQL database dump complete
--

