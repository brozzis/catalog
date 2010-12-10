eeee
<?php
	set_time_limit(300);
$db = pg_connect ("host=nexus port=5432 dbname=image user=postgres") or die("1");

for ($x=0; $x<=9; $x++)  {

	print $x;
$sqlStr="select thumbnail,md5 from thumbs where exist=true and md5 like '".$x."%'";
$result = pg_exec ($db, $sqlStr) or die("2 [$sqlStr]");

$i=0;
while ($row = pg_fetch_row($result, $i)) {
pg_exec ($db, "begin");
$loid = pg_lo_open($db, $row[0], "r");
$somecontent = pg_lo_read ($loid, 4096);

   $filename="/home/ste/thumbs/".$row[1].".jpg";
   $handle = fopen($filename, 'wb') 
   	or die( "[$i] Cannot open file ($filename)");
   fwrite($handle, $somecontent) 
   	or print("[$i] Cannot write to file ($filename)") ;
   fclose($handle);

pg_lo_close ($loid);
pg_query ($db, "commit"); //OR END
$i++;
}

}

/****
print $row[0];
pg_query ($db, "begin");
# pg_lo_export ( int oid, string pathname [, resource connection])
#$loid = pg_lo_open($db,$row[0], "r");
#if (undef( or die ("err opening LO");
pg_lo_export ( 182018, 'c:/xx.jpg', $db );
print pg_last_error($db);
#pg_lo_read_all ($loid);
#pg_lo_close ($loid);

pg_query ($db, "commit"); //OR END
#pg_close($db);
***/

pg_close($db);

print "finito";

?>

ffff