<?php

include_once "/srv/www/one.example.com.db.php";

// Connecting, selecting database
$link = mysql_connect( $db_host, $db_user, $db_password)
    or die('Could not connect: ' . mysql_error());
mysql_select_db($db_name) or die('Could not select database');

// Performing SQL query
$query = 'SELECT count(*) FROM City';
$result = mysql_query($query) or die('Query failed: ' . mysql_error());

// Free resultset
mysql_free_result($result);

// Closing connection
mysql_close($link);
echo '__DB_SUCCESS__';
?>
