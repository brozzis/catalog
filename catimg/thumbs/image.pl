#!/usr/bin/perl -w

use strict;

#use DBI;
use DBD::Pg;

my $dbh = DBI->connect("dbi:Pg:dbname=image;host=localhost;port=5432", "", "ste", { AutoCommit => 1 });


my $md5='b5dc3630448df5a9004c3550d4dc5c0e';
my $buf="0" x 4096;
my $sqlStr=q(select thumbnail from thumbs where exist=true and md5=?);
my $sth = $dbh->prepare($sqlStr);
my $rv = $sth->execute($md5);

my @ar = $sth->fetchrow_array();
my $loid = $ar[0];

#  image($dbh, $id );

my $mode=$dbh->{pg_INV_READ};
my $len=4092;

$dbh->{AutoCommit} = 0;

my $lobj_fd = $dbh->func($loid, $mode, 'lo_open'); 
die unless (defined ($lobj_fd));
my $ret=$dbh->func($lobj_fd, $buf, $len, 'lo_read');

print "Content-type: image/jpeg\n\n";
print $buf;
$dbh->func($loid, 'lo_close') or die "probs closing";

$dbh->{AutoCommit} = 1;

$dbh->disconnect;


die($ret);



