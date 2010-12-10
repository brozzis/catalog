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

/*
shower( "select count(*) from images", "numero di immagini");
shower( "select count(distinct md5) from images", "numero di immagini diverse");
shower( "select count(*) from media", "numero di supporti");
*/
shower("select * from stats", "statistiche");
// shower( "select '<a href=\"/catimg/show.php?id='||mit||'\">'||medium||'</a>', count(*) from images, media where media.id=mit group by medium, mit", "numero di supporti");

$sqlStr = "select '<img class=nob src=\"'||mt.name||'.png\"><a href=\"/catimg/show.php?id='||mit||'\"><font size=+2>'||medium||'</font></a>',".
" count(*), ".
" '<a href=\"/catimg/doppi.php?id='||mit||'\">singoli</a>', ".
// "|| ' ['|| (select count(*) from images i where not exists (select i1.id from images i1 where i.id<>i1.id and i1.md5=i.md5)) ||']',  ".
" media.data ".
"from images i_ext, media, mt where  mt=mt.id and media.id=mit group by medium, mit, mt.name, media.data";

$sqlStr = "select '<img class=nob src=\"'||mt.name||'.png\"><a href=\"/catimg/show.php?id='||media.id||'\"><font size=+2>'||medium||'</font></a>',".
" num.count, ".
//" '<a href=\"/catimg/doppi.php?id='||media.id||'\">singoli</a> ['||num.singoli||']', ".
" '<a href=\"/catimg/doppi.php?id='||media.id||'\">singoli</a> ', ".
// "|| ' ['|| (select count(*) from images i where not exists (select i1.id from images i1 where i.id<>i1.id and i1.md5=i.md5)) ||']',  ".
" media.note, media.data, ".
" case 
  when media.mt <> 1 then
    '<a href=\"delete.php?id='||media.id||'\">delete</a>'
  else
    '&nbsp;'
  end ".
"from media, mt, num_images num where num.id=media.id and mt=mt.id order by medium"; // group by medium, mit, mt.name, media.data";

shower( $sqlStr, "supporti" );


?>
</body>
</html>
