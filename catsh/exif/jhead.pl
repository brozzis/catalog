#!/usr/bin/perl -w

# File name    : 163_6316.jpg
# File size    : 3744606 bytes
# File date    : 2004:04:02 14:38:15
# Camera make  : Canon
# Camera model : Canon EOS 10D
# Date/Time    : 2004:01:13 12:07:14
# Resolution   : 3076 x 2052
# Flash used   : No
# Focal length : 35.0mm
# Exposure time: 0.0080 s  (1/125)
# Aperture     : f/8.0
# ISO equiv.   : 100
# Exposure bias:-0.50
# Metering Mode: matrix
# Exposure     : program (auto)
# Jpeg process : Baseline
 

# exif_filename              | text                        |
## exif_filedatetime          | integer                     |
# exif_filesize              | integer                     |
# exif_height                | integer                     |
# exif_width                 | integer                     |
# exif_aperturefnumber       | text                        |
# exif_make                  | text                        |
# exif_model                 | text                        |
# exif_exposureprogram       | smallint                    |
# exif_isospeedratings       | integer                     |
# exif_meteringmode          | smallint                    |
# exif_flash                 | smallint                    |
## exif_whitebalance          | smallint                    |
## exif_lightsource           | smallint                    |
# exif_datetimeoriginal      | timestamp without time zone |
# exif_datetimedigitized     | timestamp without time zone |
# exif_fnumber               | text                        |
# exif_exposuretime          | text                        |
# exif_focallength           | text                        |
## exif_focallengthin35mmfilm | integer                     |
# exif_exposurebiasvalue     | text                        |
## exif_imageuniqueid         | text                        |

my @exif_tags=(
	    q"File name    : (\S+)",
	    q"File size    : (\d+) bytes",
	    q"File date    : 2004:04:02 14:38:15",
	    q"Camera make  : (\s+)",
	    q"Camera model : (.+)",
	    q"Date/Time    : 2004:01:13 12:07:14",
	    q"Resolution   : (\d+) x (\d+)",
	    q"Flash used   : (\S+)",
	    q"Focal length : (\d+\.\d+)mm",
	    q"Exposure time: \S+ s  \((\S+)\)",
	    q"Aperture     : (.+)",
	    q"ISO equiv.   : (\d+)",
	    q"Exposure bias:(.+)",
	    q"Metering Mode: (\S+)",
	    q"Exposure     : (.+)",
	    q"Jpeg process : (.+)");



open (FH, "jhead.memo") or die;

my $i=0;
while(<FH>) {
    $x=$exif_tags[$i];
    #print $x;
    print $1 if ($exif_tags[$i]=~m/^(\S+):/);
    print $1."\n" if (m/${x}/) ;
	$i++;
#ok
#    print $1 if (m/Resolution   : (\d+) x (\d+)/);
}

close(FH);

