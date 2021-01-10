#!/bin/bash

echo "get shops_location data" $1 $2
python3 get_rdb_shop_location.py $1 $2 > /tmp/sl.txt

# load shops daat
echo "load shops_location data" $1 $2
psql -U postgres ramendb -e -c "DELETE FROM shops_location WHERE sid >= $1 AND sid <= $2"
psql -U postgres ramendb -e  -c "COPY shops_location FROM '/tmp/sl.txt'"
psql -U postgres ramendb -e -c "CLUSTER shops_location"
psql -U postgres ramendb -e -c "REFRESH MATERIALIZED VIEW shops_location_mv"
psql -U postgres ramendb -e -c "TABLE aggs_v"

