
set SRCDIR=/Users/Shared/projects/hive-transform-example;
set DATADIR=/Users/Shared/projects/hive-transform-example/data;

-- recreate and load some sample data into the source TABLE

drop table if exists docs;
CREATE TABLE docs (line STRING);
LOAD DATA LOCAL INPATH '${hiveconf:DATADIR}' OVERWRITE INTO TABLE docs
;

-- recreate the destination table now

drop table if exists word_count;
CREATE TABLE word_count (word STRING, count INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
;

-- have not been able to get injected paths to work with Hive yet but the
-- full hard-coded paths do. 
-- this is for 'local' use

FROM (
   FROM docs
   SELECT TRANSFORM (line) 
          USING '/Users/Shared/projects/hive-transform-example/mapper.py' 
          AS word, count
   CLUSTER BY word
) wc
INSERT OVERWRITE TABLE word_count
SELECT TRANSFORM (wc.word, wc.count) 
       USING '/Users/Shared/projects/hive-transform-example/reducer.py' 
       AS word, count
;

-- for cluster use you have to add the files to the DistributedCache
-- and invoke them differently. at least on my cluster (cdh4.2)

-- add file /home/rgordon/transform-test/mapper.py;
-- add file /home/rgordon/transform-test/reducer.py;

-- FROM (
--   FROM videometa.assets_data
--   SELECT TRANSFORM (keywords) 
--          USING 'python mapper.py' 
--          AS word, count
--   CLUSTER BY word
--) wc
--INSERT OVERWRITE TABLE word_count
--SELECT TRANSFORM (wc.word, wc.count) 
--       USING 'python reducer.py' 
--       AS word, count
--;
