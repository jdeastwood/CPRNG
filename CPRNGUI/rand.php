<html>
<head>
<title>CPRNG Password Generator</title>
</head>
<body bgcolor='yellow'>
<center>
<h1>CPRNG Password Generator</h1>
<p>
<b>Entropy Available at Script Start:</b>
<?php
include 'base91.php';
print(file_get_contents('/proc/sys/kernel/random/entropy_avail'));
print ('<p><b>Your Passwords Are:</b><p>');
$devrandom = mcrypt_create_iv(256);
print('<b>Base 64:</b> ' . base64_encode($devrandom) . '<p>');
print('<b>Base 91:</b> ' . base91_encode($devrandom) . '<p>');
print('<b>Hexidecimal:</b> ' . bin2hex($devrandom) . '<p>');
?>
</body>
</html>