<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>template</title>
<style type="text/css">
body { background: #a9a9a9;}

</style>
  </head>

  <body>

<center>
<?php


function readImgDir( $img ) 
{

$exif_fields = array(
"FileName" =>1,
"FileDateTime" =>0,
"FileSize" =>1, 
"CameraMake" =>0, 
"CameraModel" =>1,
"DateTime" =>1, 
"Height" =>1, 
"Width" =>1, 
"IsColor" =>0, 
"FlashUsed" =>1, 
"FocalLength" =>0, 
"35mmFocalLength" =>1, 
"RawFocalLength" =>0, 
"ExposureTime" =>1, 
"RawExposureTime" =>0, 
"ApertureFNumber" =>1, 
"RawApertureFNumber" =>0, 
"FocusDistance" =>1, 
"RawFocusDistance" =>0, 
"CCDWidth" =>0, 
"Orientation" =>0, 
"ExifVersion" =>0, 
"ThumbnailSize" =>0, 
"Thumbnail"=>0
);


 $exif = read_exif_data ($img);
 while(list($k,$v)=each($exif)) {
   /**
   if ($k=='Thumbnail')  {
     $fp=fopen("thumb.jpg","wb");
     fwrite($fp, $v);
     fclose($fp);
   } else 
     {
   **/

/* 
 * permette di selezionare i campi
 */

/*
   if ($exif_fields[ $k ]==0) {
     continue;
   }
*/

   if ($k=="FileDateTime") 
     echo "<font size=-2><b>$k</b>: ".strftime("%d/%m/%Y %H:%M",$v)."</font><br>\n";
   else
     echo "<font size=-2><b>$k</b>: $v</font><br>\n";
   //     }
 }
 // echo "<img src='thumb.jpg'>";
 
 
 $size = GetImageSize ( $img, &$info);
 if (isset ($info["APP13"])) {
   $iptc = iptcparse ($info["APP13"]);
   var_dump ($iptc);
 }
}




if (empty($orig_dir)) { $orig_dir="/home/stefano/exif/"; }

print "<table>";

$num_img=0;
$k=0;
$imgXpage=6;

if (empty($pageNum)&&(!is_dir("$orig_dir/mini/")||$full)) {
  $pageNum=0;
}

if ($dir = @opendir($orig_dir)) {
  while (($file = readdir($dir)) !== false) {
    if ($file=='.' or $file=='..' or $file=='.xvpics') continue;
    if (!eregi("jpg", $file)) continue;

    if (!is_file($orig_dir."/".$file)) { 
      print "<a href=\"".$PHP_SELF."?orig_dir=".$orig_dir."/".$file."/\">$file</a> | ";
      continue;    
    }
    $num_img++;	

    /*
     * euristica: 
     * se non è indicato il pagenum, e esistono i thumbnailks in mini/
     * scrive
     */
    if (!isset($pageNum)||$full) {
	if (file_exists("$orig_dir/mini/$file")) {
	  $np=(int)($num_img/$imgXpage);
	  print "<a href=\"$PHP_SELF?orig_dir=$orig_dir&pageNum=$np\">";
	  print "<img width=100 border=0 src=\"$orig_dir/mini/$file\">";
	  print "</a>";
	} elseif ($full) {
	  print "<a href=\"$PHP_SELF?orig_dir=$orig_dir&pageNum=$np\">";
	  print "<img width=100 border=0 src=\"file://$orig_dir$file\" alt=\"$orig_dir$file\">";
	  print "</a>";
	}
    }	
    else {
      if ($num_img < $pageNum*$imgXpage ) continue;
      if ($k<$imgXpage) {
	$col=$k++%2?"#969696":"#696969";
	echo "<tr bgcolor=".$col.">";
	print "<td>";
	print "<a href=\"file://$orig_dir$file\">";
	if (file_exists($orig_dir."/mini/".$file)) {
	  print "<img width=200 border=0 src=\"$orig_dir/mini/$file\">";
	} else {
	  print "<img width=200 border=0 src=\"file://$orig_dir/$file\">";
	}
	print "</a>";
	print "</td>";
	print "<td>";
	if (preg_match("/jpg/i",$file)) {
	  readImgDir( $orig_dir.$file );
	}
	print "</td>";
	print "</tr>\n";
      }
    }
  }  
  closedir($dir);
}


print "</table>";
print "ci sono $num_img immagini totali<br>";

$newPageNum=0;

if ($pageNum>0) {
  $np=$pageNum-1;	
  print "<a href=\"$PHP_SELF?orig_dir=$orig_dir&pageNum=$np\"><<</a> ";
}
for ($k=0; $k<$num_img; $k+=$imgXpage) {
  if ($pageNum==$newPageNum) {
   print "<b>$newPageNum</b> ";	
  } 
  else
   print "<a href=\"$PHP_SELF?orig_dir=$orig_dir&pageNum=$newPageNum\">$newPageNum</a> ";	

  $newPageNum++;
}


if ($pageNum>($num_img%$imgXpage)-1) {
  $np=$pageNum+1;
  print "<a href=\"$PHP_SELF?orig_dir=$orig_dir&pageNum=$np\">>></a> ";
}

?>
</center>

  </body>
</html>
