CREATE TABLE shops_location (
  sid integer,
  latitude real,
  longitude real
);

CREATE TABLE target_location (
  tid integer,
  name text,
  pref text,
  area text,
  latitude real,
  longitude real
);

--
-- location geography table. (required PostGIS)
--
CREATE MATERIALIZED VIEW shops_location_mv AS
SELECT shops_location.sid,
    (((('POINT('::text || shops_location.longitude) || ' '::text) || shops_location.latitude) || ')'::text)::geography AS geography
   FROM shops_location;

CREATE MATERIALIZED VIEW target_location_mv AS
SELECT target_location.tid,
    (((('POINT('::text || target_location.longitude) || ' '::text) || target_location.latitude) || ')'::text)::geography AS geography
   FROM target_location;

