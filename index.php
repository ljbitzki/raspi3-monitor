<!DOCTYPE html>
<html lang="en-US">
  <head>
    <meta charset="utf-8"/>
        <link rel="shortcut icon" href="assets/favicon.ico" />
        <link rel="stylesheet" type="text/css" href="assets/style.css">
    <title>Monitoramento RaspiberryPi 3</title>
  </head>
  <body>
    <article>
      <h1>Monitoramento RaspberryPi 3</h1>
<ol>
<?php
foreach (glob("2016*.php") as $filename) {
printf('        <li><a href="%s">%s</a></li>' . "\n",
        $filename, $filename);
}
?>
      </ol>
    </article>
  </body>
</html>
