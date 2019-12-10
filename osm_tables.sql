/*
 * Tables for querying an extract of Open Street Map "Planet" dump,
 * pared down to a specific region (the UK).
 */

DROP TABLE IF EXISTS osm;
CREATE TABLE osm
(
  id BIGINT PRIMARY KEY
  /* , date_time DATETIME */
  , date_time TIMESTAMP
  , uid BIGINT
  , lat DOUBLE PRECISION
  , lon DOUBLE PRECISION
  , name TEXT
) ENGINE=INNODB;

-- Intermediate table, for loading
DROP TABLE IF EXISTS osm_load;
CREATE TABLE osm_load
(
  id BIGINT PRIMARY KEY
  , date_time TEXT
  , uid BIGINT
  , lat DOUBLE PRECISION
  , lon DOUBLE PRECISION
  , name TEXT
) ENGINE=INNODB;

DROP TABLE IF EXISTS osm_k_v;
CREATE TABLE osm_k_v
(
  id BIGINT
  , k VARCHAR(64)
  , v VARCHAR(512)
  , FOREIGN KEY (id) REFERENCES osm(id) ON DELETE CASCADE
) ENGINE=INNODB;

