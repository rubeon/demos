
Simple Demo
=====

 * Spin up a '2 vCPU(s), 7 GB RAM, 1.4 TB Disk' cluster in Rackspace public cloud

 * Create a user while spinning up the cluster. Note this User's password as you will need it later. You can also upload a SSH key. For this example, create a user called demo.


 * Cleanup if you want start fresh and start with a clean dir. 
```
rm -rf /home/demo/wc
hadoop dfs -rmr /user/demo/wc
hadoop dfs -mkdir wc

```


 * Download the files. The gutenberg files are text versions of The Notebooks of Leonardo Da Vinci
& Adventures of Sherlock Holmes. IF you want a bigger sample set, download more books :-)
```
cd
mkdir wc
cd wc
wget -O book1.txt  http://www.gutenberg.org/cache/epub/5000/pg5000.txt
wget -O book2.txt  http://www.gutenberg.org/cache/epub/1661/pg1661.txt
cat book1.txt book2.txt > books.txt
wget --no-check-certificate https://raw.githubusercontent.com/RackspaceDevOps/demos/master/hadoop/reducer1.py
wget --no-check-certificate https://raw.githubusercontent.com/RackspaceDevOps/demos/master/hadoop/mapper1.py
wget --no-check-certificate https://raw.githubusercontent.com/RackspaceDevOps/demos/master/hadoop/reducer2.py
wget --no-check-certificate https://raw.githubusercontent.com/RackspaceDevOps/demos/master/hadoop/mapper2.py

```

 * reducer1.py & mapper1.py are generic python scripts which will work anywhere. Even outside Hadoop.

 * reducer2.py & mapper2.py are more specific to Hadoop.


 * Copy stuff to the Hadoop file system
``` 

cd /home/demo/wc
hadoop dfs -copyFromLocal book1.txt wc/book1.txt 
hadoop dfs -copyFromLocal book2.txt wc/book2.txt
hadoop dfs -copyFromLocal books.txt wc/books.txt 
hadoop dfs -ls wc

```

 * Run the job with book1.txt and mapper1. Output is the folder name.

```

hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/demo/wc/mapper1.py    -mapper /home/demo/wc/mapper1.py \
-file /home/demo/wc/reducer1.py   -reducer /home/demo/wc/reducer1.py \
-input /user/demo/wc/book1.txt -output /user/demo/wc/results

```

 * Execution will end with the output file being created.
```
14/04/01 16:20:17 INFO streaming.StreamJob:  map 0%  reduce 0%
14/04/01 16:20:31 INFO streaming.StreamJob:  map 50%  reduce 0%
14/04/01 16:20:32 INFO streaming.StreamJob:  map 100%  reduce 0%
14/04/01 16:20:40 INFO streaming.StreamJob:  map 100%  reduce 33%
14/04/01 16:20:41 INFO streaming.StreamJob:  map 100%  reduce 100%
14/04/01 16:20:44 INFO streaming.StreamJob: Job complete: job_201404011411_0003
14/04/01 16:20:44 INFO streaming.StreamJob: Output: /user/demo/wc/results
```
 * View results
```
hadoop dfs -ls wc/results
hadoop dfs -cat /user/demo/wc/results/part-00000
hadoop dfs -cat /user/demo/wc/results/part-00000 |sort -gk 2
```

 * If you want to run again, remove the results directory or use a different one each time
``` 
hadoop dfs -rmr wc/results
```

 * Test with the bigger files
```

hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/demo/wc/mapper2.py    -mapper /home/demo/wc/mapper2.py \
-file /home/demo/wc/reducer2.py   -reducer /home/demo/wc/reducer2.py \
-input /user/demo/wc/books.txt -output /user/demo/wc/results

```

 * View results
```
hadoop dfs -ls wc/results
hadoop dfs -cat /user/demo/wc/results/part-00000
hadoop dfs -cat /user/demo/wc/results/part-00000 |sort -gk 2
```

Pig example
=====

 * Install pig
```
wget http://mirror.catn.com/pub/apache/pig/pig-0.12.0/pig-0.12.0.tar.gz
tar zxvf pig-0.12.0.tar.gz
export PATH=$PATH:~/pig/bin
```

 * Download some test data. Data is the City table from mysql's world sample database.

```
mkdir city
wget --no-check-certificate https://raw.githubusercontent.com/RackspaceDevOps/demos/master/hadoop/input/city.csv
```

 * Load data in HDFS
```
hadoop dfs -rmr /user/demo/city
hadoop dfs -mkdir city
hadoop dfs -copyFromLocal city.csv city/city.csv
```

 * Start pig 
```
pig
```

 * Run the following pig commands to load data
```
city = LOAD '/user/demo/city/city.csv' USING PigStorage(',') as (id,name,country_code,district,population);
DUMP city;
```

 * Now run some queries
```
pop_greater_than_10000 = FILTER city by population>10000;
dump pop_greater_than_10000;
```

 * To view more details of the execution use

```
ILLUSTRATE pop_greater_than_10000;
```

 * Another example with Order 

```
pop_asc = ORDER city by population DESC;
DUMP pop_asc;
```


More complex examples
=====
TODO :
 * Write to MySQL
 * Parse network data
 * Other cool stuff

