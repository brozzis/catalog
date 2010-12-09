#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell


=head1 ins2.pl

per verificare 2 dir differenti

=cut

use strict;
use File::Find ();
use DBI;
use Digest::MD5;

my $opt_d = 0;

use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;


my $dsn = "DBI:mysql:database=ste;host=localhost";
my $dbh = DBI->connect($dsn, 'ste', 'ste');

$dbh->do(qq(truncate table imm01));

my $sth = $dbh->prepare("insert into imm01 (fname,md5,dir,size,vid) values (?,?,?,?,?)");

my @dirs = qw(/Users/stefanobrozzi/Pictures/chk/D1 /Users/stefanobrozzi/Pictures/chk/D2);
my $vid=0;
my @files;

foreach my $dir (@dirs) {    
    @files = (); 
    File::Find::find({wanted => \&wanted}, "$dir");   
    
    for my $aref ( @files ) {
    
        my $dir = $aref->[0];
        my $file = $aref->[1];
        
        open(FILE, $dir."/".$file) or die "Can't open '$file': $!";
        binmode(FILE);
        my $md5 = Digest::MD5->new->addfile(*FILE)->hexdigest;
        
        my $size=(-s $dir."/".$file);
        $sth->execute($file,$md5,$dir,$size,$vid);
    }

    $vid++;
    
}

my $view1=qq(create or replace view due_no_uno as select * from imm01 i2 where vid=1 and concat(md5, size) not in ( SELECT concat(md5, size) FROM imm01 i where vid=0));
my $view2=qq(create or replace view uno_no_due as select * from imm01 i2 where vid=0 and concat(md5, size) not in ( SELECT concat(md5, size) FROM imm01 i where vid=1));
$dbh->do($view1);
$dbh->do($view2);

print "presenti in 1 ma non in 2:\n";
         $sth = $dbh->prepare("SELECT * FROM uno_no_due");
         $sth->execute();
         while (my $ref = $sth->fetchrow_hashref()) {
           print "Found a row: id = $ref->{'id'}, name = $ref->{'fname'}\n";
         }
         $sth->finish();

print "presenti in 2 ma non in 1:\n";
         $sth = $dbh->prepare("SELECT * FROM due_no_uno");
         $sth->execute();
         while (my $ref = $sth->fetchrow_hashref()) {
           print "Found a row: id = $ref->{'id'}, name = $ref->{'fname'}\n";
         }
         $sth->finish();

$dbh->disconnect;

exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    /^.*\.psd\z/si
    ||
    /^.*\.xmp\z/si
    ||
    /^.*\.crw\z/si
    ||
    /^.*\.cr2\z/si &&
    -f _
    && push(@files, [ "$File::Find::dir", $_ ] );
}




# update indonesia set md5=concat(file,size);
# if 1<2 -> should be empty set
# select md5 from indonesia where type=1 and file not in (select md5 from indonesia where type=2);

