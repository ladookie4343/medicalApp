<?php
   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $patientID = $mysqli->real_escape_string($_POST['patientID']);
   
   $query = "SELECT V.weight, V.bp_systolic, V.bp_diastolic, V.height " .
            "FROM visits V " .
            "WHERE V.patientID = $patientID " .
            "ORDER BY V.when DESC";
   
   $data = $mysqli->query($query);
   
   $row = mysqli_fetch_array($data);
   
   echo json_encode($row);

?>
