<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   $officeID = $mysqli->real_escape_string($_POST['officeID']);
   $doctorID = $mysqli->real_escape_string($_POST['doctorID']);
   $date = $mysqli->real_escape_string($_POST['date']);
   $reason = $mysqli->real_escape_string($_POST['reason']);
   $diagnosis = $mysqli->real_escape_string($_POST['diagnosis']);
   $height = $mysqli->real_escape_string($_POST['height']);
   $weight = $mysqli->real_escape_string($_POST['weight']);
   $bp_systolic = $mysqli->real_escape_string($_POST['bp_systolic']);
   $bp_diastolic = $mysqli->real_escape_string($_POST['bp_diastolic']);
   
   $query = "INSERT INTO  visits (
             visitID ,
             patientID ,
             officeID ,
             doctorID ,
             `when` ,
             reason ,
             diagnosis ,
             height ,
             weight ,
             bp_systolic ,
             bp_diastolic
             )
             VALUES (
             NULL ,  $patientID,  $officeID,  $doctorID,  '$date',  '$reason',  '$diagnosis',  $height,  $weight,  $bp_systolic,  $bp_diastolic
             );";
   
   $mysqli->query($query);


?>