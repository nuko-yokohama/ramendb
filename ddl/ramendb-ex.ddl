--
-- extra view add script
-- (with incremental materialized view test)
--

--
-- 神奈川の家系レビュー(IMV)
--
CREATE INCREMENTAL MATERIALIZED VIEW kanagawa_house_review_imv AS
SELECT s.sid,
    s.name,
    s.branch,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE s.pref = '神奈川県' AND s.status = 'open' AND s.tags = '{家系}'
;

--
-- 神奈川の家系レビュー(VIEW)
--
CREATE VIEW kanagawa_house_review_v AS
SELECT s.sid,
    s.name,
    s.branch,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE s.pref = '神奈川県' AND s.status = 'open' AND s.tags = '{家系}'
;

--
-- 神奈川・東京のサンマーメンレビュー(IMV)
--
CREATE VIEW AS sanmamen_v
SELECT s.sid,
    s.pref,
    s.area,
    s.name,
    s.branch,
    s.status,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE (s.pref = ANY (ARRAY['神奈川県', '東京都'])) AND s.status = 'open' AND r.menu ~ '((さんま|サンマ)[(ー|あ|ぁ)]|生(馬|碼))(めん|メン|麺)'
;

--
-- 神奈川・東京のサンマーメンレビュー(VIEW)
--
CREATE INCREMENTAL MATERIALIZED VIEW sanmamen_imv AS
SELECT s.sid,
    s.pref,
    s.area,
    s.name,
    s.branch,
    s.status,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE (s.pref = ANY (ARRAY['神奈川県', '東京都'])) AND s.status = 'open' AND r.menu ~ '((さんま|サンマ)[(ー|あ|ぁ)]|生(馬|碼))(めん|メン|麺)'
;

--
-- shops and reviews aggregates(IMV)
--
CREATE INCREMENTAL MATERIALIZED VIEW shops_agg AS 
SELECT 'shops' AS tablename, COUNT(*) AS count, MAX(sid) AS "max", MIN(sid) AS "min" FROM shops;

CREATE INCREMENTAL MATERIALIZED VIEW reviews_agg AS 
SELECT 'reviews' AS tablename, COUNT(*) AS count, MAX(sid) AS "max", MIN(sid) AS "min" FROM reviews;

CREATE INCREMENTAL MATERIALIZED VIEW users_agg AS 
SELECT 'users' AS tablename, COUNT(*) AS count, MAX(uid) AS "max", MIN(uid) AS "min" FROM users;

CREATE VIEW aggs_v AS 
SELECT * FROM shops_agg UNION SELECT * FROM reviews_agg UNION SELECT * FROM users_agg;
