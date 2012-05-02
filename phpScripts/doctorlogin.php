<?php
   require_once('connectvars.php');
   $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
   
   $username = $mysqli->real_escape_string($_POST['username']);
   $password = $mysqli->real_escape_string($_POST['password']);
   
   $query = "SELECT * FROM doctor WHERE username = '$username' AND password = SHA('$password')";
   $data = $mysqli->query($query);
   
   if (mysqli_num_rows($data) == 1) {
      echo 'yes';
   } else if (mysqli_num_rows ($data) == 0){
      echo 'no';
   } 
?>
