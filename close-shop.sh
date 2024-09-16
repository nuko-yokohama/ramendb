#!/bin/bash
#
sid=$1

psql ramendb -c "SELECT * FROM shops WHERE sid = ${sid}"
psql ramendb -c "UPDATE shops SET status = 'closed' WHERE sid = ${sid}"
psql ramendb -c "SELECT * FROM shops WHERE sid = ${sid}"

