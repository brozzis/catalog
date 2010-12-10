#!/usr/bin/perl -w

use Digest::MD5;

use DBI;

my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

# my $sth = $dbh->prepare("select count(*) from images where md5=?");
my $sth = $dbh->prepare("select i.name, m.medium, mt.name from images i, media m, mt mt  where m.id=i.mit and mt.id=m.mt and md5=?");

my $opt_d=0;
my $opt_v=1;

foreach my $file (<*>) {

  next if (! ($file =~ m/\.jpg|\.tif|\.bmp/i));

  my $found = 0;
  print "checking $file\n" if $opt_d;
  open(FILE, $file) or die "Can't open $file: $!";
  binmode(FILE);
  my $MD5_CODE = Digest::MD5->new->addfile(*FILE)->hexdigest;
  $sth->execute( $MD5_CODE );

  while ( @row = $sth->fetchrow_array ) {
    $found = 1;
    print "@row\n" if $opt_v;
  }
  print "*** not found: [$file] ***\n" if not $found;
}

# while(<CSV>) {
#   chomp;
#   my ($foo,$bar,$baz) = split /,/;
#   $sth->execute( $foo, $bar, $baz );
# }


$dbh->disconnect;

# print v9786;

