#!/bin/sh
# Retrieve View 
DB=ramendb
USER=postgres

psql -U ${USER} ${DB} -c "SELECT 'shops' AS ""table"", count(*), min(sid), max(sid) FROM shops UNION SELECT 'reviews' AS ""table"", count(*), min(rid), max(rid) FROM reviews UNION SELECT 'users' AS ""table"", count(*), min(uid), max(uid) FROM users" 

