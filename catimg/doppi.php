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

include_once("shower.php");

$db = pg_connect ("host=localhost port=5432 dbname=image user=stefano");


// -- questi sono i doppi
/*
$sqlStr="select i.mit, i.name from images i, images i1 where i.mit=$id and i.md5=i1.md5 and i.id<>i1.id";

shower($sqlStr, "doppi");
*/

// -- doppi: indica dove e quali
/*
$sqlStr="select '<img src=\"'||mt.name||'.png\">', i1.name from images i, images i1, media m, mt where mt=mt.id and i1.mit=m.id and i.mit=$id and i.md5=i1.md5 and i.id<>i1.id";

// select i.name from images i, images i1 where i.mit=16 and i1.mit!=16 and i.md5=i1.md5 and i.id<>i1.id;
shower($sqlStr, "doppi, dove e quali");
*/


// lentissimo
// $sqlStr="select i.name from images i where i.mit=$id and md5 not in (select md5 from images i1 where i.id<>i1.id)";


/*
 * 28/sep/2003
 * non conviene usare questo visto che la tabella è sempre aggiornata ??
 */ 
// rapidissimo, ma si appoggia su tab. quantity
// $sqlStr="SELECT i.name from images i where mit=$id and exists (select q.md5 from quantity q where count=1 and q.md5=i.md5)";


/*
$sqlStr="select i.name from images i ".
" where i.mit=$id and not exists (select i1.id from images i1 where i.id<>i1.id and i1.md5=i.md5)";
shower($sqlStr, "singoli I");
*/

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
        end ".
" FROM images i, quantity q ".
" where i.mit=$id and i.md5=q.md5 and not exists (select i1.id from images i1 where i.id<>i1.id and i1.md5=i.md5)";
shower($sqlStr, "singoli II");



?>

</body>
</html>
