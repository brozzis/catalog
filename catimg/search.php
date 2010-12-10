<html>
<head>
<link rel=stylesheet href="stefano.css" type="text/css">
<title></title>
<style>
</style>
<!-- body { background: url("/img/bg_62.gif"); } -->

</head>
<body>

<form>
MD5
<input type=text name=md5>
<br />
Descrizione
<input type=text name=descrizione>
<br />
Nome File
<input type=text name=nome>
<input type=submit>
</form>
<?php


$md5=$_GET['md5'];
$descrizione=$_GET['descrizione'];
$nome=$_GET['nome'];

if (!$md5&&!$descrizione&&!$nome) exit;


if ($md5) {
 $cond="i.md5='$md5'";
} elseif ($descrizione) {
 $cond="i.d1 ~* '$descrizione'";
} elseif ($nome) {
 $cond="i.name ~* '$nome'";
}

include_once("shower.php");

$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");

$sqlStr="SELECT '<a href=\"show.php?id='||mit||'\">'||medium||'</a>', name, 
	case
	  when thumbnail is not null then
		'<img src=\"/catimg/image.php?id='||i.id||'\">'
	end,
	case 
	  when count=1 then '<font color=red>'||count||'</font>' 
	  when count=2 then '<font color=orange>'||count||'</font>' 
	  when count=3 then '<font color=yellow>'||count||'</font>' 
	  else '<font color=green>'||count||'</font>' 
        end,
   '<img class=nob src=\"'||mt.name||'.png\">'
 FROM images i, quantity q, media where ".$cond." and i.md5=q.md5 and mit=media.id and mt.id=mt ";

// print $sqlStr;
// $sqlStr="select * from images where md5='$md5'";
shower($sqlStr, "risultato");


?>
</body>
</html>
