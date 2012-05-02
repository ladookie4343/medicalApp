<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $visitID = $mysqli->real_escape_string($_POST['visitID']);

   $query = "SELECT P.drug " .
            "FROM prescriptions P " .
            "WHERE P.visitID = $visitID ";
   
   $data = $mysqli->query($query);
   
   $row = mysqli_fetch_array($data);
   echo '[' . json_encode($row);
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo ']';
?>
