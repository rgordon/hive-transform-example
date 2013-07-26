
set SRCDIR='/Users/Shared/projects/hive-transform-example'
set DATADIR='/Users/Shared/projects/hive-transform-example/data'

drop table if exists docs;
CREATE TABLE docs (line STRING);

LOAD DATA LOCAL INPATH '${hiveconf:DATADIR}/' OVERWRITE INTO TABLE docs;

drop table if exists word_count;

CREATE TABLE word_count (word STRING, count INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

FROM (
   FROM docs
   SELECT TRANSFORM (line) USING '${hiveconf:SRCDIR}/mapper.py' AS word, count
   CLUSTER BY word
) wc
INSERT OVERWRITE TABLE word_count
SELECT TRANSFORM (wc.word, wc.count) USING '${hiveconf:SRCDIR}/reducer.py' AS word, count;