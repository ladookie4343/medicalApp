<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   $allergy = $mysqli->real_escape_string($_POST['allergy']);
   
   $query = "INSERT INTO allergies " .
            "(patientID, allergy) ".
            "VALUES " .
            "($patientID, '$allergy')";
   
   $mysqli->query($query);
?>
