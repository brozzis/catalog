=pod
do {
  require MIME::Base64;
  {
    ThumbnailImage => \MIME::Base64::decode("/9j

=cut
use MIME::Base64;

use Image::ExifTool qw(ImageInfo);

use Data::Dump qw(dump);

my $f=qq(/Users/ste/Desktop/thumb/_A2Y2516.CR2);

my $info = ImageInfo($f, 'thumbnailimage');

# 
# dump($info->{'ThumbnailImage'});

#$encoded = encode_base64($info);
#dump($encoded);

# $decoded = decode_base64($info->{'ThumbnailImage'});
# dump($decoded);

open(FH, ">:raw", "test.jpg") or die;
# binmode(FH);
#$d = ${$info->{'ThumbnailImage'}};
print FH ${$info->{'ThumbnailImage'}};

close(FH);


open(FH, ">:raw", "test.jpg.uu") or die;
# binmode(FH);
#$d = ${$info->{'ThumbnailImage'}};
print FH encode_base64(${$info->{'ThumbnailImage'}});

close(FH);

