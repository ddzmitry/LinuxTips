## HIVE
_Tables could be external and internal by default table is internal_

```$xslt
create table if not exists table1 (col1 string,col2 array<string>,col3 string,col4 int) row 
\format delimited  fields terminated by',' 
\collection items terminated by':' 
\lines terminated by '\n' stored as textfile;
```
_Set metastore_
```$xslt
 set hive.metastore.warehouse.dir;
```
_Set custom metastore_
```$xslt
    create table if not exists table7 (col1 string,col2 array<string>,col3 string,col4 int) 
    \row format delimited  fields terminated by',' 
    \collection items terminated by':' lines terminated by '\n' 
    \stored as textfile location '/user/dzmitry/table3';
   ```
   
_Create External table in which if it was dropped the metadata will be gone, however table will still be in HDFS_
   ```$xslt
    create external table if not exists table12 (col1 string,col2 array<string>,col3 string,col4 int) 
    row format delimited  fields terminated by',' 
    collection items terminated by':' lines terminated by '\n' 
    stored as textfile location '/user/dzmitry/table3';
   ```
   
_Link Metadata_
> From Local
```$xslt
load data local inpath '/tmp/table1.txt' into table table1;
```
> From HDFS
```$xslt
load data  inpath 'dzmitry/data/table1.txt' into table table1;
```
```$xslt
Hadoop can be accessed on host:50070
```