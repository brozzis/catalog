#!/usr/bin/perl -w

use Digest::MD5 qw(md5 md5_hex md5_base64);
use strict;
use File::Find ();

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;


sub localDir {
  #        $digest = md5($data);

  foreach (<*.mp3>) {
    print calcMD5($_)."\n";
  }
  
}
# exit;

sub wanted;



# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, 'Music');
exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
      /^.*\.mp3\z/si
    && print calcMD5($_)." ".$name."\n";
}



sub calcMD5
  {
    my ($f)=@_;
    # print $f;
  open FH, $f or die("can't open $f: $!\n");
  my $buffer;
  my $rv = read(FH, $buffer, 0xffff, 0xff)
        or die "Couldn't read from HANDLE : $!\n";
    #print $rv;
  my $digest = md5_hex($buffer);
  close FH;
  return $digest;
}
