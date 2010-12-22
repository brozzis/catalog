#!/usr/bin/perl -w

use strict;

#use DBI;
use DBD::Pg;

#my $dbh = DBI->connect('dbi:Pg:dbname=p1', undef, undef, { AutoCommit => 1 });
#my $dbh = DBI->connect("dbi:Pg:dbname=image;host=localhost;port=5431", "", "stefano", { AutoCommit => 1 });
my $dbh = DBI->connect("dbi:Pg:dbname=image;host=localhost;port=5432", "", "stefano", { AutoCommit => 1 });

my $buf = 'abcdefghijklmnopqrstuvwxyz' x 400;

my $md5="89510c23f44c294fb2e20f43f841dcda";
#my $sqlStr=q(select thumbnail from thumbs where exist=true and md5=?);
my $sqlStr=q(select thumbnail, md5 from thumbs where exist=true and md5='b5dc3630448df5a9004c3550d4dc5c0e');
# my $sth = $dbh->prepare($sqlStr, \%attr);
my $sth = $dbh->prepare($sqlStr);
#my $rv = $sth->execute($md5);
my $rv = $sth->execute();

my $id;
my @ar;

while (@ar = $sth->fetchrow_array()) {
  $id = $ar[0];

# my $id = write_blob($dbh, undef, $buf);
# my $dat = read_blob($dbh, $id);

  print "xx\n";

#  new_export($dbh, $id, $ar[1]);
  export_LOB($dbh, $id );
  print "xx\n";
}

$dbh->disconnect;


#
#
#
sub write_blob {
    my ($dbh, $lobj_id, $data) = @_;
    
    # begin transaction
    $dbh->{AutoCommit} = 0;
    
    # Create a new lo if we are not passed an lo object ID.
    unless ($lobj_id) {
	# Create the object.
	$lobj_id = $dbh->func($dbh->{'pg_INV_WRITE'}, 'lo_creat');
    }    

    # Open it to get a file descriptor.
    my $lobj_fd = $dbh->func($lobj_id, $dbh->{'pg_INV_WRITE'}, 'lo_open');

    $dbh->func($lobj_fd, 0, 0, 'lo_lseek');
    
    # Write some data to it.
    my $len = $dbh->func($lobj_fd, $data, length($data), 'lo_write');
    
    die "Errors writing lo\n" if $len != length($data);

    # Close 'er up.
    $dbh->func($lobj_fd, 'lo_close') or die "Problems closing lo object\n";
 
    # end transaction
    $dbh->{AutoCommit} = 1;
    
    return $lobj_id;
}

#
#
#
sub read_blob {
    my ($dbh, $lobj_id) = @_;
    my $data = '';
    my $read_len = 256;
    my $chunk = '';

    # begin transaction
    $dbh->{AutoCommit} = 0;

    my $lobj_fd = $dbh->func($lobj_id, $dbh->{'pg_INV_READ'}, 'lo_open') or die "probs opening";

    $dbh->func($lobj_fd, 0, 0, 'lo_lseek');

    # Pull out all the data.
    while ($dbh->func($lobj_fd, $chunk, $read_len, 'lo_read')) {
	$data .= $chunk;
    }

    $dbh->func($lobj_fd, 'lo_close') or die "Problems closing lo object\n";

    # end transaction
    $dbh->{AutoCommit} = 1;

    return $data;
}


#
#
#
sub export_LOB {
  my ($dbh, $loid) = @_;
  my $fname="ciccio.jpg";
#  my $mode=$dbh->{pg_INV_WRITE} |$dbh->{pg_INV_READ};
  my $mode=$dbh->{pg_INV_READ};

  $dbh->{AutoCommit} = 0;

  #my $lobjId = $dbh->func($filename, 'lo_import') ;
  my $lobj_fd = $dbh->func($loid, $mode, 'lo_open'); 
  die unless (defined ($lobj_fd));

#  DBD::Pg::db::lo_export($dbh, $loid, $fname);
  my $ret=$dbh->func($loid, $fname, 'lo_export');

  #$dbh->func($lobj_fd, 'lo_unlink');
  $dbh->func($lobj_fd, 'lo_close') or die "probs closing";

  $dbh->{AutoCommit} = 1;
}


#
#
#
sub new_export {

  my ($dbh, $loid, $md5) = @_;
  my $fname=qq(/home/ste/thumbs/$md5.jpg);
#  my $mode=$dbh->{pg_INV_WRITE} |$dbh->{pg_INV_READ};
  my $mode=$dbh->{pg_INV_READ};

  $dbh->{AutoCommit} = 0;

  #my $lobjId = $dbh->func($filename, 'lo_import') ;
  my $lobj_fd = $dbh->func($loid, $mode, 'lo_open'); 
  die unless (defined ($lobj_fd));

#   $somecontent = pg_lo_read ($loid, 4096);
#
#   $filename="/home/ste/thumbs/".$row[1].".jpg";
#   $handle = fopen($filename, 'wb') 
#   	or die( "[$i] Cannot open file ($filename)");
#   fwrite($handle, $somecontent) 
#   	or print("[$i] Cannot write to file ($filename)") ;
#   fclose($handle);

#  DBD::Pg::db::lo_export($dbh, $loid, $fname);
  my $ret=$dbh->func($loid, $fname, 'lo_export');

  #$dbh->func($lobj_fd, 'lo_unlink');
  $dbh->func($lobj_fd, 'lo_close') or die "probs closing";

  $dbh->{AutoCommit} = 1;

}

