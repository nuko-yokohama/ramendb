--
-- extra view add script
-- (with incremental materialized view test)
--
CREATE INCREMENTAL MATERIALIZED VIEW kanagawa_house_review_imv AS
SELECT s.sid,
    s.name,
    s.branch,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE s.pref = '神奈川県' AND s.status = 'open' AND s.tags = '{家系}'
;

CREATE VIEW kanagawa_house_review_v AS
SELECT s.sid,
    s.name,
    s.branch,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE s.pref = '神奈川県' AND s.status = 'open' AND s.tags = '{家系}'
;

CREATE VIEW AS sanmamen_v
SELECT s.sid,
    s.pref,
    s.area,
    s.name,
    s.branch,
    s.status,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE (s.pref = ANY (ARRAY['神奈川県', '東京都'])) AND s.status = 'open' AND r.menu ~ '((さんま|サンマ)[(ー|あ|ぁ)]|生(馬|碼))(めん|メン|麺)'
;

CREATE INCREMENTAL MATERIALIZED VIEW sanmamen_imv AS
SELECT s.sid,
    s.pref,
    s.area,
    s.name,
    s.branch,
    s.status,
    r.menu,
    r.score,
    r.reg_date
   FROM shops s
     JOIN reviews r ON s.sid = r.sid
  WHERE (s.pref = ANY (ARRAY['神奈川県', '東京都'])) AND s.status = 'open' AND r.menu ~ '((さんま|サンマ)[(ー|あ|ぁ)]|生(馬|碼))(めん|メン|麺)'
;

