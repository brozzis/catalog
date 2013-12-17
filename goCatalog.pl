#!/usr/bin/perl -w

use File::Basename;
use DBI;
use Data::Dump qw(dump);
use File::stat; 
use strict;
use File::Find ();

my @set_files;

my $basedir = '/Volumes/TERAMOVIE';

$basedir = qq(/Users/ste/Downloads);


my %exts = ( 
    'pics' => qw(jpg jpeg png gif),  
    'video' => qw(avi divx mpg mpeg), 
    'music' => qw(mp3 mp4),
    'raw' => qw(crw cr2)
    );

# $basedir = '/Users/stefanobrozzi/Miro';
#Ê$basedir = '/Users/stefanobrozzi/Music';


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
# $dbh = DBI->connect('DBI:mysql:movies', 'ste', 'ste' ) || die "Could not connect to database: $DBI::errstr";
$dbh = DBI->connect(          
    "dbi:SQLite:dbname=$basedir/catalog.db", 
    "",                          
    "",                          
    { RaiseError => 1  },         
) or die $DBI::errstr;




eval {
    $dbh->do( qq(CREATE TABLE IF NOT EXISTS "catalog" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "d" varchar(255) DEFAULT NULL,
  "f" varchar(255) DEFAULT NULL,
  "size" decimal(10,0) DEFAULT NULL,
  "f_date" int(11) DEFAULT NULL,
  "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ));

 #   $dbh->do(qq(CREATE INDEX "catalog_IX_hash" ON "catalog" ("hash"));));

    $dbh->do(qq(create table if not exists control ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "label" varchar(32), dts timestamp, dte timestamp) ));

};



# insertFiles();

my $res = readCatalog('avi');


foreach my $id (keys %$res) {
    print $$res{$id}{'f'}."\n";

}
exit;


# TODO: leggere la data dell'ultima lettura
# TODO: fare la differenza  di data
# TODO: scrivere l'attuale
# TODO: aggiungere l'opzione per la  


sub getRecordPerID {
    my ($id) = @_;
    my $sql = qq(select * from catalog where id=?);

    print "$sql, $id\n";
    my $sth = $dbh->prepare($sql);
    $sth->execute($id);
    my $href = $sth->fetchall_arrayref($id) ;

    $sth->finish();

    return $href;
}



sub readCatalog {
    my ($ext) = @_;
    my $sql = qq(select * from catalog where f like "%$ext" );

    my $sth = $dbh->prepare($sql);
    $sth->execute();
#   my @result = $sth->fetchrow_array();
    my $href = $sth->fetchall_hashref('id') ;

    $sth->finish();
#    $results = $dbh->selectall_hashref($sql, 'id');
#    foreach my $id (keys %$results) {
#        print "Value of ID $id is $results->{$id}->{val}\n";
#    }


    return $href;
}


=pod



my $s1=qq(select id,volname,located,date from vols where volname=?);
my $s2=qq(replace into vols (volname,located,date) values (?,?,date(now())) where id=?);

my $sth1 = $dbh->prepare($s1);
$sth1->execute('tera');

my $row = $sth1->fetchrow_hashref;

my $sth2 = $dbh->prepare($s2);
$sth2->execute('tera', $basedir, $row->{"id"});

=cut


#
#
#
sub insertFiles {

    # my $sql=qq(insert into mp3_files (size, md5, title) values (?,?,?));
    my $sql=qq(insert into catalog (d, f, size, f_date) values (?,?,?,?));
    my $ins = $dbh->prepare($sql);

    my $i=0;

    $dbh->{AutoCommit} = 1;
    $dbh->begin_work;  
    $dbh->do("PRAGMA synchronous = OFF");
    $dbh->do("PRAGMA journal_mode=MEMORY");
    foreach my $f (@set_files) {
    	$ins->execute($f->{"dir"}, $f->{"short"}, $f->{"size"}, stat($f->{"dir"}."/".$f->{"short"})->mtime);
    	$i++;
    }

    $dbh->commit;

    printf "\nTerminato. Inseriti %d files.\n", $i;
}


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ 
  #  &&
  #   (int(-M _) < 5)
    && do { push(@set_files,  { 'dir' => $dir, 'short' => $_, 'size' => -s $_ } ); }
}

