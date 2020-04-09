CREATE VIEW nuko_noreview_yokohama AS
SELECT s.sid,
    s.area,
    s.name,
    s.branch
   FROM shops s
  WHERE s.area ~ '横浜市*'::text AND s.status = 'open'::text AND s.category @> '{"ramendb": true}'::jsonb AND NOT (s.sid IN ( SELECT reviews.sid
           FROM reviews
          WHERE reviews.uid = 8999));

