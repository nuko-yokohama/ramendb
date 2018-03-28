--
-- 2017末までにレビューされた数 TOP 20の店名、場所、レビュー数、レビュー平均点
--
SELECT s.name, s.branch, (pref || area) AS location, count, avg
  FROM
    (SELECT sid, COUNT(score), round(AVG(score), 2) AS avg FROM reviews WHERE reg_date < '2018-01-01' GROUP BY sid ORDER BY COUNT(sid) DESC LIMIT 20) t
  JOIN
  shops s ON (t.sid = s.sid);


