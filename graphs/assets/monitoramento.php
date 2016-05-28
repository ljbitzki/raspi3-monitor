<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Bitzpi - The Fucking Raspi Motherfucking Pi</title>
<style>
ol {
    display: block;
    list-style-type: none;
    margin-top: 2em;
    margin-bottom: 2em;
    margin-left: 0;
    margin-right: 0;
    padding-left: 0px;
    font-family: Arial, Helvetica, sans-serif;
}
a:link {
    text-decoration: none;
	color: black;
}
a:visited {
    text-decoration: none;
	color: black;
}
a:hover {
    text-decoration: underline;
	color: black;
}

a:active {
    text-decoration: underline;
	color: black;
}

body {
	background-image: url(../overlay.png);
	background-repeat: repeat;
}
</style>
</head>

<body bgcolor="#000000">
<table width="200" border="0" align="center">
  <tr align="center" valign="middle">
    <td height="225" colspan="5"><a href="http://192.168.0.13"><img src="../rasp.png" width="158" height="200" align="middle" /></a></td>
  </tr>
  <tr align="center" valign="top">
    <td height="83" colspan="5"><img src="../bitzpi.png" width="615" height="40" align="top" /></td>
  </tr>
  <tr>
    <td><a href="http://192.168.0.13/graphs/monitoramento.php"><img src="../graphs.png" width="115" height="115" /></a></td>
    <td><a href="http://192.168.0.13:8200"><img src="../dlna.png" width="150" height="150" /></a></td>
    <td><a href="http://192.168.0.13/owncloud"><img src="../ownc.png" width="200" height="99" /></a></td>
    <td><a href="http://192.168.0.13:9091"><img src="../transm.png" width="126" height="126" /></a></td>
  </tr>
</table>
</br>
<div id="featured-wrapper" style="background-color:#FFF" align="center">
<img src="../monit.png" width="300" height="40" />
<ol>
  <?php
foreach (glob("2016*.php") as $filename) {
printf('        <li><a href="%s">%s</a></li>' . "\n",
        $filename, $filename);
}
?>
</br>
</ol>
    </article>
</div>

</body>
</html>
