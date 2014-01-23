<?php
// Connecting, selecting database
$link = mysql_connect('localhost', 'root', 'helloworld')
    or die('Could not connect: ' . mysql_error());
mysql_select_db('mysql') or die('Could not select database');

// Performing SQL query
$query = 'SELECT count(*) FROM mysql.user';
$result = mysql_query($query) or die('Query failed: ' . mysql_error());

// Free resultset
mysql_free_result($result);

// Closing connection
mysql_close($link);
echo 'DB SUCCESS';
?>
