#!/usr/bin/perl -w

use File::Basename;
use DBI;
use Data::Dump qw(dump);

use strict;
use File::Find ();

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;

File::Find::find({wanted => \&wanted}, '.');


my $set_db = qq(select md5(concat(size, md5)) from mp3_files);
#
# TODO: query db

my @set_files;

# 
# $set_db - $set_files = 
# inserisci in mp3

# $set_files - $set_db = nuovi files
# 
# calcola md5
# inserisci in mp3_files
# inserisci in mp3

foreach my $f (@set_files) {
  print $f->
  print "\n";
}
exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _
    && do { push(@set_files,  { 'full' => $name, 'short' => $_, 'size' => -s $_ } ); }
}


my $dbh = DBI->connect('DBI:mysql:mp3', 'ste', 'ste' ) || die "Could not connect to database: $DBI::errstr";

#  my $sql_search = qq(select pid, title, crit from imdb);

my $sql=qq(insert into mp3_files (size, md5, title) values (?,?,?));
my $ins_st = $dbh->prepare($sql);

my $src = $dbh->prepare(qq(select title, size, md5 from mp3));
$src->execute();
# $hash_ref = $src->fetchall_hashref('pid');
# selectall_arrayref();

my $all = $dbh->selectall_arrayref("select title, size, md5 from mp3");

    

# my $rv = $dbh->bind_columns(\$title, \$size, \$md5 );

foreach my $row (@$all) {
  my ($t, $s, $md5) = @$row;

  # print "$s, $md5, ".basename($t)."\n";
   $ins_st->execute( $s, $md5, basename($t) );
}
