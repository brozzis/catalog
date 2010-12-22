<?php
$db = pg_connect ("host=localhost port=5432 dbname=image user=postgres") or die("1");


$sqlStr="select thumbnail, md5 from images";
$result = pg_exec ($db, $sqlStr) or die("2 [$sqlStr]");
#$row = pg_fetch_row($result,0);

pg_query ($db, "begin");

$i=0;
while ($row = pg_fetch_row($result, $i)) {
  $loid = pg_lo_open($db, $row[0], "r") or die ("err opening LO");
#  pg_lo_read_all ($loid);
  $fname="/home/ste/thumbs/".$row[1].".jpeg";
#  pg_lo_export($loid, $fname);
  pg_lo_export($fname, $loid);
  pg_lo_close ($loid);
  print "$row[0] $row[1]\n";
  $i++;
}
 
pg_query ($db, "commit"); //OR END
pg_close();

?>

