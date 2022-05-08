--
-- extra view add script
--

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
-- 横浜市内でまだ自分がラーメンレビューを登録していない店舗ビュー
--
CREATE VIEW nuko_noreview_yokohama AS 
SELECT s.sid, s.area, s.name, s.branch 
FROM shops s 
WHERE s.area ~ '横浜市*' AND s.status = 'open' AND s.category @> '{"ramendb":true}' AND 
  s.sid NOT IN (SELECT sid FROM reviews WHERE uid = 8999);

--
-- shops and reviews aggregates(view)
--
CREATE VIEW shops_agg_v AS
SELECT 'shops' AS tablename, COUNT(*) AS count, MAX(sid) AS "max", MIN(sid) AS "min" FROM shops;

CREATE VIEW reviews_agg_v AS
SELECT 'reviews' AS tablename, COUNT(*) AS count, MAX(rid) AS "max", MIN(rid) AS "min" FROM reviews;

CREATE VIEW users_agg_v AS
SELECT 'users' AS tablename, COUNT(*) AS count, MAX(uid) AS "max", MIN(uid) AS "min" FROM users;

CREATE VIEW aggs_v AS
SELECT * FROM shops_agg_v UNION SELECT * FROM reviews_agg_v UNION SELECT * FROM users_agg_v;
