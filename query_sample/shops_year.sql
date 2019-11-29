SELECT category, "year", COUNT(sid)  FROM 
(
SELECT sid, 'ラーメン' category, left(reg_date::text, 4) "year" FROM shops WHERE category @> '{"ramendb":true}'
UNION
SELECT sid, 'カレー' category, left(reg_date::text, 4) "year" FROM shops WHERE category @> '{"currydb":true}'
UNION
SELECT sid, 'チャーハン' category, left(reg_date::text, 4) "year" FROM shops WHERE category @> '{"chahandb":true}'
UNION
SELECT sid, 'ぎょうざ' category, left(reg_date::text, 4) "year" FROM shops WHERE category @> '{"gyouzadb":true}'
UNION
SELECT sid, 'うどん' category, left(reg_date::text, 4) "year" FROM shops WHERE category @> '{"udondb":true}'
UNION
SELECT sid, 'そば' category, left(reg_date::text, 4) "year" FROM shops WHERE category @> '{"sobadb":true}'
) t
GROUP BY category, "year" ORDER BY "year"
;
