<html>
<head>
<link rel=stylesheet href="stefano.css" type="text/css">
<title></title>
<style>
body { background: url("/catimg/sfondo.png"); }
</style>

</head>
<body>

<a href="/catimg/stats.php">statistiche</a>
<a href="/catimg/show.php">mostra un certo supporto</a>
<a href="/catimg/search.php">ricerca per codice md5</a>

<?php

/**
$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");
$result = pg_query ($db, "SELECT * FROM images where mit=16");

print "<table width=95%>";
for($i=0; $i<pg_num_rows($result); $i++) {
  $row=pg_fetch_array($result, $i);
  $i%2?$class="e":$class="o";
  print "<tr class=$class>";
  print "<td>".$row['name']."</td>";
  //  print "<td>".$row['name']."</td>";
  // print "<td>".$row['name']."</td>";
  print "</tr>";
}
print "</table>";
***/


?>

</body>
</html>
