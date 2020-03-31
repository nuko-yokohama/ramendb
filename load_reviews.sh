#!/bin/bash

echo "get reviews data" $1 $2
python3 get_rdb_review.py $1 $2 > /tmp/r.txt

# load shops daat
echo "load reviews data" $1 $2
psql -U postgres ramendb -e -c "DELETE FROM reviews WHERE rid >= $1"
psql -U postgres ramendb -e  -c "COPY reviews FROM '/tmp/r.txt'"
psql -U postgres ramendb -e -c "CLUSTER reviews"
psql -U postgres ramendb -e -c "TABLE aggs_v"

