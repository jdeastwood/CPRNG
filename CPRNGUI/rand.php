<html>
<head>
<title>CPRNG Password Generator</title>
</head>
<body bgcolor=#ffc>
<center>
<h1>CPRNG Password Generator</h1>
<p>
<b>Entropy Available at Script Start:</b>
<?php
include 'base91.php';
print(file_get_contents('/proc/sys/kernel/random/entropy_avail'));
print ('<p><b>Your Passwords Are:</b><p>');
$devrandom = mcrypt_create_iv(64);
print('<b>Base 91: </b><table border=1 cellpadding=1><tr><td>' . base91_encode($devrandom) . '</td></tr></table><p>');
print('<b>Base 64: </b><table border=1 cellpadding=1><tr><td>' . base64_encode($devrandom) . '</td></tr></table><p>');
print('<b>Hexidecimal: </b><table border=1 cellpadding=1><tr><td>' . bin2hex($devrandom) . '</td></tr></table><p>');
?>
</body>
</html>