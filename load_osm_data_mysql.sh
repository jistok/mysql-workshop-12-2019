#!/bin/bash

# TODO: set this to the name of your MySQL service
svc_name="dev-db-20"

# The remaining values are ok as they are.
osm_url="https://s3.amazonaws.com/goddard.datasets/osm.csv.gz"
osm_kv_url="https://s3.amazonaws.com/goddard.datasets/osm_k_v.csv.gz"

# Load the osm_load table.
curl $osm_url | zcat - | cf mysql $svc_name --local-infile=1 \
  -e "LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE osm_load FIELDS TERMINATED BY ',';"

# Load the osm table from that landing table.
cat <<EndOfSQL | cf mysql $svc_name
INSERT INTO osm
SELECT id, TIMESTAMP(STR_TO_DATE(date_time, '%Y-%m-%dT%H:%i:%sZ')), uid, lat, lon, name
FROM osm_load
ORDER BY id ASC;
EndOfSQL

# Drop that load table (you can just run the SQL in your MySQL client if you prefer to do that)
echo "DROP TABLE osm_load;" | cf mysql $svc_name

# Load the osm_k_v table.
curl $osm_kv_url | zcat - | cf mysql $svc_name --local-infile=1 \
  -e "LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE osm_k_v FIELDS TERMINATED BY ',';"

