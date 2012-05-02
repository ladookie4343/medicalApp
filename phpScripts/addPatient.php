<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   $officeID = $mysqli->real_escape_string($_POST['officeID']);
   
   $query = "INSERT INTO officePatientList " .
            "(patientID, officeID) ".
            "VALUES " .
            "($patientID, $officeID)";
   
   $mysqli->query($query);

?>
