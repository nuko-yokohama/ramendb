--
-- レコメンドPREPARE文：この店が好きな人は、これらの店も好きなんじゃないか
--
-- $1 で示した店舗に最も多く高いスコアのレビューを登録している10人のユーザが、
-- 最も多く高いスコアをつけている店舗10件を集計し、そのうち上位10件をリストアップする。
--
PREPARE recmend(integer) AS SELECT s.sid, s.pref, s.name, s.branch FROM shops s JOIN (SELECT sid, SUM(score)  FROM reviews WHERE uid IN (SELECT uid FROM (SELECT uid, SUM(score) FROM reviews WHERE sid = $1 GROUP BY uid ORDER BY SUM(score) DESC LIMIT 10) t) GROUP BY sid ORDER BY SUM(score) DESC LIMIT 10) rs ON s.sid = rs.sid;
