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
-- 神奈川の家系レビュー(VIEW)  
--
CREATE VIEW kanagawa_house_review_v AS
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
-- 神奈川・東京のサンマーメンレビュー(View)
-- 現状のIVMの実装だと、こうしたフルスキャンが発生するクエリを含むときの更新オーバヘッドが大きいのでビューにする。 
--
CREATE VIEW sanmamen_v AS
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
SELECT 'reviews' AS tablename, COUNT(*) AS count, MAX(rid) AS "max", MIN(rid) AS "min" FROM reviews;

CREATE INCREMENTAL MATERIALIZED VIEW users_agg AS 
SELECT 'users' AS tablename, COUNT(*) AS count, MAX(uid) AS "max", MIN(uid) AS "min" FROM users;

CREATE VIEW aggs_v AS 
SELECT * FROM shops_agg UNION SELECT * FROM reviews_agg UNION SELECT * FROM users_agg;

--
-- 横浜市内でまだ自分がラーメンレビューを登録していない店舗ビュー
--
CREATE VIEW nuko_noreview_yokohama AS 
SELECT s.sid, s.area, s.name, s.branch 
FROM shops s 
WHERE s.area ~ '横浜市*' AND s.status = 'open' AND s.category @> '{"ramendb":true}' AND 
  s.sid NOT IN (SELECT sid FROM reviews WHERE uid = 8999);

