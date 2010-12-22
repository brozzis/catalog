<html>
<head>
<link rel=stylesheet href="stefano.css" type="text/css">
<title></title>
<style>
</style>
<!-- body { background: url("/img/bg_62.gif"); } -->

</head>
<body>

<?php

$id=$_GET['id'];
include_once("shower.php");

$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");

print "edit and see image properties of image #$id<p />";

$sqlStr="select * from images where id=$id";
shower($sqlStr, "dettagli della immagine", 1);

print "<p/>";
$sqlStr="select '<a href=\"search.php?md5='||md5||'\">ricerca questa immagine</a>' from images where id=$id";
shower($sqlStr, "ricerca immagine");

?>