<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $officeID = $mysqli->real_escape_string($_POST['officeID']);
   
   $query = "SELECT P.patientID, P.firstname, P.lastname, P.image " .
            "FROM officePatientList oPL, patient P " .
            "WHERE oPL.officeID = $officeID AND oPL.patientID = P.patientID " .
            "ORDER BY P.lastname";
   
   $data = $mysqli->query($query);
   
   $row = mysqli_fetch_array($data);
   echo '[' . json_encode($row);
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo ']';
?>