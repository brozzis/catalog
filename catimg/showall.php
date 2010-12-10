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

$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");

$sqlStr="SELECT name, 
	case
	  when thumbnail is not null then
		'<img src=\"/catimg/image.php?id='||id||'\">'
	end,
	case 
	  when count=1 then '<font color=red>'||count||'</font>' 
	  when count=2 then '<font color=orange>'||count||'</font>' 
	  when count=3 then '<font color=yellow>'||count||'</font>' 
	  else '<font color=green>'||count||'</font>' 
        end
 FROM images i, quantity q 
 where mit=$id and i.md5=q.md5 
 order by name, mit";

$result = pg_query ($db, $sqlStr) or die("<xmp>look at this [$sqlStr]</xmp>");
  
print "$desc";
print "<table width=95%>";
print "<tr class=$class>";
for($i=0; $i<pg_num_rows($result)+3; $i++) {
  $row=pg_fetch_array($result, $i); 
  print "<td>".$row[1]."</td>";
  $row=pg_fetch_array($result, $i+1); 
  print "<td>".$row[1]."</td>";
  $row=pg_fetch_array($result, $i+2); 
  print "<td>".$row[1]."</td>";
}
print "</tr>";
print "</table>";

print "<p />";

?>

</body>
</html>
