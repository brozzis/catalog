#!/usr/bin/perl -w

use strict;
use File::Find ();
use Image::ExifTool;
use Digest::MD5;
use DBI;

my         $exifTool = new Image::ExifTool;

my @AoH; 

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;

print "--[documents]--\n";
File::Find::find({wanted => \&wanted}, '/Users/stefanobrozzi/Documents/');
print "--[downloads]--\n";
File::Find::find({wanted => \&wanted}, '/Users/stefanobrozzi/Downloads/');
print "----\n";


foreach my $i (@AoH) {
    #printf(qq(insert into docs (dir, file, size,md5) values ("%s", "%s", %d,"%s");\n),
	print   $i->{'dir'}."\n";
	   # $dir, $_, -s $name, calc_MD5($dir."/".$_));
}
exit;



sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
(
    /^.*\.pdf\z/si
	||
    /^.*\.djvu\z/si
	||
    /^.*\.chm\z/si
)	&& pdf_info($_);
}

# 
sub print_sql() {
    
}

# classe --- questa la base
sub pdf_info {
    #my $info = $exifTool->ExtractInfo($_);
    #my @t  = $exifTool->GetFoundTags();

    # my $val = $exifTool->GetInfo('Creation Date', 'Page Count');
    # printf("%s %s %d %d\n", $dir, $_, -s $name);
#		$_ =~ s/'/\'/g;
    #### print "\n--- $dir $_".$$val->{"Creation Date"}."\n";
    elab_vals($dir, $_, $name);
    return 0;
}


sub elab_vals {
    my ($dir, $_, $name) = @_;
    my $rec = {};
    
    $rec->{'dir'} = $dir;
    $rec->{'file'} = $_;
    $rec->{'size'} = -s $name;
#x    $rec->{'md5'} = calc_MD5($dir."/".$_);

    push @AoH, $rec;
}

sub print_all {
    
    
    printf(qq(insert into docs (dir, file, size,md5) values ("%s", "%s", %d,"%s");\n), $dir, $_, -s $name, calc_MD5($dir."/".$_));

}


sub calc_MD5 {

  my ($file) = @_;
  my $ctx = Digest::MD5->new;

  # $ctx->add($data);

  open FILE, $file or die "cannot open file $file";

  $ctx->addfile(*FILE);

  # $digest = $ctx->digest;
  my $digest = $ctx->hexdigest;
  # $digest = $ctx->b64digest;

  close FILE;

  return $digest;

}
