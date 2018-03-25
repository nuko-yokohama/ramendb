--
-- 年別のレビュー数とスコアの平均
--
SELECT t.year, COUNT(soup_type) AS COUNT
  FROM (SELECT extract(year FROM reg_date) AS year, soup_type FROM reviews) t
  GROUP BY year
  ORDER BY year ASC
;

--
-- 月別のレビュー数
--
SELECT t.ym, COUNT(soup_type) AS COUNT
  FROM (SELECT left(reg_date::text, 7) AS ym, soup_type FROM reviews) t
  GROUP BY ym
  ORDER BY ym ASC
;

--
-- 全期間でのスープ種別のレビュー数と比率
--
SELECT soup_type, COUNT(soup_type), round(COUNT(soup_type)::numeric * 100 / (SELECT count(*)::numeric  FROM reviews),  2) AS percent
  FROM reviews
  GROUP BY soup_type
;

--
-- 神奈川県における、全期間でのスープ種別のレビュー数と比率
--
SELECT r.soup_type, COUNT(r.soup_type), round(COUNT(r.soup_type)::numeric * 100 / (SELECT count(*)::numeric  FROM reviews r JOIN shops s ON (r.sid = s.sid) WHERE s.pref = '神奈川県' OR area = '町田市'),  2) AS percent
  FROM reviews r JOIN shops s ON (r.sid = s.sid)
  WHERE s.pref = '神奈川県' OR area = '町田市'
  GROUP BY soup_type
;
--
-- 年別のスープ種別（\crosstabviewによる表示）
--
\o /dev/null
SELECT t.year AS year, t.soup_type AS soup_type, COUNT(t.soup_type)
  FROM (SELECT extract(year FROM reg_date) AS year, soup_type FROM reviews) t
  GROUP BY year, soup_type
  ORDER BY year ASC,  soup_type ASC
;

\o
\crosstabview year soup_type 

--
-- 神奈川県における、年別のスープ種別（\crosstabviewによる表示）
--
\o /dev/null
SELECT t.year AS year, t.soup_type AS soup_type, COUNT(t.soup_type)
  FROM 
  (SELECT extract(year FROM reg_date) AS year, soup_type 
    FROM reviews r JOIN shops s ON (r.sid = s.sid) 
    WHERE s.pref = '神奈川県' OR s.area = '町田市') t
  GROUP BY year, soup_type
  ORDER BY year ASC,  soup_type ASC
;

\o
\crosstabview year soup_type 

