<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   
   echo '[';
   // get dob, height, bloodType
   $query = "SELECT P.dob, P.height, P.bloodType " .
            "FROM patient P " .
            "WHERE P.patientID = $patientID ";
   
   $data = $mysqli->query($query);  
   $row = mysqli_fetch_array($data);
   echo json_encode($row);
   echo ',';
    
   
   // get allergies
   $query = "SELECT A.allergy " .
            "FROM allergies A " .
            "WHERE A.patientID = $patientID";
   $data = $mysqli->query($query);
   echo '[';
   $row = mysqli_fetch_array($data);
   if ($row) {
      echo json_encode($row);
   }
   
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo '], ';
   
   // get medical conditions
   $query = "SELECT M.condition " .
            "FROM medical_conditions M " .
            "WHERE M.patientID = $patientID";
   $data = $mysqli->query($query);
   echo '[';
   $row = mysqli_fetch_array($data);
   if ($row) {
      echo json_encode($row);
   }
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo ']]';
?>
