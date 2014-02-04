<?php
session_start();
// Set the JSON header
header("Content-type: text/json");

// The x value is the current JavaScript time, which is the Unix time multiplied 
// by 1000.
$x = time() * 1000;
// The y value is a random number
if (!isset($_SESSION['y'])) {
  $_SESSION['y'] = 5;
} else {
  if ($_SESSION['y'] > 100) {
    $_SESSION['y'] = 5;
  }
  else {
    $_SESSION['y']+= 5;
  }
}

$y = $_SESSION['y'];

//$y = 10 + rand(0, 100);

// Create a PHP array and echo it as JSON
$ret = array($x, $y);
echo json_encode($ret);
?>

