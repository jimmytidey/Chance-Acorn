<?php  
if ($PHP_AUTH_USER != "mysuser"  
    or $PHP_AUTH_PW != "mypass"):  
  // Bad or no username/password.  
  // Send HTTP 401 error to make the  
  // browser prompt the user.  
  header("WWW-Authenticate: " .  
         "Basic realm=\"Protected Page: " .  
         "Enter your username and password " .  
         "for access.\"");  
  header("HTTP/1.0 401 Unauthorized");  
  // Display message if user cancels dialog  
  ?>  
  <html>  
  <head><title>Authorization Failed</title></head>  
  <body>  
  <h1>Authorization Failed</h1>  
  <p>Without a valid username and password,  
     access to this page cannot be granted.  
     Please click 'reload' and enter a  
     username and password when prompted.  
  </p>  
  </body>  
  </html>  
<?php else: ?>  
 
<!DOCTYPE html>
<html>
<head>