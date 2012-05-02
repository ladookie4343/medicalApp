<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   $doctorID = $mysqli->real_escape_string($_POST['doctorID']);
   $date = $mysqli->real_escape_string($_POST['date']);
   $type = $mysqli->real_escape_string($_POST['type']);
   $result = $mysqli->real_escape_string($_POST['result']);
   
   $query = "INSERT INTO tests (
             patientID ,
             doctorID ,
             `when` ,
             test_type ,
             test_result
             )
             VALUES (
             $patientID,  $doctorID,  '$date',  '$type',  '$result'
             );";
   
   $mysqli->query($query);

?>
