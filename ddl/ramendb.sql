--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comments; Type: TABLE; Schema: public; 
--

CREATE UNLOGGED TABLE comments (
    rid integer,
    review_uid integer,
    comment_uid integer
);


--
-- Name: reviews; Type: TABLE; Schema: public; 
--

CREATE UNLOGGED TABLE reviews (
    rid integer,
    menu text,
    score integer,
    noodle_type text,
    soup_type text,
    sid integer,
    uid integer,
    likes integer,
    reg_date date
);


CREATE UNLOGGED TABLE reviews_text (
    rid integer,
    data text
);

--
-- Name: shops; Type: TABLE; Schema: public; 
--

CREATE UNLOGGED TABLE shops (
    sid integer NOT NULL,
    name text,
    branch text,
    pref text,
    area text,
    insert_uid integer,
    update_uid integer,
    category jsonb  -- PostgreSQL 9.4-
);


--
-- Name: users; Type: TABLE; Schema: public; 
--

CREATE UNLOGGED TABLE users (
    uid integer NOT NULL,
    name text,
    reviews integer,
    shops integer,
    favorites integer,
    likes integer,
    note text
);



ALTER TABLE ONLY reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (rid);

ALTER TABLE ONLY reviews_text
    ADD CONSTRAINT reviews_text_pkey PRIMARY KEY (rid);

--
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; 
--

ALTER TABLE ONLY shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (sid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: kanagawa_area_map; Type: TABLE; Schema: public; 
--

CREATE TABLE kanagawa_area_map (
    area text,
    wide_area text
);


--
-- Data for Name: kanagawa_area_map; Type: TABLE DATA; Schema: public; 
--

COPY kanagawa_area_map (area, wide_area) FROM stdin;
三浦市	横須賀三浦
三浦郡	横須賀三浦
中郡	湘南
伊勢原市	湘南
南足柄市	県西
厚木市	県央
大和市	県央
小田原市	県西
川崎市中原区	川崎
川崎市多摩区	川崎
川崎市宮前区	川崎
川崎市川崎区	川崎
川崎市幸区	川崎
川崎市高津区	川崎
川崎市麻生区	川崎
平塚市	湘南
座間市	県央
愛甲郡	県央
横浜市中区	横浜
横浜市保土ヶ谷区	横浜
横浜市南区	横浜
横浜市戸塚区	横浜
横浜市旭区	横浜
横浜市栄区	横浜
横浜市泉区	横浜
横浜市港北区	横浜
横浜市港南区	横浜
横浜市瀬谷区	横浜
横浜市磯子区	横浜
横浜市神奈川区	横浜
横浜市緑区	横浜
横浜市西区	横浜
横浜市都筑区	横浜
横浜市金沢区	横浜
横浜市青葉区	横浜
横浜市鶴見区	横浜
横須賀市	横須賀三浦
海老名市	県央
町田市	相模原
相模原市中央区	相模原
相模原市南区	相模原
相模原市緑区	相模原
秦野市	湘南
綾瀬市	県央
茅ヶ崎市	湘南
藤沢市	湘南
足柄上郡	県西
足柄下郡	県西
逗子市	横須賀三浦
鎌倉市	横須賀三浦
高座郡	湘南
\.


--
-- PostgreSQL database dump complete
--

