#!/bin/bash

echo "get shops data" $1 $2
python3 get_rdb_user.py $1 $2 > /tmp/u.txt

# load shops daat
echo "load users data" $1 $2
psql -U postgres ramendb -e -c "DELETE FROM users WHERE uid >= $1 AND uid <= $2"
psql -U postgres ramendb -e  -c "COPY users FROM '/tmp/u.txt'"
psql -U postgres ramendb -e -c "CLUSTER users"
psql -U postgres ramendb -e -c "TABLE aggs_v"

