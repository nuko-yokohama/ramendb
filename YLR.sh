#!/bin/bash
$HOME/pgsql/pgsql/bin/psql ramendb -e -c "SELECT rid, area, max AS last_review, count FROM user_review_area_v WHERE uid = 8999 AND area ~ '横浜市' ORDER BY max ASC;"

