#!/bin/sh
#
# $Id: thumbs.sh,v 1.1.1.1 2003/06/14 17:06:35 stefano Exp $
#

exit;


usage ()
{
	echo "$0 <img dir> <thumb dir>"
	echo "entrambe devono esistere"
	exit
}

[ "x$1" == "x" ] && usage 
[ "x$2" == "x" ] && usage 
[ -d $1 ] || usage 
[ -d $2 ] || usage

DEBUG=0
THUMBS=$2/mini
HTML=$2/html
[ -d $THUMBS ] || mkdir $THUMBS
[ -d $HTML ] || mkdir $HTML 

> $2/index_gr.lst
> $2/index.lst

EXT=TIF
EXT=JPG
EXT=jpg

for i in $1/*.$EXT
do
    [ $DEBUG ] && echo $i
    (( $COL = $COL + 1 ))
	BASE=`basename $i .$EXT | sed -e 's/[- ]/_/g'`
        # djpeg -scale 1/8 $i | cjpeg -outfile mini/th_$i ;
        #djpeg -scale 1/8 $i | cjpeg -grayscale -outfile mini/th_gr_$i ;
	[ "$i" -nt "$THUMBS/th_$BASE.jpg" ] && convert -scale 240x180  "$i" $THUMBS/th_$BASE.jpg
	[ "$i" -nt "$THUMBS/th_gr_$BASE.jpg" ] && convert -scale 240x180 -blur 3x10 "$i" $THUMBS/th_gr_$BASE.jpg
	# 

        echo "<td>"
        echo "<a href=\"html/$BASE.html\"
                onMouseOver=\"WM_imageSwap( 'x$BASE', 'mini/th_$BASE.jpg' );\"
                onMouseOut=\"WM_imageSwap( 'x$BASE', 'mini/th_gr_$BASE.jpg' );\">
<img height=100 name="x$BASE" border=0 src=\"mini/th_gr_$BASE.jpg\"></a>" >> $2/index_gr.lst
        echo "<a href=\"$BASE.JPG\"><img border=0 src=\"mini/th_$BASE.jpg\"></a>" >> $2/index.lst
        echo "</td>"

# Image::Info here
cat > $HTML/$BASE.html <<EOF
<html>
<head></head>
<body>
<center><img src="../../$i" width=640></center>
</body>
</html>

EOF

done

    # {{{ output HTML

#
# output HTML
#
TITLE="Hanseatic Hamburg"

cat > $2/index.html <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>$TITLE</title>

<link rel="stylesheet" href="thumbs.css">
  </head>
  <body>

    <h2>$TITLE</h2>



<script language="JavaScript">
<!--

function WM_imageSwap(daImage, daSrc){
  var objStr,obj;
  /*
    WM_imageSwap()
    Changes the source of an image.

    Source: Webmonkey Code Library
    (http://www.hotwired.com/webmonkey/javascript/code_library/)

    Author: Shvatz
    Author Email: shvatz@wired.com

    Usage: WM_imageSwap(originalImage, 'newSourceUrl');

    Requires: WM_preloadImages() (optional, but recommended)
    Thanks to Ken Sundermeyer (ksundermeyer@macromedia.com) for his help
    with variables in ie3 for the mac. 
    */

  // Check to make sure that images are supported in the DOM.
  if(document.images){
    // Check to see whether you are using a name, number, or object
    if (typeof(daImage) == 'string') {
      // This whole objStr nonesense is here solely to gain compatability
      // with ie3 for the mac.
      objStr = 'document.' + daImage;
      obj = eval(objStr);
      obj.src = daSrc;
    } else if ((typeof(daImage) == 'object') && daImage && daImage.src) {
      daImage.src = daSrc;
    }
  }
}


// -->

</script>

EOF


cat $2/index_gr.lst >> $2/index.html

cat >> $2/index.html <<EOF
    <hr>
    <address><a href="mailto:brozzis@libero.it"></a></address>
  </body>
</html>

EOF


    # }}}
