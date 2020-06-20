#!/bin/sh
# Retrieve View 
DB=ramendb
USER=postgres

psql -U ${USER} ${DB} -c "TABLE aggs_v"

