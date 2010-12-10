#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell

use strict;
use File::Find ();
use DBI;
use Digest::MD5;

use Getopt::Std;

use exif::exif;

my @d;
my @files;
my %opt;
my $BASE_DIR;

getopts('XiIhvdlatscCe', \%opt);

usage() if $opt{"h"};
list_media() if $opt{"l"};
add_media() if  $opt{"a"};

#
# solo di prova... valori cablati!!!
#
update_thumb() if $opt{"X"};

sub wanted_img;
# sub insertSQL;

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;


if ($opt{"I"} or $opt{"i"} or $opt{"c"} or $opt{"C"} or $opt{"e"}) {
  $BASE_DIR = $ARGV[0];
#  chomp($BASE_DIR =`pwd`) unless ($BASE_DIR);
  if (! -d "$BASE_DIR" ) { die "directory iniziale non corretta"; }
  print "directory utilizzata: $BASE_DIR\n" if $opt{"d"};
  # verificare se esiste file .md5sum o index.md5
  File::Find::find({wanted => \&wanted_img}, $BASE_DIR);
}
insertSQL() if $opt{"i"};
insertDB() if $opt{"I"};
check() if $opt{"c"};
checkOnCD() if $opt{"C"};
showFiles() if $opt{"s"};
cxx() if $opt{"e"};

# $opt{"i"}=0; # insert
# $opt{"v"}=0; # verbosity



sub cxx {
    my $dbh = DBI->connect("dbi:Pg:dbname=image", "postgres", "p") or die ("no connection");
    my $sth;
    my $sqlStr;

    my $num=@d;
    my $i=0;
    $|=1;
    print "Numero di immagini da elaborare: $num\n";
    foreach my $file (@d) {
	$sqlStr = EXIF_SQL( $file );
	if ($sqlStr) {
	    $sth = $dbh->prepare($sqlStr);
	    $sth->execute() or die($sqlStr);
	    print "o";
	} else {
	    print ".";
	}
	$i++;
    }
    print "\nNumero di immagini elaborate: $i\n";
    $|=0;
    
  $sth->finish;
  $dbh->disconnect;

}


sub showFiles {
#  my %f;
  $BASE_DIR = $ARGV[0];
  chomp($BASE_DIR =`pwd`) unless ($BASE_DIR);
  print "directory utilizzata: $BASE_DIR\n" if $opt{"d"};
  # verificare se esiste file .md5sum o index.md5
  File::Find::find({wanted => \&wanted_img}, $BASE_DIR);
#  foreach my $file (@d) {
#    print $file."\n";
#  }
  foreach my $f (@files) {
    print $f->{'fname'}, "\n";
  }
  exit;
}

#
#
#
sub insertDB {
  #
  # scelta della dir iniziale: o il primo parametro, oppure la dir corrente...
  #
  my $LABEL=$ARGV[1] if $ARGV[1];
  my $TIPO=$ARGV[2] if $ARGV[2];
  my $LABEL_ID;

  die("$0 -a <name> <mt> [1:cd, 2:cdrw, 3:disk, 4:zip]") if (!$ARGV[1] or !$ARGV[2]);
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "postgres", "p") or die ("no connection");
  my $sth = $dbh->prepare("insert into media (medium, data, mt) values (?, now(), ?)");

  $sth->execute( $ARGV[1], $ARGV[2]);
  my $oid=$sth->{'pg_oid_status'};

  print $oid."\n";
  $sth = $dbh->prepare("select id from media where oid=?");
  $sth->execute( $oid );
  my @row = $sth->fetchrow_array;

  $LABEL_ID=$row[0];
  die ("codice CD necessario") if !$LABEL_ID;
  print "using: $BASE_DIR and label: $LABEL ( $LABEL_ID )\n";

  my $count=0;

#  if ($opt{"t"}) {
#    $sth = $dbh->prepare("insert into images (name, md5, mit, data, thumbnail, dir, fname) values (?,?,?, now(), ?, ?, ?)") 
#  } else {
    $sth = $dbh->prepare("insert into img_table (name, md5, mit, data, dir, fname) values (?,?,?, now(), ?, ?)");
  my $sth_ins_th = $dbh->prepare("insert into thumbs (md5, thumbnail) values (?,?)");
  my $sth_sel_th = $dbh->prepare("select md5 from thumbs where md5=?");
#  }

  foreach my $file (@d) {
    print ".";
    $count++;

    open(FILE, $file) or die "Can't open $file: $!";
    binmode(FILE);
    my $MD5_CODE = Digest::MD5->new->addfile(*FILE)->hexdigest;

    $sth->execute( $file, $MD5_CODE, $LABEL_ID, $files[$count-1]->{'dir'}, $files[$count-1]->{'fname'} );

    if ($opt{"t"}) {

      $sth_sel_th->execute( $MD5_CODE );
      if (!(@row = $sth_sel_th->fetchrow_array)) {

	my $filename = "/tmp/thumb.jpg";
	`convert -size 120x120 "$file" -resize 120x120 +profile '*' $filename `;

	$dbh->begin_work;
	my $lobjId = $dbh->func($filename, 'lo_import') ;
	if ($lobjId) {
	  $sth_ins_th->execute( $MD5_CODE, $lobjId );
	}
	$dbh->commit;
	
      }
    }
  }
  $sth_ins_th->finish;
  $sth_sel_th->finish;
  $sth->finish;
  $dbh->disconnect;
  `psql image -f aggiorna.sql`;
  exit;
}



#
#
#
sub insertSQL {
  #
  # scelta della dir iniziale: o il primo parametro, oppure la dir corrente...
  #
  my $LABEL=$ARGV[1] if $ARGV[1];
  print "using: $BASE_DIR\n";
  die ("codice CD necessario") if !$LABEL;

  foreach my $file (@d) {
    open(FILE, $file) or die "Can't open $file: $!";
    binmode(FILE);
    my $MD5_CODE = Digest::MD5->new->addfile(*FILE)->hexdigest;
    printf "insert into images (name, md5, mit) values ".
      "('%s','%s','%s');\n", $file, $MD5_CODE, $LABEL;
  }
  exit;
}

#
#
#
sub check {
  print "checking  ".@d." files\n";
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

  # my $sth = $dbh->prepare("select count(*) from images where md5=?");
  my $sth = $dbh->prepare("select i.name, m.medium, mt.name from images i, media m, mt mt  where m.id=i.mit and mt.id=m.mt and md5=?");

  foreach my $file (@d) {

    print "[$file] name\n" if $opt{"d"};
    next if ($file =~ m§/\.xvpics/|/mini/§i);

    my $found = 0;
    print "checking $file\n" if $opt{"v"};
    open(FILE, $file) or die "Can't open $file: $!";
    binmode(FILE);
    my $MD5_CODE = Digest::MD5->new->addfile(*FILE)->hexdigest;
    $sth->execute( $MD5_CODE );

    while ( my @row = $sth->fetchrow_array ) {
      $found = 1;
#      print @row."\n" if $opt{"v"};
      print "[".join(':',@row)."]\n" if $opt{"v"};
    }
    print "*** not found: [$file] ***\n" if not $found;
  }

  # while(<CSV>) {
  #   chomp;
  #   my ($foo,$bar,$baz) = split /,/;
  #   $sth->execute( $foo, $bar, $baz );
  # }


  $dbh->disconnect;
}

#
#
#
sub checkOnCD {
  print "checking  ".@d." files\n";
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

  # my $sth = $dbh->prepare("select count(*) from images where md5=?");
  #my $sth = $dbh->prepare("select i.name, m.medium from images i, media m  where m.id=i.mit and m.mt in (1,2) and md5=?");
  my $sth = $dbh->prepare("select i.name, m.medium from images i, media m  where m.id=i.mit and m.mt =1 and md5=?");

  foreach my $file (@d) {

    print "[$file] name\n" if $opt{"d"};
    next if ($file =~ m§/\.xvpics/|/mini/§i);

    my $found = 0;
    print "checking $file\n" if $opt{"v"};
    open(FILE, $file) or die "Can't open $file: $!";
    binmode(FILE);
    my $MD5_CODE = Digest::MD5->new->addfile(*FILE)->hexdigest;
    $sth->execute( $MD5_CODE );

    while ( my @row = $sth->fetchrow_array ) {
      $found = 1;
#      print @row."\n" if $opt{"v"};
      print "[".join(':',@row)."]\n" if $opt{"v"};
    }
    print "*** not found: [$file] ***\n" if not $found;
  }

  # while(<CSV>) {
  #   chomp;
  #   my ($foo,$bar,$baz) = split /,/;
  #   $sth->execute( $foo, $bar, $baz );
  # }


  $dbh->disconnect;
}



sub list_media {
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

  # my $sth = $dbh->prepare("select count(*) from images where md5=?");
  my $sth = $dbh->prepare("SELECT media.id, medium, data, name from media, mt where mt=mt.id order by media.id");
    $sth->execute( );

    while ( my @row = $sth->fetchrow_array ) {

      printf "%3d %20s %s %s\n", $row[0], $row[1], $row[2], $row[3];
    }

  $dbh->disconnect;
  exit;
}


#
#
#
sub add_media {
  die("$0 -a <name> <mt> [1:cd, 2:cdrw, 3:disk, 4:zip]") if (!$ARGV[0] or !$ARGV[1]);
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

  # my $sth = $dbh->prepare("select count(*) from images where md5=?");
  my $sth = $dbh->prepare("insert into media (medium, data, mt) values (?, now(), ?);");
  # SELECT media.id, medium, data, name from media, mt where mt=mt.id order by media.id");

  $sth->execute( $ARGV[0], $ARGV[1]);
  $dbh->disconnect;
  exit;
}


#
# necessaria questa funzione ??
#
sub del_media {
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

  my $sth = $dbh->prepare("delete from media where id=?");
  $sth->execute( $ARGV[0] );
  # o FK oppure:
  $sth = $dbh->prepare("delete from images where mit=?");
  $sth->execute( $ARGV[0] );
  #
  $dbh->disconnect;
  exit;
}


#
#
#
sub update_media {
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

  my $sth = $dbh->prepare("delete from media where id=?");
  $sth->execute( $ARGV[0] );
  $dbh->disconnect;
  exit;
}



#
# questa funzione è solo un template ...
# per ricordarmi di integrare l'inserimento dei thumbnail
#
sub update_thumb {
  
  my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ();

#  my $mode = $dbh->{pg_INV_WRITE};
#  my $lobj_fd = $dbh->func($lobjId, $mode, 'lo_open');
#  my $nbytes = $dbh->func($lobj_fd, $buf, $len, 'lo_write');
#  my $lobj_fd = $dbh->func($lobj_fd, 'lo_close');

  my $file="nonesistente.jpg";
  my $filename = "/tmp/thumb.jpg";
  `convert -size 120x120 "$file" -resize 120x120 +profile '*' $filename `;

  $dbh->begin_work;
  my $lobjId = $dbh->func($filename, 'lo_import') ;

  if ($lobjId) {
    my $sth = $dbh->prepare("update images set thumbnail = ? where id=46549");
    $sth->execute( $lobjId);
  } else {
    my $str = $dbh->err;
    if (!$str) { $str = "unknown" }
    print("Ahi! [".$str."]\n\n\n");
    
  }
  $dbh->commit;
  $dbh->disconnect;


}

# pulire da thumbnails: /mini/th_

# off> sub wanted_img_off {
# off>   my ($dev,$ino,$mode,$nlink,$uid,$gid);
# off> 
# off>   (
# off>    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
# off>    -f _ && 
# off>    /^.*\.jpg$/is
# off>    ||
# off>    /^.*\.jpeg$/is
# off>    ||
# off>    /^.*\.tif$/is
# off>    ||
# off>    /^.*\.bmp$/is
# off>   ) && do {
# off>     # print("$name\n");
# off>     push( @d, $name );
# off>   };
# off> }

sub wanted_img {
  my ($dev,$ino,$mode,$nlink,$uid,$gid);

  (
   !($name =~ m/\/(\.xvpics|mini|midi)\//i) &&
   (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
   -f _ &&
   /^.*\.(jpg|jpeg|tif|crw|bmp)$/is 
  ) && do {
    # print("$name\n");
    push( @d, $name );
    push( @files, my $rec = { dir => $File::Find::dir, fname => $_ } );
  };
}


#
#
#
sub usage {
  print "$0 [options] [dir] [cd label]\n";
  print "\t-h this help\n";
  print "\t-d debug\n";
  print "\t-c check existence in db (default [TODO])\n";
  print "\t-C check existence in db and on CD\n";
  print "\t-v verbose \n";
  print "\t-l list of media\n";
  print "\t-a add media\n";
  print "\t-i insert in db (write SQL, pipe in psql) [deprecated]\n";
  print "\t-I insert in db (connect to db and write)\n";
  print "\t-t insert thumbnail as large Object during insert\n";
  print "\t-T update images with thumbnail [TODO]\n";
  print "\t-h this help\n";
  print "\tesempio: /mnt/cdrom [1:cd|2:cdrw|3:disk|4:zip] label\n";
  exit;
}
