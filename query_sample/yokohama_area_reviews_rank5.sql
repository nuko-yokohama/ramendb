--
-- yokohama_area_reviews_rank5.sql
-- 横浜市の区ごとにレビュー数が最も多いユーザのID 5名をクロスタブ表示する。
--
SELECT * FROM (

SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市中区'
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市西区'
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市南区'
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市磯子区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜金沢区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市港南区'
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市戸塚区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市栄区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市泉区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜保土ヶ谷区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市旭区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市瀬谷区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市神奈川区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市鶴見区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市港北区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市緑区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市都筑区' 
UNION
SELECT area, uid, count, rank() OVER (PARTITION BY area ORDER BY count DESC, max DESC) FROM user_review_area_v WHERE area ~ '横浜市青葉区' 

) t WHERE t.rank <= 5

\crosstabview area rank uid rank
