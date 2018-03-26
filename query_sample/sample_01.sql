--
-- 都道府県別のレビュー数
--
SELECT s.pref, COUNT(rid) 
  FROM reviews r 
  JOIN shops s 
  ON (r.sid = s.sid) 
  WHERE r.reg_date < '2018-01-01' 
  GROUP BY pref 
  ORDER BY COUNT(rid) DESC;


--
-- 都道府県別のレビューされた店舗数
--
SELECT s.pref, COUNT(s.sid) 
  FROM 
    (SELECT DISTINCT sid FROM reviews WHERE reviews.reg_date < '2018-01-01' ) r 
  JOIN shops s 
  ON (r.sid = s.sid) 
  GROUP BY pref 
  ORDER BY COUNT(s.sid) DESC
;

--
-- レビュー数と店舗数の比率
--
SELECT sh.pref, round(rv.count::numeric / sh.count::numeric, 2) as ratio FROM
(
SELECT s.pref, COUNT(rid)
  FROM reviews r
  JOIN shops s
  ON (r.sid = s.sid)
  WHERE r.reg_date < '2018-01-01'
  GROUP BY pref
) rv
JOIN
(
SELECT s.pref, COUNT(s.sid)
  FROM
    (SELECT DISTINCT sid FROM reviews WHERE reviews.reg_date < '2018-01-01' ) r
  JOIN shops s
  ON (r.sid = s.sid)
  GROUP BY pref
) sh
ON (rv.pref = sh.pref)
ORDER BY ratio DESC
;


--
-- 全期間の都道府県別レビュー数と採点平均値
--
SELECT s.pref, COUNT(r.score), round(AVG(r.score),2)
  FROM reviews r JOIN shops s ON (r.sid = s.sid)
  GROUP BY pref
  ORDER BY COUNT(r.score) DESC;

--
-- 2017年の都道府県別レビュー数と採点平均値
--
SELECT s.pref, COUNT(r.score), round(AVG(r.score),2)  
  FROM reviews r JOIN shops s ON (r.sid = s.sid) 
  WHERE r.reg_date >= '2017-01-01' AND r.reg_date < '2018-01-01' GROUP BY pref ORDER BY COUNT(r.score) DESC;

--
-- 2017年の神奈川県の市区郡別レビュー数と採点平均値
--
SELECT s.area AS area, COUNT(r.score) AS COUNT, round(AVG(r.score),2) AS AVG
  FROM reviews r JOIN shops s ON (r.sid = s.sid)
  WHERE r.reg_date >= '2017-01-01' AND r.reg_date < '2018-01-01' AND
  (s.pref = '神奈川県' OR area = '町田市')
  GROUP BY s.area ORDER BY COUNT(r.score) DESC;

--
-- 2017年の神奈川県のエリア別レビュー数と採点平均値
--
SELECT k.wide_area AS area, COUNT(r.score) AS COUNT, round(AVG(r.score),2) AS AVG
  FROM reviews r JOIN shops s ON (r.sid = s.sid), kanagawa_area_map k
  WHERE r.reg_date >= '2017-01-01' AND r.reg_date < '2018-01-01' AND
  (s.pref = '神奈川県' OR s.area = '町田市') AND
  s.area = k.area
  GROUP BY k.wide_area ORDER BY COUNT(r.score) DESC;

--
-- 2017年までの都道府県/年別のレビュー数
--
SELECT extract(year FROM reg_date) AS year, pref, COUNT(r.score)
  FROM reviews r JOIN shops s ON (r.sid = s.sid)
  WHERE r.reg_date < '2018-01-01'
  GROUP BY extract(year FROM reg_date),pref
  ORDER BY extract(year FROM reg_date),pref
;


--
-- 2017年までの都道府県(関東)/年別のレビュー数
--
\o /dev/null
SELECT r.year, s.pref, COUNT(r.rid)
  FROM
  (SELECT distinct extract(year FROM reg_date) AS year, sid, rid FROM reviews WHERE reg_date < '2018-01-01') r
  JOIN
  shops s ON (r.sid = s.sid)
  WHERE s.pref IN ('東京都', '神奈川県', '千葉県', '埼玉県', '茨城県', '栃木県', '群馬県')
  GROUP BY s.pref, year
  ORDER BY year
;

\o
\crosstabview pref year
--
-- 2017年までの都道府県(関東)/年別のレビュー対象店舗数
--
\o /dev/null
SELECT r.year, s.pref, COUNT(r.sid)
  FROM
  (SELECT distinct extract(year FROM reg_date) AS year, sid FROM reviews WHERE reg_date < '2018-01-01') r
  JOIN
  shops s ON (r.sid = s.sid)
  WHERE s.pref IN ('東京都', '神奈川県', '千葉県', '埼玉県', '茨城県', '栃木県', '群馬県')
  GROUP BY s.pref, year
  ORDER BY year
;

\o
\crosstabview pref year
