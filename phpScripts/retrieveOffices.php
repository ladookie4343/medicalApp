<?php

   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $username = $mysqli->real_escape_string($_POST['username']);
   
   $query = "SELECT O.officeID, O.name, O.street, O.city, O.state, O.zip, O.phone, O.email, O.website, O.image " .
      "FROM (SELECT D.doctorID FROM doctor D WHERE D.username = '$username') AS tempDoctorTable, officeDoctorList oDL, office O " .
      "WHERE oDL.doctorID = tempDoctorTable.doctorID AND O.officeID = oDL.officeID;";
   
   $data = $mysqli->query($query);
   
   $row = mysqli_fetch_array($data);
   echo '[' . json_encode($row);
   while ($row = mysqli_fetch_array($data)) {
      echo ',';
      echo json_encode($row);
   }
   echo ']';
?>
