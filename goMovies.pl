#!/usr/bin/perl -w

use File::Basename;
use DBI;
use Data::Dump qw(dump);
use File::stat; 
use strict;
use File::Find ();

my @set_files;

my $basedir = '/Volumes/TERAMOVIE';
# $basedir = '/Users/stefanobrozzi/Miro';
#Ê$basedir = '/Users/stefanobrozzi/Music';

my $vid = 1;

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;

=pod

per pulire il nome dir, da chiamare in insert: cleandir(dirname)
mai testata

=cut

sub cleandir {
	my ($dir) = @_;
	$dir =~ s/^${basedir}//;
	return $dir;
}

File::Find::find({wanted => \&wanted}, $basedir);

# dump(@set_files);

# SELECT userId, url, FROM_UNIXTIME(epoch,"%Y-%m-%d")

my $dbh->{PrintError} = 1; # enable
$dbh = DBI->connect('DBI:mysql:movies', 'ste', 'ste' ) || die "Could not connect to database: $DBI::errstr";


# TODO: leggere la data dell'ultima lettura
#ÊTODO: fare la differenza  di data
# TODO: scrivere l'attuale
#ÊTODO: aggiungere l'opzione per la  

=pod



my $s1=qq(select id,volname,located,date from vols where volname=?);
my $s2=qq(replace into vols (volname,located,date) values (?,?,date(now())) where id=?);

my $sth1 = $dbh->prepare($s1);
$sth1->execute('tera');

my $row = $sth1->fetchrow_hashref;

my $sth2 = $dbh->prepare($s2);
$sth2->execute('tera', $basedir, $row->{"id"});

=cut

# my $sql=qq(insert into mp3_files (size, md5, title) values (?,?,?));
my $sql=qq(insert into tera (vid, d, f, size, f_date) values (?,?,?,?,?));
my $ins = $dbh->prepare($sql);

my $i=0;

foreach my $f (@set_files) {
	$ins->execute($vid, $f->{"dir"}, $f->{"short"}, $f->{"size"}, stat($f->{"dir"}."/".$f->{"short"})->mtime);
	$i++;
}

printf "\nTerminato. Inseriti %d files.\n", $i;
exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ 
  #  &&
  #   (int(-M _) < 5)
    && do { push(@set_files,  { 'dir' => $dir, 'short' => $_, 'size' => -s $_ } ); }
}

