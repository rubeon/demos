

Demo
=============

 * Spin up a '2 vCPU(s), 7 GB RAM, 1.4 TB Disk' cluster in Rackspace public cloud

 * Create a user while spinning up the cluster. Note this User's password as you will need it later. You can also upload a SSH key. For this example, create a user called demo.

 * Download the files. The gutenberg files are text versions of The Notebooks of Leonardo Da Vinci
& Ulysses by James Joyce.

mkdir wc
wget -O book1.txt  http://www.gutenberg.org/etext/5000
wget -O book2.txt  http://www.gutenberg.org/etext/4300
cat book1.txt book2.txt > books.txt
wget https://raw.githubusercontent.com/bigcloudsolutions/demos/master/hadoop/reducer.py
wget https://raw.githubusercontent.com/bigcloudsolutions/demos/master/hadoop/mapper.py
hadoop dfs -copyFromLocal book1.txt 
hadoop dfs -copyFromLocal book2.txt 
hadoop dfs -rm wc.out


 * Run the job

hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/demo/wc/mapper.py    -mapper /home/demo/wc/mapper.py \
-file /home/demo/wc/reducer.py   -reducer /home/demo/wc/reducer.py \
-input /user/demo/books.txt -output /user/demo/wc-books.out

hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/demo/wc/mapper.py    -mapper /home/demo/wc/mapper.py \
-file /home/demo/wc/reducer.py   -reducer /home/demo/wc/reducer.py \
-input /user/demo/book1.txt -output /user/demo/wc-book1.out

hadoop jar /usr/lib/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/demo/wc/mapper.py    -mapper /home/demo/wc/mapper.py \
-file /home/demo/wc/reducer.py   -reducer /home/demo/wc/reducer.py \
-input /user/demo/book2.txt -output /user/demo/wc-book2.out


hduser@ubuntu:/usr/local/hadoop$ bin/hadoop jar contrib/streaming/hadoop-*streaming*.jar -D mapred.reduce.tasks=16 ...

