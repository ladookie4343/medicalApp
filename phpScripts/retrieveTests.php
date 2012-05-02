<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   

   $query = "SELECT * " .
            "FROM tests T " .
            "WHERE T.patientID = $patientID " .
            "ORDER BY T.when";
   
   $data = $mysqli->query($query);
   
   $row = mysqli_fetch_array($data);
   echo '[' . json_encode($row);
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo ']';
   
?>
