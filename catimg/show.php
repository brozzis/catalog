<html>
<head>
<link rel=stylesheet href="stefano.css" type="text/css">
<title></title>
<style>
</style>
</head>
<body>

<?php

/*
 * 3 modalità di scorrimento:
 * 1. distinct delle dir presenti
 * 2. full con numXPage immagini per pagina
 * 3. schermata con le imamgini
 */
$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");
include_once("shower.php");

$id=$_GET['id'];
$sqlStr="select medium from media where id=$id";
$result = pg_query ($db, $sqlStr) or die("<xmp>look at this [$sqlStr]</xmp>");

if (pg_num_rows($result)<1) die ("cd non trovato");

$row=pg_fetch_array($result, 0);
$cd_name=$row[0];

$page=$_GET['page'];
$dir=$_GET['dir'];
$mode=$_GET['mode'];

if (empty($page) && empty($dir)) { // 1a modalita, partenza

  $page = 0;
  showSubdirs($id);

} elseif ($mode=='contact') { // 3a modalita

  contactSheet($id, $dir);

} elseif ($mode=='detail') { // 2a modalita

  showDetails($id, $page, $dir);

}



function contactSheet($id, $dir)
{
  GLOBAL $db;
  GLOBAL $cd_name;

  print "<a href=\"stats.php?id=$id\">cdrom <b>$cd_name</b> [#$id]</a>";
  print " : ";
  print "<a href=\"?id=$id\">distinct dir</a>";
  print " : ";
  print "contact sheet for $dir";
  print "<p />"; 

  print "<a href=\"?mode=detail&id=$id&dir=$dir&page=0\">show detail</a><p />";

  $sqlStr="select 
          case
	  when thumbnail is not null then
		'<a href=\"/catimg/edit.php?id='||id||'\"><img src=\"/catimg/image.php?id='||id||'\"></a>' 
          end
          from images where mit = $id and name like '$dir%' order by id";
//	shower($sqlStr, "immagini presenti in $dir");

  $result = pg_query ($db, $sqlStr) or die("<xmp>look at this [$sqlStr]</xmp>");
  
  for($i=0; $i<pg_num_rows($result); $i++) {
    $row=pg_fetch_array($result, $i);
//    for ($j=0; $j<pg_num_fields($result); $j++) {
      print $row[0];
//    }
  }

}


function showSubdirs($id)
{
  GLOBAL $cd_name;


  print "<a href=\"stats.php?id=$id\">cdrom <b>$cd_name</b> [#$id]</a>";
  print " : ";
  print "distinct";
  print "<p />";

	$sqlStr="select distinct '<a href=\"?id=$id&mode=contact&dir='||substring( name from '(/%)+/%' for '#')||'\">'|| 
substring( name from '(/%)+/%' for '#')||'</a>' from images where mit=$id";
// print "<xmp>$sqlStr</xmp>";
	shower($sqlStr, "sottodirectory presenti");

}


/*
 * 
 */
function showDetails($id, $page, $dir="", $numXpage=15) 
{
  GLOBAL $db;
  GLOBAL $cd_name;


  print "<a href=\"stats.php?id=$id\">cdrom <b>$cd_name</b> [#$id]</a>";
  print " : ";
  print "<a href=\"?id=$id\">distinct dir [$dir]</a>";
  print " : ";
  print "<a href=\"?id=$id&dir=$dir&mode=contact\">contact sheet</a>";
  print " : ";
  print "detail";
  print "<p />"; 

  // variabili...

  $offset=$numXpage*$page;



  $sqlStr="SELECT name, count FROM images i, quantity q where mit=$id and i.md5=q.md5";
  $sqlStr="SELECT name, 
	case
	  when thumbnail is not null then
		'<a href=\"/catimg/edit.php?id='||id||'\"><img src=\"/catimg/image.php?id='||id||'\"></a>' 
	end,
	case 
	  when count=1 then '<font color=red>'||count||'</font>' 
	  when count=2 then '<a href=\"search.php?md5='||i.md5||'\"><font color=orange>'||count||'</font></a>' 
	  when count=3 then '<font color=yellow>'||count||'</font>' 
	  else '<font color=green>'||count||'</font>' 
        end
 FROM images i, quantity q 
 where mit=$id and i.md5=q.md5 
 and name like '$dir%'
 order by name, mit
 limit $numXpage offset $offset";


  shower($sqlStr, "file presenti...");
  // print "<xmp>$sqlStr</xmp>";

  $sqlStr="select count(*) from images where mit=$id and name like '$dir%'";
  //print "<xmp>$sqlStr</xmp>";

  $result = pg_query ($db, $sqlStr);
  $row=pg_fetch_array($result, $i);

  print "\n<p />";
  print "<a href=\"\"><img class=nob src=\"home.gif\"></a>";
  print "<a href=\"\"><img class=nob src=\"previous.gif\"></a>";
  for ($i=0; $i<(int)$row[0]/$numXpage; $i++) {
    print "<a href=\"/catimg/show.php?id=".$id."&mode=detail&dir=".$dir."&page=".$i."\">".($i+1)."</a> ";
  }
  print "<a href=\"\"><img class=nob src=\"next.gif\"></a>";
  print "<p />";

}
?>

</body>
</html>
