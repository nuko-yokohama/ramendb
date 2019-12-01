SELECT sc.area, scount, rcount, ROUND((rcount::numeric / scount::numeric * 100),2) AS ratio FROM 
(SELECT area, COUNT(*) AS scount FROM shops WHERE pref = '神奈川県' AND area ~ '横浜市.*' AND category @> '{"ramendb": true}' GROUP BY area) sc 
LEFT OUTER JOIN 
(SELECT area, COUNT(DISTINCT r.sid) AS rcount FROM reviews r JOIN shops s ON (r.sid = s.sid) WHERE pref= '神奈川県' AND area ~ '横浜市.*' AND r.category = 'ラーメン' AND uid = 8999 GROUP BY area) rc ON (sc.area = rc.area)
ORDER BY ratio DESC;
