--
-- 横浜の区別の登録店舗カテゴリ 
--
SELECT area, substring(jet from '(ramendb|currydb|chahandb|gyouzadb|udondb|sobadb)') category, count(*) 
FROM 
(SELECT substring(area from 4 for 18) area, jsonb_each_text(s.category)::text jet 
 FROM shops s
 WHERE area LIKE '横浜市%' AND status = 'open'
) t 
WHERE jet LIKE '%true%' 
GROUP BY area, category ORDER BY area;
