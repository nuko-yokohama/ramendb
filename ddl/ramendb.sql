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
    category text,
    type text,
    soup text,
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
    status text, -- open, closed, moved
    name text,
    branch text,
    pref text,
    area text,
    insert_uid integer,
    update_uid integer,
    category jsonb,  -- PostgreSQL 9.4-
    point numeric,
    tags text[],
    reg_date date
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
-- additional view
--

CREATE VIEW shops2 AS
SELECT
  CASE 
    WHEN pref = '北海道' THEN '北海道'
    WHEN pref IN ('青森県', '秋田県', '岩手県', '山形県', '宮城県', '福島県') THEN '東北'
    WHEN pref IN ('群馬県', '栃木県', '茨城県', '埼玉県', '千葉県', '東京都', '神奈川県') THEN '関東'
    WHEN pref IN ('新潟県', '長野県', '静岡県', '岐阜県', '愛知県', '福井県') THEN '中部'
    WHEN pref IN ('京都府', '奈良県', '三重県', '和歌山県', '大阪府', '兵庫県') THEN '近畿'
    WHEN pref IN ('鳥取県', '島根県', '岡山県', '広島県', '山口県') THEN '中国'
    WHEN pref IN ('香川県', '愛媛県', '徳島県', '高知県') THEN '四国'
    WHEN pref IN ('福岡県', '大分県', '宮崎県', '佐賀県', '長崎県', '熊本県', '鹿児島県', '沖縄県') THEN '九州'
    ELSE '海外'
  END AS wide_area, *
FROM shops;

--
-- どのユーザがどのareaに何件レビューを上げたかを表すビュー
--
CREATE VIEW user_review_area AS
SELECT u.uid,
   s.pref,
   s.area,
   count(r.rid) AS count,
   max(r.reg_date) AS max
FROM shops s
    JOIN reviews r ON s.sid = r.sid
    JOIN users u ON r.uid = u.uid
GROUP BY u.uid, s.pref, s.area
;

--
-- 登録ユーザのホーム(最もレビューを上げているかつ最近レビューを上げたarea)を求めるビュー
--
CREATE VIEW user_home_v AS
SELECT t.uid,
    t.pref,
    t.area,
    t.count
FROM ( SELECT user_review_area.uid,
            user_review_area.pref,
            user_review_area.area,
            user_review_area.count,
            user_review_area.max,
            rank() OVER (PARTITION BY user_review_area.uid ORDER BY user_review_area.count DESC, user_review_area.max DESC) AS rank FROM user_review_area) t
WHERE t.rank = 1;

--
-- PostgreSQL database dump complete
--

