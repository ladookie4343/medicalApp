<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $visitID = $mysqli->real_escape_string($_POST['visitID']);
   $drug = $mysqli->real_escape_string($_POST['drug']);
   
   $query = "INSERT INTO prescriptions " .
            "(visitID, drug) ".
            "VALUES " .
            "($visitID, $drug)";
   
   $mysqli->query($query);
   
?>
