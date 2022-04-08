--
-- update_shops_location_geometory
--
TRUNCATE shops_location_geometry;

INSERT INTO shops_location_geometry
 SELECT sid,st_geomfromtext(((('POINT('::text || shops_location.longitude) || ' '::text)
|| shops_location.latitude) || ')'::text, 4326) AS geo
  FROM shops_location;

