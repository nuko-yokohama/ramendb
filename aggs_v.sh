#!/bin/sh
DB=ramendb
USER=postgres

psql -p ${PORT} -U ${USER} ${DB} -c "TABLE aggs_v"

