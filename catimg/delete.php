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


if (!$id) {
  die ("$id non definito. qualcosa di sbagliato");
}

// include_once("shower.php");

$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");


print "<a href=\"stats.php\">torna indietro</a><p />";


if (!$delete) {
  $sqlStr="select medium from media where id=$id";
  $result = pg_query ($db, $sqlStr) or die("<xmp>look at this [$sqlStr]</xmp>");
  $row = pg_fetch_array( $result );

  print "vuoi davvero cancellare il medium ".$row[0]." [ $id ]??";
  print "<form><input type=hidden name=id value=$id><input name=delete value=delete type=submit></form>";

} else {

  $sqlStr="delete from media where id=$id";
  $result = pg_query ($db, $sqlStr) or die("<xmp>look at this [$sqlStr]</xmp>");
  $row = pg_fetch_array( $result );

  print "cancellato [ $id ] !!<p />";
  
}

print "<a href=\"stats.php\">torna indietro</a><p />";

?>
</body>
</html>
