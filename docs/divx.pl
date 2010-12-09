#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell


=head1 ins.pl

inserisce la dir cablata
nel db divx.divx

=cut

use strict;
use File::Find ();
use DBI;
use Digest::MD5;

my $opt_d = 0;

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;

my @files = ();

# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, '/Users/stefanobrozzi/Movies/Lost');

my $dsn = "DBI:mysql:database=divx;host=localhost";
my $dbh = DBI->connect($dsn, 'ste', 'ste');
my $sth = $dbh->prepare("insert into divx (fname,md5,dir,size,vid) values (?,?,?,?,?)");


for my $aref ( @files ) {

    my $dir = $aref->[0];
    my $file = $aref->[1];
    
    open(FILE, $dir."/".$file) or die "Can't open '$file': $!";
    binmode(FILE);
    my $md5=Digest::MD5->new->addfile(*FILE)->hexdigest;
    # print Digest::MD5->new->addfile(*FILE)->hexdigest, " $file\n" if ($opt_d);
    
    my $size=123456;
    my $vid=0;
    $sth->execute($file,$md5,$dir,$size,$vid);
}



exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    /^.*\.avi\z/si &&
    -f _
    && push(@files, [ "$File::Find::dir", $_ ] );
}




# update indonesia set md5=concat(file,size);
# if 1<2 -> should be empty set
# select md5 from indonesia where type=1 and file not in (select md5 from indonesia where type=2);
