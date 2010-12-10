<?php
#header("Content-type: image/jpeg");
#header("Cache-Control: no-store, no-cache, must-revalidate");
#header("Cache-Control: post-check=0, pre-check=0", false);

$db = pg_connect ("host=localhost port=5432 dbname=image user=postgres") or die("1");
$id=$_GET['id'];
$id=48376;
$sqlStr="select thumbnail from images where id=$id";
$result = pg_exec ($db, $sqlStr) or die("2 [$sqlStr]");

$row = pg_fetch_row($result,0);

pg_query ($db, "begin");
# pg_lo_export ( int oid, string pathname [, resource connection])
$loid = pg_lo_open($db,$row[0], "r") or die ("err opening LO");
pg_lo_export ( $loid, "/tmp/xx.jpg", $db );
print pg_last_error($db);
#pg_lo_read_all ($loid);
pg_lo_close ($loid);
pg_query ($db, "commit"); //OR END
pg_close($db);
?>

