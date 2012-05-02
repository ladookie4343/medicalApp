<?php

require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   
   $query = "DELETE FROM medical_conditions " .
            "WHERE patientID = $patientID";
   
   $mysqli->query($query);
   
?>
