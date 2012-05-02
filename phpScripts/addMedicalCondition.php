<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   $medicalCondition = $mysqli->real_escape_string($_POST['medicalCondition']);
   
   $query = "INSERT INTO medical_conditions " .
            "(patientID, `condition`) ".
            "VALUES " .
            "($patientID, '$medicalCondition')";
   
   $mysqli->query($query);
?>
