<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $officeID = $mysqli->real_escape_string($_POST['officeID']);
   $patientID = $mysqli->real_escape_string($_POST['patientID']);

   $query = "SELECT * " .
            "FROM visits V " .
            "WHERE V.officeID = $officeID AND V.patientID = $patientID " .
            "ORDER BY V.when";
   
   $data = $mysqli->query($query);
   
   $row = mysqli_fetch_array($data);
   echo '[' . json_encode($row);
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo ']';
?>