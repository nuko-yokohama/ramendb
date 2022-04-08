--
-- update_target_location_geometory
--
TRUNCATE target_location_geometry;

INSERT INTO target_location_geometry
 SELECT tid,st_geomfromtext(((('POINT('::text || target_location.longitude) || ' '::text)
|| target_location.latitude) || ')'::text, 4326) AS geo
  FROM target_location;


