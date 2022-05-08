--
-- extra view add script
-- (with incremental materialized view test)
--

--
-- 神奈川の家系レビュー(IMV)
-- 実験的にこのビューをIMVで作成する。このビューに対するORDER BY LIMITがそのままだとイケてないので、reg_date に改めてbtreeを設定したほうが良さげ。
-- 町田を検索対象に追加。町田は神奈川。
--
CREATE INCREMENTAL MATERIALIZED VIEW kanagawa_house_review_imv AS
SELECT s.sid,
    s.area,
    s.name,
    s.branch,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE (s.pref = '神奈川県'::text OR s.area = '町田市'::text) AND s.status = 'open'::text AND s.tags @> '{家系}'::text[]
;

--
-- shops and reviews aggregates(IMV)
--
CREATE INCREMENTAL MATERIALIZED VIEW shops_agg_imv AS 
SELECT 'shops' AS tablename, COUNT(*) AS count, MAX(sid) AS "max", MIN(sid) AS "min" FROM shops;

CREATE INCREMENTAL MATERIALIZED VIEW reviews_agg_imv AS 
SELECT 'reviews' AS tablename, COUNT(*) AS count, MAX(rid) AS "max", MIN(rid) AS "min" FROM reviews;

CREATE INCREMENTAL MATERIALIZED VIEW users_agg_imv AS 
SELECT 'users' AS tablename, COUNT(*) AS count, MAX(uid) AS "max", MIN(uid) AS "min" FROM users;

CREATE VIEW aggs_imv AS 
SELECT * FROM shops_agg_imv UNION SELECT * FROM reviews_agg_imv UNION SELECT * FROM users_agg_imv;

