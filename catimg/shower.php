
<?php

function shower( $sqlstr, $desc, $title=0, $debug=0 ) 
{
  GLOBAL $db;
	
  if ($debug) { print "<xmp>$sqlstr</xmp>"; }
  $result = pg_query ($db, $sqlstr) or die("<xmp>look at this [$sqlstr]</xmp>");
  
  print "$desc";
  print "<table width=95%>";
  if ($title) {
    print "<tr>";
    for ($i=0; $i<pg_num_fields($result); $i++) {
      echo "<th>" . pg_fieldname($result, $i) . "</th>\n";
    }
    print "</tr>";
  }

  for($i=0; $i<pg_num_rows($result); $i++) {
    $row=pg_fetch_array($result, $i);
    $i%2?$class="e":$class="o";
    print "<tr class=$class>";
    for ($j=0; $j<pg_num_fields($result); $j++) {
      print "<td>".$row[$j]."</td>";
    }
    print "</tr>";
  }
  print "</table>";
  
}


?>
