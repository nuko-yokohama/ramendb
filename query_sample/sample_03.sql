--
-- 2017年に、どのユーザが合計何回コメントを送信したか。
--
SELECT review_uid, COUNT(review_uid)
  FROM (SELECT c.* FROM comments c JOIN reviews r ON (c.rid = r.rid) WHERE r.reg_date >= '2017-01-01' AND reg_date < '2019-01-01') c2017
  GROUP BY review_uid ORDER BY review_uid;

--
-- 2017年に、どのユーザが合計何回コメントを受信したか。
--


--
-- 2017年に、どのユーザがどのユーザにコメントを何件コメントしたか。
--
SELECT review_uid, comment_uid, COUNT(comment_uid)
  FROM (SELECT c.* FROM comments c JOIN reviews r ON (c.rid = r.rid) WHERE r.reg_date >= '2017-01-01' AND reg_date < '2019-01-01') c2017
  GROUP BY review_uid, comment_uid ORDER BY review_uid, comment_uid;

--
-- 神奈川オフ会レギュラーメンバー間のコメント数
--
SELECT review_uid, comment_uid, COUNT(review_uid)
  FROM (SELECT c.* FROM comments c JOIN reviews r ON (c.rid = r.rid)
  WHERE r.reg_date >= '2017-01-01' AND reg_date < '2018-01-01'
    AND review_uid IN (8999, 146958, 6084, 33463, 77743, 93238, 10254, 115639, 23528)
    AND comment_uid IN (8999, 146958, 6084, 33463, 77743, 93238, 10254, 115639, 23528)
  ) c2017
  GROUP BY review_uid, comment_uid  ORDER BY comment_uid, review_uid
;

--
-- 注目ユーザランキングTOP 10ユーザ(2018-03-25調査)間の関係
--
SELECT review_uid, comment_uid, COUNT(review_uid)
  FROM (SELECT c.* FROM comments c JOIN reviews r ON (c.rid = r.rid)
  WHERE r.reg_date >= '2017-01-01' AND reg_date < '2018-01-01'
    AND review_uid IN (133913,62785,121074,15595,31332,115392,127241,34293,143478,143478)
    AND comment_uid IN (133913,62785,121074,15595,31332,115392,127241,34293,143478,143478)
  ) c2017
  GROUP BY review_uid, comment_uid  ORDER BY comment_uid, review_uid
;

--
-- 2017年に神奈川の店舗にレビューした件数が多い20名のユーザに対してコメントしたユーザとコメント数
--
SELECT review_uid, comment_uid, COUNT(review_uid)
  FROM (SELECT c.* FROM comments c JOIN reviews r ON (c.rid = r.rid)
  WHERE r.reg_date >= '2017-01-01' AND reg_date < '2018-01-01'
    AND review_uid IN  (SELECT uid FROM reviews r JOIN shops s ON (r.sid = s.sid) WHERE s.pref ='神奈川県' AND reg_date > '2017-01-01' GROUP BY uid ORDER BY count(uid) DESC LIMIT 20)
  ) c2017
  GROUP BY review_uid, comment_uid  ORDER BY comment_uid, review_uid
;


