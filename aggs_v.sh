#!/bin/sh
PORT=5432
DB=ramendb
USER=postgres

psql -p ${PORT} -U ${USER} ${DB} -c "TABLE aggs_v"

