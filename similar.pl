#!/usr/bin/perl -w
# http://www.stonehenge.com/merlyn/LinuxMag/col50.html
# Randal L. Schwartz
use strict;
$|++;

use File::Copy qw(move);

use Image::Magick;
use Cache::FileCache;

sub warnif;

## config
my $FUZZ = 5; # permitted average deviation in the vector elements
my $CORRUPT = "CORRUPT"; # if defined, rename corrupt images into this dir
## end config

my $cache = Cache::FileCache->new({
                                   namespace => 'findimagedupes',
                                   cache_root => (glob("~/.filecache"))[0],
                                  });


my @buckets;

FILE: while (@ARGV) {
  my $file = shift;
  if (-d $file) {
    opendir DIR, $file or next FILE;
    unshift @ARGV, map {
      /^\./ ? () : "$file/$_";
    } sort readdir DIR;
    next FILE;
  }

  next FILE unless -f _;

  my (@stat) = stat(_) or die "should not happen: $!";

  my $key = "@stat[0, 1, 9]"; # dev/ino/mtime

  my @vector;

  print "$file ";
  if (my $data = $cache->get($key)) {
    print "... is cached\n";
    @vector = @$data;
  } else {
    my $image = Image::Magick->new;
    if (my $x = $image->Read($file)) {
      if (defined $CORRUPT and $x =~ /corrupt|unexpected end-of-file/i) {
        print "... renaming into $CORRUPT\n";
        -d $CORRUPT or mkdir $CORRUPT, 0755 or die "Cannot mkdir $CORRUPT: $!";
        move $file, $CORRUPT or warn "Cannot rename: $!";
      } else {
        print "... skipping ($x)\n";
      }
      next FILE;
    }
    print "is ", join("x",$image->Get('width', 'height')), "\n";
    warnif $image->Normalize();
    warnif $image->Resize(geometry => '4x4!');
    warnif $image->Set(magick => 'rgb');
    @vector = unpack "C*", $image->ImageToBlob();
    $cache->set($key, [@vector]);
  }
  BUCKET: for my $bucket (@buckets) {
    my $error = 0;
    INDEX: for my $index (0..$#vector) {
      $error += abs($bucket->[0][$index] - $vector[$index]);
      next BUCKET if $error > $FUZZ * @vector;
    }
    push @$bucket, $file;
    print "linked ", join(", ", @$bucket[1..$#$bucket]), "\n";
    next FILE;
  }
  push @buckets, [[@vector], $file];
}

for my $bucket (@buckets) {
  my @names = @$bucket;
  shift @names;                 # first element is vector
  next unless @names > 1;       # skip unique images
  my $images = Image::Magick->new;
  $images->Read(@names);
  my $montage =
    $images->Montage(geometry => '400x400', label => "[%p] %i %wx%h %b");
  print "processing...\n";
  $montage->Display();
  print "Delete? [none] ";
  my @dead = grep { $_ >= 1 and $_ <= @$images } <STDIN> =~ /(\d+)/g;
  for (@dead) {
    my $dead_name = $images->[$_ - 1]->Get('base-filename');
    warn "rm $dead_name\n";
    unlink $dead_name or warn "Cannot rm $dead_name: $!";
  }
}

use Carp qw(carp);
sub warnif {
  my $value = shift;
  carp $value if $value;
}
