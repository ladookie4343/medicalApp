<?php
   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $username = $mysqli->real_escape_string($_POST['username']);
   
   $query = "SELECT D.doctorID, D.firstname, D.lastname " .
            "FROM doctor D " .
            "WHERE D.username = '$username' ";
   $data = $mysqli->query($query);
   $row = mysqli_fetch_array($data);
   echo json_encode($row);

?>
