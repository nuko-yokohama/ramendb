#!/bin/bash

psql ramendb -c "SELECT sid,status, name, branch, point FROM shops WHERE area = '$1' AND category @> '{\"ramendb\":true}' AND sid IN (SELECT DISTINCT s.sid FROM shops s JOIN reviews r ON (s.sid = r.sid) WHERE r.uid = 8999 AND r.category = 'ラーメン' ) ORDER BY point DESC"

