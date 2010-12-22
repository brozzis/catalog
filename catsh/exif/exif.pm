#!/usr/bin/perl -w
# $Id: exif.pm,v 1.2 2004/04/06 22:41:51 stefano Exp $
#
package exif::exif;

use Image::Info qw(image_info dim);
use Digest::MD5;


BEGIN {
    use Exporter   ();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
    
    # set the version for version checking
    # if using RCS/CVS, this may be preferred
    $VERSION = sprintf "%d.%03d", q$Revision: 1.2 $ =~ /(\d+)/g;
    
    @ISA         = qw(Exporter);
    @EXPORT      = qw(&EXIF_SQL &print_all);
    %EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],
    
    # your exported package globals go here,
    # as well as any optionally exported functions
#    @EXPORT_OK   = qw($Var1 %Hashit &func3);
}
our @EXPORT_OK;
                                                                                                         



#
# tratte dalla PS20 ;-)
#
%all_keys = ( 
	      "DateTime",1,
	      "DateTimeOriginal",1,
	      "file_media_type",0,
	      "CompressedBitsPerPixel",0,
	      "ExposureBiasValue",2,
	      "ExposureTime",1,
	      "Model",0,
	      "FileSource",1,
	      "MeteringMode",1,
	      "ColorComponents",1,
	      "BitsPerSample",1,
	      "SamplesPerPixel",1,
	      "FocalPlaneXResolution",0,
	      "FocalPlaneYResolution",0,
	      "SubjectDistance",1,
	      "InteroperabilityVersion",0,
	      "InteroperabilityIndex",0, # cosa è ??
	      "resolution",1, # array
	      "Make",0,#canon
	      "Canon-Tag-0x0004",0,#
	      "Canon-Tag-0x0000",0,#
	      "Canon-Tag-0x0001",0,
	      "Canon-Tag-0x0009",0,#
	      "Canon-Tag-0x0002",0,#
	      "Canon-Tag-0x0006",0,
	      "Canon-Tag-0x0007",0,#firmware ver
	      "Canon-Tag-0x0003",0,
	      "Canon-Tag-0x0008",0,
	      "file_ext",0,
	      "ApertureValue",0,
	      "UserComment",0, # full caratteri strani
	      "SensingMethod",1,
	      "color_type",1,
	      "ColorSpace",0,
	      "RelatedImageLength",1,
	      "ColorComponentsDecoded",1,
	      "ComponentsConfiguration",0, #YCbCr
	      "FlashPixVersion",0,
	      "Flash",1,
	      "ShutterSpeedValue",0,
	      "ExifImageWidth",1,
	      "ExifImageLength",1,
	      "ExifVersion",0, #0220
	      "FocalPlaneResolutionUnit",0,#dpm
	      "MaxApertureValue",0,
	      "FNumber",2,
	      "Orientation",0,
	      "DateTimeDigitized",0, # == datetimeoriginal
	      "YCbCrPositioning",1,
	      "FocalLength",2,
	      "RelatedImageWidth",1,
	      "JPEG_Type",0, # baseline
	      "width",1, # non so cosa sia
	      "height",1, # non so cosa sia
	      "file_media_type",0, # image/jpg
	      "file_ext",0, # jpg
	      "color_type",0, # YCbCr
	      "resolution",0, # 1/1
	      "Compression",0, # JPEG
	      "ColorComponents",0,#array
	      "ColorComponentsDecoded",0,# array
	      "BitsPerSample",0,#array
	      "SamplesPerPixel",0,
	      "ISOSpeedRatings", 1,
	      "Canon-FlashBias", 1,
	      "Canon-ImageType", 1,
	      "Canon-MeteringMode", 1,
	      "ImageUniqueID", 1,
	      "FocalLengthIn35mmFilm", 1,
	      "Canon-EasyShootingMode", 1,
	      "Canon-ExposureMode", 1,
	      "Canon-ShortFocalLengthOfLensInFocalUnits", 1,
	      "Canon-LongFocalLengthOfLensInFocalUnits", 1,
	      
	);





#
#
#
sub print_all
{
    my $filename=$_[0];

    my @sql_stmts;

    my @info = image_info($filename);
    if (my $error = $info->{error}) {
	die "Can't parse image info: $error\n";
    }
    my $color = $info->{color_type};
    my($w, $h) = dim($info);

    my $giro=0;
    foreach $i (@info) {
	@k = keys %$i;
	@v = values %$i;
	
	next if ($giro==1) ;
	$giro++;
	
	
	my $key_num=0;
	foreach my $key_name (@k) {
	    if ($all_keys{$k[$key_num]}) # se non deve scrivere tutto, allora verifica la matrice
	    {

		# correzione al volo per mettere la data nel formato corretto
                # 2004:01:13 12:07:14
		if ($k[$key_num]=~ m/^DateTime/) {
		    $v[$key_num]=~m/(\d{4}):(\d{2}):(\d{2})\s(\d{2}:\d{2}:\d{2})/;
		    $v[$key_num]=$1."/".$2."/".$3." ".$4;
		    
		}
		if ($all_keys{$k[$key_num]}==2) {
		    $k[$key_num]=~s/-/_/g;
		    push @sql_stmts, "EXIF_".$k[$key_num]."='".$v[$key_num]." : ".eval($v[$key_num])."'\n";
		} else {
		    $k[$key_num]=~s/-/_/g;
		    push @sql_stmts, "EXIF_".$k[$key_num]."='".$v[$key_num]."'\n";
		}
	    }
	    $key_num++;
	}
	
    }

    my $ret_str="";
    
    if (@sql_stmts) {
	$ret_str= "UPDATE thumbs SET ";
	$ret_str.=join ", ", @sql_stmts;
	$ret_str.=" WHERE md5='".$md5."'\n";
    }
    return $ret_str;
}



#
#
#

sub dump_all
{

    my @info = image_info("$ARGV[0]");
    if (my $error = $info->{error}) {
	die "Can't parse image info: $error\n";
    }
    my $color = $info->{color_type};
    my($w, $h) = dim($info);

    foreach $i (@info) {
	@k = keys %$i;
	@v = values %$i;
	
#	next if ($giro==1) ;
#	$giro++;
	
	
	my $key_num=0;
	foreach my $key_name (@k) {
	    if ($opt_a) {
		#print $k[$key_num].": ".$v[$key_num]."\n";
		print $key_name.":".$key_num."] ".$k[$key_num].": ";
		
		if (ref($v[$key_num]) eq "ARRAY") {
		    foreach $key ( @{ $v[$key_num] } ) {
			if ( ref( $key ) eq 'ARRAY' ) {
#			    foreach $sub_key ( @{ $key } ) {
#			    print "\tsub_key->".$sub_key;
#			    }
			} elsif (ref( $key ) eq 'HASH') {
#			    while (($key,$val) = each %{ $key }) {
#			    print "\thash->".$key, $val;
#			    }
			} else {
			    #	print join(":", @{ $v[$key_num] } );
			} # if
		    } # foreach $key
		    print "\n";
		} elsif(ref($v[$key_num]) eq "SCALAR") { # se scalar
		    print "$key_name.scalar->".$v[$key_num];
		} elsif(ref($v[$key_num]) eq "HASH") { # se 
		    print "$key_name.hash->".$v[$key_num];
		} elsif(ref($v[$key_num]) eq "REF") { # se 
		    print "$key_name.ref->".$v[$key_num];
		} elsif(ref($v[$key_num]) eq "LVALUE") { # se 
		    print "$key_name.lvalue->".$v[$key_num];
		} else { # se altro...
		    print "$key_name.val ->".ref($v[$key_num])."[".$v[$key_num]."]";
		    # tentativo....
		    #print "what?? ->".ref(%{ $v }->{$key_name}).",".ref($v[$key_num])."[".$v[$key_num]."]";
		}
		
		print "\n";
	    }

	    $key_num++;


	}
    }

}


#
#
#
sub EXIF_SQL
{
    my $filename=$_[0];

    my @sql_stmts;

    my @info = image_info($filename);
    if (my $error = $info->{error}) {
	die "Can't parse image info: $error\n";
    }
    my $color = $info->{color_type};
    my($w, $h) = dim($info);

    open(FILE, $filename) or die "Can't open $filename: $!";
    binmode(FILE);
    my $md5 = Digest::MD5->new->addfile(*FILE)->hexdigest;


    my $giro=0;
    foreach $i (@info) {
	@k = keys %$i;
	@v = values %$i;
	
	next if ($giro==1) ;
	$giro++;
	
	
	my $key_num=0;
	foreach my $key_name (@k) {
	    if ($all_keys{$k[$key_num]}) # se non deve scrivere tutto, allora verifica la matrice
	    {

		# correzione al volo per mettere la data nel formato corretto
                # 2004:01:13 12:07:14
		if ($k[$key_num]=~ m/^DateTime/) {
		    $v[$key_num]=~m/(\d{4}):(\d{2}):(\d{2})\s(\d{2}:\d{2}:\d{2})/;
		    $v[$key_num]=$1."/".$2."/".$3." ".$4;
		    
		}

		if (($all_keys{$k[$key_num]})==2) {
		    $k[$key_num]=~s/-/_/g;
		    push @sql_stmts, "EXIF_".$k[$key_num]."='".eval($v[$key_num])."'\n";
		} else {
		    $k[$key_num]=~s/-/_/g;
		    push @sql_stmts, "EXIF_".$k[$key_num]."='".$v[$key_num]."'\n";
		}
#		push @sql_stmts, "EXIF_".$k[$key_num]."='".$v[$key_num]."'";
	    }
	    $key_num++;
	}
	
    }

    my $ret_str="";
    
    if (@sql_stmts) {
	$ret_str= "UPDATE thumbs SET ";
	$ret_str.=join ", ", @sql_stmts;
	$ret_str.=" WHERE md5='".$md5."'\n";
    }
    return $ret_str;
}




sub print_all_keys
{

    my $filename=$_[0];
    my @info = image_info($filename);
    if (my $error = $info->{error}) {
	die "Can't parse image info: $error\n";
    }
    my $color = $info->{color_type};
    my($w, $h) = dim($info);

    my $c=0;
    my @v;
#  foreach $key (keys %{@info }) {
    foreach $key (@info) {
	print "$c] $key:";
	@v=values %{ $key };
	print ref($v[$c]);
	print "\n";
	$c++;
    }
}   


 
# 
# while (($key, $value) = each %info) {
#     print $key, "\n";
# #    delete $hash{$key};   # This is safe
# }
# 


END {};

1;
