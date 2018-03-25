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

