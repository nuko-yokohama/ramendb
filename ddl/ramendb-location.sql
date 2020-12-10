CREATE TABLE shops_location (
  sid integer,
  latitude real,
  longitude real
);

CREATE TABLE target_location (
  tid integer,
  name text,
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

