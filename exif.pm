package exif;

use strict;
use warnings;
use Image::ExifTool qw(:Public);
        
use Data::Dump qw(dump);
 
use DBI;




    BEGIN {
        use Exporter   ();
        our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
        # set the version for version checking
        $VERSION     = 1.00;
        # if using RCS/CVS, this may be preferred
        $VERSION = sprintf "%d.%03d", q$Revision: 1.1 $ =~ /(\d+)/g;
        @ISA         = qw(Exporter);
        @EXPORT      = qw(&readImage);
        %EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],
        # your exported package globals go here,
        # as well as any optionally exported functions
        @EXPORT_OK   = qw();
    }
    our @EXPORT_OK;

 
 	
 	
our $dbh = DBI->connect('DBI:mysql:catalog:localhost',
                       'ste',  # user name
                       'ste',  # password
                       { RaiseError => 1 });
 
 

 
	my %unk = (
		  "AFImageHeight"               => 3328,
		  "AFImageWidth"                => 4992,
		  "ExifImageHeight"             => 3328,
		  "ExifImageWidth"              => 4992,
	)	;

#
# img
#
	my %img00 = (
		  "ShutterCount"                => 81821,
		  "AutoISO"                     => 100,
		  "CreateDate"                  => "2010:07:04 19:03:07",
		  "DateTimeOriginal"            => "2010:07:04 19:03:07",
		  "AEBBracketValue"             => 0,
		  "Aperture"                    => "4.0",
		  "AutoExposureBracketing"      => "Off",
		  "BulbDuration"                => 0,
		  "CanonFlashMode"              => "Off",
		  "CreateDate"                  => "2010:07:04 19:03:07",
		  "DateTimeOriginal"            => "2010:07:04 19:03:07",
		  "ExposureCompensation"        => "+1/3",
		  "ExposureTime"                => "1/25",
		  "FillFlashAutoReduction"      => "Disable",
		  "Flash"                       => "Off, Did not fire",
		  "FlashActivity"               => 0,
		  "FlashBits"                   => "(none)",
		  "FlashExposureComp"           => 0,
		#  "FlashGuideNumber"            => 0,
		  "FocalLength"                 => "37.0 mm",
		  "ISO"                         => 640,
		  "LightValue"                  => "6.0",
		  "MirrorLockup"                => "Disable",
		  "ModifyDate"                  => "2010:07:04 19:03:07",
		  "ShutterCount"                => 81821,
		  "ShutterCurtainSync"          => "2nd-curtain sync",
  		"ShutterSpeed"                => "1/25",
	  	"ShutterSpeedValue"           => "1/25",
	
	);


	our %img = (
		  "DateTimeOriginal"            => "2010:07:04 19:03:07",
		  "AEBBracketValue"             => 0,
		  "Aperture"                    => "4.0",
		  "AutoExposureBracketing"      => "Off",
		  "BulbDuration"                => 0,
		  "CanonFlashMode"              => "Off",
		  "ExposureCompensation"        => "+1/3",
		  "ExposureTime"                => "1/25",
		  "FillFlashAutoReduction"      => "Disable",
		  "Flash"                       => "Off, Did not fire",
		  "FlashActivity"               => 0,
		  "FlashBits"                   => "(none)",
		  "FlashExposureComp"           => 0,
		#  "FlashGuideNumber"            => 0,
		  "FocalLength"                 => "37.0 mm",
		  "ISO"                         => 640,
		  "LightValue"                  => "6.0",
		  "MirrorLockup"                => "Disable",
		  "ShutterCount"                => 81821,
		  "ShutterCurtainSync"          => "2nd-curtain sync",
#  		"ShutterSpeed"                => "1/25",
#	  	"ShutterSpeedValue"           => "1/25",
	
	);


	my %long = (
	  "AEBBracketValue"             => 0,
	  "AFImageHeight"               => 3328,
	  "AFImageWidth"                => 4992,
	  "Aperture"                    => "4.0",
	  "ApertureValue"               => "4.0",
	  "AutoExposureBracketing"      => "Off",
	  "AutoISO"                     => 100,
	  "BaseISO"                     => 617,
	  "BulbDuration"                => 0,
	  "CanonExposureMode"           => "Aperture-priority AE",
	  "CanonFlashMode"              => "Off",
	  "CanonImageHeight"            => 3328,
	  "CanonImageWidth"             => 4992,
	  "CreateDate"                  => "2010:07:04 19:03:07",
	  "DateTimeOriginal"            => "2010:07:04 19:03:07",
	  "ExifImageHeight"             => 3328,
	  "ExifImageWidth"              => 4992,
	  "ExposureCompensation"        => "+1/3",
	  "ExposureTime"                => "1/25",
	  "ExposureTime (1)"            => "1/27",
	  "ExposureTime (2)"            => "1/25",
	  "FileModifyDate"              => "2012:02:16 08:19:07+01:00",
	  "FillFlashAutoReduction"      => "Disable",
	  "FinderDisplayDuringExposure" => "Off",
	  "Flash"                       => "Off, Did not fire",
	  "FlashActivity"               => 0,
	  "FlashBits"                   => "(none)",
	  "FlashExposureComp"           => 0,
	  "FlashGuideNumber"            => 0,
	  "FlashpixVersion"             => "0100",
	  "FNumber"                     => "4.0",
	  "FocalLength"                 => "37.0 mm",
	  "FocalLength35efl"            => "37.0 mm (35 mm equivalent: 37.1 mm)",
	  "FocalPlaneResolutionUnit"    => "inches",
	  "ISO"                         => 640,
	  "LightValue"                  => "6.0",
	  "MaxAperture"                 => 4,
	  "MinAperture"                 => 23,
	  "MirrorLockup"                => "Disable",
	  "ModifyDate"                  => "2010:07:04 19:03:07",
	  "ShortFocal"                  => "17 mm",
	  "ShutterCount"                => 81821,
	  "ShutterCurtainSync"          => "2nd-curtain sync",
	  "ShutterSpeed"                => "1/25",
	  "ShutterSpeedValue"           => "1/25",
	  );
	
	
	
	#
	# lente
	#
	our %lens = (
	  "Lens"                        => "17.0 - 40.0 mm",
	  "LensID"                      => "Canon EF 17-40mm f/4L",
	  #"LensType"                    => "Canon EF 17-40mm f/4L",
	  "LongFocal"                   => "40 mm",
	  "MaxAperture"                 => 4,
	  "MinAperture"                 => 23,
	  "ShortFocal"                  => "17 mm",
	  );
	
	
	#
	# camera
	#
	our %camera = (
	  "CanonFirmwareVersion"        => "Firmware Version 1.1.6",
	  "CanonImageType"              => "Canon EOS-1Ds Mark II",
	  "CanonModelID"                => "EOS-1Ds Mark II",
	  "CanonImageHeight"            => 3328,
	  "CanonImageWidth"             => 4992,
	  "Model"                       => "Canon EOS-1Ds Mark II",
	  "SerialNumber"                => 314996,
  	  "SerialNumberFormat"          => "Format 2",
	  
	  );
	
 
 
#while(<"/Users/stefanobrozzi/Pictures/matrimonio\ battaglia/20100705.003/DCIM/100EOS1D/*.CR2">)  {
	#my $n=m/(_A2)\.CR2/g;
	#print "-- ".$img."\n";
	
#	readImage("$_");
#}
 


sub groupBY {
	foreach my $k (sort keys %img) {
		next if ($k eq "ShutterCount");
		next if ($k eq "DateTimeOriginal");
		print "select $k, count(*) as c from exif group by $k;\n";
	}
}
# crea la istruzione sql

    sub InsertImg {
    	my ($info) = (@_);
		my @f;
		my @v;
		
		
		# my $cameraid = InsertCamera($info);
		# my $lensid = InsertLens($info);

		foreach my $k (sort keys %img) {
			push(@f,$k);
			push(@v,$info->{$k});
		} 

		my $sql=sprintf "insert into exif (%s) values ('%s');\n", join(',',@f), join("','",@v); 
    	my $sth = $dbh->prepare($sql);
    	$sth->execute or die;
    	$sth->finish;
    	
    	return $dbh->last_insert_id(undef, undef, undef, undef);
    	
		#ÊgetThumb("$_");
		
    }


    sub InsertCamera {
    	my ($id, $info) = (@_);
		my @f;
		my @v;
		foreach my $k (sort keys %camera) {
			push(@f,$k);
			push(@v,$info->{$k});
		}  
		my $sql = sprintf "insert into cameras (%s) values ('%s');\n", join(',',@f), join("','",@v); 
    	my $sth = $dbh->prepare($sql);
    	$sth->execute or die;
    	$sth->finish;
    	
    	return 1;
    }
    
    sub InsertLens {
    	my ($id, $info) = (@_);
		my @f;
		my @v;
		foreach my $k (sort keys %lens) {
			push(@f,$k);
			push(@v,$info->{$k});
		}  
		my $sql = sprintf "insert into lenses (%s) values ('%s');\n", join(',',@f), join("','",@v); 
     	my $sth = $dbh->prepare($sql);
    	$sth->execute or die;
    	$sth->finish;   
    	
    	return 1;	
    }
	


sub readImage {

	my $fileimg = $_;
	return if (! -f "$fileimg");
	print "$fileimg\n";
	
	my $info = ImageInfo("$fileimg") or die;
	# 		dump($info);

	my $id = InsertImg($info);
	
	InsertLens($id, $info);
	InsertCamera($id, $info);

    my $info = ImageInfo($fileimg, 'thumbnailimage');
    
	if (defined $info->{ThumbnailImage}) {

    	my $sth= $dbh->prepare("INSERT INTO thumbs(id, thumb) VALUES (?,?) ");
		$sth->execute($id, ${$info->{ThumbnailImage}}) or die;
		$sth->finish;
   	}
   

}	  



1;
