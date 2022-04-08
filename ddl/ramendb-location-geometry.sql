CREATE TABLE shops_location (
  sid integer,
  latitude real,
  longitude real
);

CREATE TABLE target_location (
  tid integer,
  name text,
  kind text,
  pref text,
  area text,
  latitude real,
  longitude real
);

CREATE TABLE shops_location_geometry (sid int primary key);
SELECT AddGeometryColumn('', 'shops_location_geometry', 'geo', 4326, 'POINT', 2);

CREATE TABLE target_location_geometry (tid int primary key);
SELECT AddGeometryColumn('', 'target_location_geometry', 'geo', 4326, 'POINT', 2);

