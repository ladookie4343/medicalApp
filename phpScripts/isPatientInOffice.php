<?php
   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $officeID = $mysqli->real_escape_string($_POST['officeID']);
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   
   $query = "SELECT * FROM " .
            "officePatientList OPL " . 
            "WHERE OPL.officeID = $officeID AND OPL.patientID = $patientID";
   
   $data = $mysqli->query($query);
   
   if (mysqli_num_rows($data) == 1) {
      echo 'yes';
   } else if (mysqli_num_rows ($data) == 0){
      echo 'no';
   } 
?>
