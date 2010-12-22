#!/usr/bin/perl -w
#
my $myId=q($Id: thumbs.pl,v 1.7 2003/10/17 22:17:13 stefano Exp $);
#

use Getopt::Std;
use Image::Info qw(image_info dim);

getopts('m');  

our($opt_m);

sub exif
{
my %all_keys = ( 
	      "DateTime",1,
	      "file_media_type",1,
	      "CompressedBitsPerPixel",1,
	      "ExposureBiasValue",1,
	      "ExposureTime",1,
	      "Model",1,
	      "FileSource",1,
	      "MeteringMode",1,
	      "ColorComponents",1,
	      "BitsPerSample",1,
	      "SamplesPerPixel",1,
	      "InteroperabilityIndex",0, # cosa è ??
	      "FocalPlaneYResolution",1,
	      "SubjectDistance",1,
	      "Canon-Tag-0x0009",0,#
	      "Canon-Tag-0x0002",0,#
	      "InteroperabilityVersion",1,
	      "resolution",1,
	      "Make",0,#canon
	      "DateTimeOriginal",1,
	      "Canon-Tag-0x0004",0,#
	      "Canon-Tag-0x0000",0,#
	      "width",1,
	      "file_ext",1,
	      "ApertureValue",1,
	      "Canon-Tag-0x0007",0,#firmware ver
	      "UserComment",0, # full caratteri strani
	      "ExifImageWidth",1,
	      "SensingMethod",1,
	      "Canon-Tag-0x0006",0,
	      "color_type",1,
	      "ColorSpace",1,
	      "Canon-Tag-0x0001",0,
	      "RelatedImageLength",1,
	      "ColorComponentsDecoded",1,
	      "ComponentsConfiguration",0, #YCbCr
	      "FocalPlaneXResolution",1,
	      "FlashPixVersion",1,
	      "Flash",1,
	      "Canon-Tag-0x0003",0,
	      "Canon-Tag-0x0008",0,
	      "ShutterSpeedValue",1,
	      "height",1,
	      "ExifImageLength",1,
	      "FocalPlaneResolutionUnit",0,#dpm
	      "MaxApertureValue",1,
	      "FNumber",1,
	      "Orientation",0,
	      "DateTimeDigitized",1,
	      "YCbCrPositioning",1,
	      "FocalLength",1,
	      "RelatedImageWidth",1,
	      "JPEG_Type",1,
	      "ExifVersion",1,
	      "width",0, # non so cosa sia
	      "file_media_type",1,
	      "file_ext",1,
	      "color_type",1,
	      "height",0, # non so cosa sia
	      "resolution",1,
	      "Compression",1,
	      "ColorComponents",0,#array
	      "ColorComponentsDecoded",0,# array
	      "BitsPerSample",0,#array
	      "SamplesPerPixel",1,
	      "JPEG_Type",1 );

my @chosen=();
my @info = image_info($_);
if (my $error = $info->{error}) {
     print "Can't parse image info: $error\n";
	return;
}
my $color = $info->{color_type};

my($w, $h) = dim($info);
 
#foreach (@info{ keys %info }) {
#    print $_;
#    print "\n";
#}

foreach $i (@info) {
    @k = keys %$i;
    #@v = values %$i;

    my $c=0;
    foreach(@k) {
	push @chosen, $i if ($all_keys{$k[$c]});
	$c++;
    }
}


# 
# while (($key, $value) = each %info) {
#     print $key, "\n";
# #    delete $hash{$key};   # This is safe
# }
# 

#
#
#
# foreach $i (@chosen) {
    # @k = keys %$i;
    # @v = values %$i;

    # my $c=0;
# print FH "<table>"; 
    # foreach(@k) {
	    # print FH "<tr class=exif><td>".$k[$c]."</td><td>".$v[$c]."</td></tr>\n";
	# $c++;
    # }
# print FH "</table>"; 
# }

	return @chosen;
}

sub dump_exif_as_table
{
my @exif_info=exif($_[0]);
print FH "<table>"; 
foreach my $i (@exif_info) {
    @k = keys %$i;
    @v = values %$i;

    my $c=0;
    foreach(@k) {
	    print FH "<tr class=exif><td>".$k[$c]."</td><td>".$v[$c]."</td></tr>\n";
	$c++;
    }
}
print FH "</table>"; 

}

sub usage
{
	print $myId;
	print "\n$0 [-m] <img dir> <thumb dir>\n";
	print " -m: non crea le immagini midi 800x800\n";
	print "entrambe devono esistere\n";
	exit;
}

$ARGV[0] or usage();
unless ($ARGV[1]) { $ARGV[1]=$ARGV[0]; }

[ -d $ARGV[0] ] || usage();
[ -d $ARGV[1] ] || usage();

my($THUMBS)=$ARGV[1]."/mini";
my($HTML)=$ARGV[1]."/html";
my($MIDI)=$ARGV[1]."/midi";

mkdir $THUMBS unless ( -d $THUMBS );
mkdir $MIDI unless ( -d $MIDI );
mkdir $HTML unless ( -d $HTML );
qx(cp *.gif $HTML);
qx(cp thumbs.css $ARGV[1]);

print "\nusing : $ARGV[0], $ARGV[1]\n\n";

my ($TITLE)=$ARGV[2];

#
# numero di colonne
#
my($COLS)=4; 

#
my($EXT)="TIF";
$EXT="JPG";
$EXT="jpg";
$EXT="JPG";

$opt_d=0;


open (FH_IND_GR, ">$ARGV[1]/index_gr.lst") or die("cannot open [".$ARGV[1]."/index_gr.lst]");
open (FH_IND, ">$ARGV[1]/index.lst") or die("cannot open [".$ARGV[1]."/index.lst]");

my($NUM_IMG)=0;
print FH_IND_GR  "\n<center><table width=95%>";

# my($SRCDIR)=qq($ARGV[0]/*.$EXT);

my($SRCDIR)=qq($ARGV[0]/*.jpg $ARGV[0]/*.JPG);
# con RE -> .jpg/i


#
# crea una lista temporanea con i nome dei files
#
my(@lista)=(< $SRCDIR >);
foreach(@lista) {
# for(< $SRCDIR >) {
  s/[- ]/_/g;
  ($_)=(m£.*/(.*)\.${EXT}£gi);
}

#
#
#
for (< $SRCDIR >)
  {
    my $xxx;

    $NUM_IMG++;

    print "---> $_\n" if $opt_d; # hint!!!

    ($xxx = $_)=~(s/[- ]/_/g);
    my($BASE)=($xxx =~ m£.*/(.*)\.${EXT}£gi);
    $img=$_;

    $img_th=$THUMBS."/th_".$BASE.".jpg";
    print "\n\n".$img."::".$img_th."\n" if $opt_d;
    if ( ! -s $img_th or (-M "$img"  < -M $img_th)) {
	print ".";
	`convert -scale 180x180  "$img" -resize 180x180 +profile '*' $THUMBS/th_$BASE.jpg`;
      }

	#
	# aggiungo immagine midi... [default]
	# con la 10D vengono troppo grosse...
	#
   if (!$opt_m) { 
    my $img_midi=$MIDI."/midi_".$BASE.".jpg";
    if ( ! -s $img_midi or (-M "$img"  < -M $img_midi)) {
	print "o";
	`convert -scale 800x800  "$img" -resize 800x800 $MIDI/midi_$BASE.jpg`;
      }
    }

    $img_th_gr="$THUMBS/th_gr_$BASE.jpg";
    if ( ! -s $img_th_gr or ( -M "$img" < -M $img_th_gr )) {
      print "°";
      # `convert -scale 180x180 -blur 3x10 "$img" -resize 180x180 +profile '*' $THUMBS/th_gr_$BASE.jpg`;
      `convert -scale 180x180 -colorize 12 "$img" -resize 180x180 +profile '*' $THUMBS/th_gr_$BASE.jpg`;
    }


    if ($NUM_IMG%$COLS==1) {
      print FH_IND_GR "\n<tr>";
    }
    print FH_IND_GR "\n\t<td align=center>";
    print FH_IND_GR "<a href=\"html/$BASE.html\"".
      "onMouseOver=\"WM_imageSwap( 'x$BASE', 'mini/th_$BASE.jpg' );\"".
	"onMouseOut=\"WM_imageSwap( 'x$BASE', 'mini/th_gr_$BASE.jpg' );\">".
	  "<img name=\"x$BASE\" border=0 src=\"mini/th_gr_$BASE.jpg\"></a>";
    print FH_IND "<a href=\"../$BASE.JPG\"><img border=0 src=\"mini/th_$BASE.jpg\"></a>";
    print FH_IND_GR "</td>";
    if ($NUM_IMG%$COLS==0) {
      print FH_IND_GR "\n</tr>";
    }
      

#
# pagina HTML per la singola foto
#

# Image::Info here


    open (FH,">$HTML/$BASE.html") or die("cannot open [$HTML/$BASE.html]");

    $lista = @lista;
    my($NEXT)=$lista[$NUM_IMG % $lista];
    my($PREV)=$lista[$NUM_IMG-2 % $lista];

    ($ext)=m/(jpg|jpeg|gif|tif|tiff|bmp)/i;
    print FH qq(

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>);
    print FH $BASE;

    print FH q(</title>

<link rel="stylesheet" href="../thumbs.css">
  </head>
  <body>

    <div class=title>);
    #print FH "$TITLE";
    print FH "$BASE";

   print FH q(</div> <center>);

	print FH qq(
<table width=800>
 <tr>
  <td align=left valign=top><a href="$PREV\.html"><img src="previous.gif" border=0 alt=prev></a></td>
  <td align=center><a href="../index.html">);

	if (!$opt_m) {
		print FH qq(<img src="../midi/midi_$BASE\.jpg" border=0>);
	} else {
		print FH qq(<img src="../$BASE\.$ext" border=0>);
	}

	print FH qq(</a></td>
  <td align=right valign=top><a href="$NEXT\.html"><img src="next.gif" border=0 alt=next></a></td>
 </tr>
 <tr>
	<td colspan=3 align=center><a href="../$BASE\.$ext">full</a></td>
 </tr>
</table>
</center>);

#
# commentato
#
# dump_exif_as_table("../".$BASE.".".$ext);

print FH qq(
</body>
</html>);
close(FH);

} # for $img


print FH_IND_GR  "</table></center>";
close(FH_IND_GR);
close(FH_IND);


#
# output HTML
#

open (FH,">$ARGV[1]/index.html") or die("cannot open [$ARGV[1]/index.html]");
print FH qq(
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>);

#print FH qq($TITLE);

print FH qq(</title>

<link rel="stylesheet" href="thumbs.css">
  </head>
  <body>

    <h2>);

# print FH $TITLE;

print FH qq(</h2>);

print FH q(

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

</script>);
close(FH);

`cat $ARGV[1]/index_gr.lst >> $ARGV[1]/index.html`;

open (FH, ">>$ARGV[1]/index.html") or die();
print FH q(    <hr>
    <address><a href="mailto:brozzis@libero.it"></a></address>
  </body>
</html>
);
close(FH);

print "\nDone!\n";


