#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell


# printf ("insert into movies (fname, md5) values( '%s', '%s' );\n", $1, $2 ) if (m/(\S{32})\s+(.+)/);

use Digest::MD5;
use strict;
use File::Find ();

use Data::Dumper;

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;
sub md5;

# Traverse desired filesystems
my @foundfiles=[]   ;
File::Find::find({wanted => \&wanted}, '/Users/stefanobrozzi/Movies');

foreach my $f (@foundfiles) {
    print md5($f).": ".$f."\n";

}


sub md5()
{
    my $f=$_[0]; 
    my $ctx = Digest::MD5->new;

    open(FH, $f) or die "nn trovo $f";
    binmode(FH);
    my $d = Digest::MD5->new->addfile(*FH)->hexdigest;
    close(FH);    
    return $d;
}


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    /^.*\.avi\z/si
    ||
    /^.*\.wmv\z/si
    && push(@foundfiles,"$name");
}

