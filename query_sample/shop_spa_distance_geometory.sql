--
-- 店舗のID(sid)から10Km以内にあるスパのリスト近傍5件を検索する。
--
PREPARE shop_near_spa(int) AS
WITH t AS
(
  SELECT tl.tid, tl.name, round(ST_Distance((SELECT geo FROM shops_location_geometry WHERE sid = $1), .geography)::real) as dist FROM target_location_geometry tlg JOIN target_location tl ON (tlg.tid = tl.tid)
)
SELECT * FROM t WHERE dist <= 10000 ORDER BY dist ASC LIMIT 10;

--
-- スパのID(tid)から3Km以内にあるラーメン提供店舗のリスト近傍10件を検索する。
--
PREPARE spa_near_shop(int) AS
WITH t AS
(
  SELECT s.sid, left(s.name,16) name, left(s.branch, 16) branch, round(ST_Distance((SELECT geography FROM target_location_mv WHERE tid = $1), sl.geography)::real) as dist FROM shops s JOIN shops_location_mv sl ON (s.sid = sl.sid) WHERE s.status = 'open' AND category @> '{"ramendb":true}'
)
SELECT * FROM t WHERE dist <= 5000 ORDER BY dist ASC LIMIT 20;
