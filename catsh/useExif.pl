#!/usr/bin/perl -w


use Getopt::Std;

use exif::exif;

getopts('shak');    

our($opt_s, $opt_a, $opt_h, $opt_k);




if (! -f $ARGV[0]) {
    die ("non riesco ad aprire il file $ARGV[0]");
} 
$filename=$ARGV[0];


#
#
#
if ($opt_s) {
    #Focal len: 28 mm, Shutter: 1/250 sec, Aperture: F7.1, Meter: 13.9 EV, EF 28-70 mm L, ISO 100, +0.3 EV, Sharp +2
#    print %{ @info }->{FocalLength}, "";
    exit;
}



## my @info = image_info("$ARGV[0]");
## if (my $error = $info->{error}) {
##     die "Can't parse image info: $error\n";
## }
## my $color = $info->{color_type};
## my($w, $h) = dim($info);

#
# scrive le chiavi presenti nell exif ed esce
#
if ($opt_k) {
    print_all_keys();
    exit;
}


#
# scrive tutte le chiavi e tutti i valori
#
if ($opt_a) {
    print print_all($filename);
    exit;
}


EXIF_SQL($filename);
