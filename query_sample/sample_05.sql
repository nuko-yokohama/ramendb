--
-- ステマ疑惑の店を探してみる(sample)
-- 期間：2017年1月1日～2017年12月31日
-- 都道府県：神奈川県
-- レビュー数が3件から10件の範囲で平均点が高い店
--
SELECT (s.name || s.branch) AS name, (pref || area) AS location, count, avg
  FROM
    (SELECT reviews.sid, COUNT(reviews.score), round(AVG(reviews.score), 2) AS avg
    FROM reviews JOIN shops ON (reviews.sid = shops.sid)
    WHERE reviews.reg_date BETWEEN '2017-01-01' AND '2017-12-12' AND shops.pref = '神奈川県'
    GROUP BY reviews.sid HAVING count(reviews.score) BETWEEN 3 AND 20
    ORDER BY AVG(reviews.score) DESC LIMIT 50) t
  JOIN
  shops s ON (t.sid = s.sid);

--
-- レビュー数が少なくて信用できないユーザのビュー
--
CREATE VIEW v_untrusted_users AS
 SELECT reviews.uid,
    avg(reviews.score) AS avg,
    count(reviews.score) AS count
   FROM reviews
  GROUP BY reviews.uid
 HAVING avg(reviews.score) > 90::numeric AND count(reviews.score) <= 10;

--
-- 信用できないユーザのみの平均点・レビュー数と全ユーザでの平均値・レビュー数
-- ut_ratio が1に近く、かつut_avgが高い店はステマ疑惑がある。
--
SELECT sid, round(t_avg, 2), t_count, round(ut_avg, 2), ut_count, round(count_ratio * 100, 2) ut_ratio FROM
(
  SELECT t_score.sid, t_score.avg t_avg, t_score.count AS t_count , ut_score.avg AS ut_avg, ut_score.count AS ut_count, (ut_score.count::decimal / t_score.count::decimal) count_ratio
  FROM
  (SELECT sid, AVG(score) , COUNT(score)
    FROM
    reviews r
    GROUP BY sid
    ORDER BY AVG(score) DESC, COUNT(score) DESC
  ) t_score
  JOIN
  (SELECT sid, AVG(score), COUNT(score)
    FROM
    reviews r
    JOIN
    v_untrusted_users v_ur
    ON (r.uid = v_ur.uid)
    GROUP BY sid
    ORDER BY AVG(score) DESC, COUNT(score) DESC
    LIMIT 10000) ut_score
  ON (t_score.sid = ut_score.sid)
  ORDER BY ut_score.avg DESC
) x
WHERE t_avg >= 90 AND count_ratio > 0.5
ORDER BY count_ratio DESC, ut_count DESC
;

--
-- 上記の改良版
-- 3回以上ステマレビューしているユーザを絞り込みする。
--
SELECT s.name, s.pref, z.* FROM (
SELECT sid, round(t_avg, 2), t_count, round(ut_avg, 2), ut_count, round(count_ratio * 100, 2) ut_ratio FROM
(
SELECT t_score.sid, t_score.avg t_avg, t_score.count AS t_count , ut_score.avg AS ut_avg, ut_score.count AS ut_count, (ut_score.count::decimal / t_score.count::decimal) count_ratio
FROM
(SELECT sid, AVG(score) , COUNT(score)
  FROM
  reviews r
  GROUP BY sid
  ORDER BY AVG(score) DESC, COUNT(score) DESC
  ) t_score
JOIN
(SELECT sid, AVG(score), COUNT(score)
  FROM
  reviews r
  JOIN
  v_untrusted_users v_ur
  ON (r.uid = v_ur.uid)
  GROUP BY sid
  ORDER BY AVG(score) DESC, COUNT(score) DESC
  LIMIT 10000) ut_score
ON (t_score.sid = ut_score.sid)
ORDER BY ut_score.avg DESC
) x
WHERE t_avg >= 90 AND count_ratio > 0.5
ORDER BY count_ratio DESC, ut_count DESC
) z
JOIN
shops s
ON (z.sid = s.sid)
WHERE ut_count >= 3
ORDER BY ut_ratio DESC, ut_count DESC
;

