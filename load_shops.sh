#!/bin/bash

echo "get shops data" $1 $2
python3 get_rdb_shop.py $1 $2 > /tmp/s.txt

# load shops daat
echo "load shops data" $1 $2
psql -U postgres ramendb -e -c "DELETE FROM shops WHERE sid >= $1 AND sid <= $2"
psql -U postgres ramendb -e  -c "COPY shops FROM '/tmp/s.txt'"
psql -U postgres ramendb -e -c "CLUSTER shops"
psql -U postgres ramendb -e -c "TABLE aggs_v"

