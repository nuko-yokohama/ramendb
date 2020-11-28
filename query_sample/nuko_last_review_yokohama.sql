--
-- uid = 8999 のユーザが横浜市内各区で最後にレビューを登録した日
--
SELECT * FROM user_review_area_v WHERE area ~ '横浜市' AND uid = 8999 ORDER BY max DESC;

