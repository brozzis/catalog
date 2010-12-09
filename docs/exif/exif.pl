#!/usr/bin/perl -w

           BEGIN { 
push(@INC, qq(/Library/Perl/5.8.8/));
$Image::ExifTool::noConfig = 1 }
use Image::ExifTool qw(:Public);


$image = qq(_A2Y3534.CR2);

           %options = (PrintConv => 1);
           @tagList = qw(filename imagesize xmp:creator exif:* -ifd1:*);
           $info = ImageInfo($image, \@tagList, \%options);

              foreach (sort keys %$info) {
                   print "$_ => $$info{$_}\n";
               }

=cut 

%options = (PrintConv => 0);

CreateDate => 2009:07:12 19:08:12
ExposureCompensation (1) => 0.3333333333
ExposureMode => 0
ExposureProgram => 3
ExposureTime => 3.2
FNumber => 7.1
FileName => _A2Y3534.CR2
Flash => 16
FocalLength => 28
ISO (1) => 100
Make => Canon
MeteringMode (1) => 5
Model => Canon EOS-1Ds Mark II
Orientation => 1
UserComment => 
WhiteBalance (2) => 0

=end


=cut 

%options = (PrintConv => 1);

ApertureValue => 7.0
ExposureCompensation (1) => +1/3
ExposureMode => Auto
ExposureProgram => Aperture-priority AE
ExposureTime => 3.2
FNumber => 7.1
FileName => _A2Y3534.CR2
Flash => Off, Did not fire
FocalLength => 28.0 mm
ISO (1) => 100
Make => Canon
MeteringMode (1) => Multi-segment
Model => Canon EOS-1Ds Mark II
ModifyDate => 2009:07:12 19:08:12
Orientation => Horizontal (normal)
ShutterSpeedValue => 3.2
UserComment => 
WhiteBalance (2) => Auto

=end

