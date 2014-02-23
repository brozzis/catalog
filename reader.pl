#!/usr/bin/perl -w

use File::Basename;
use DBI;
use Data::Dump qw(dump);
use File::stat; 
use strict;
use File::Find ();
use Cwd 'abs_path';

use CGI;

use MIME::Base64;

use Digest::MD5 qw(md5 md5_hex md5_base64);

use Image::ExifTool qw(:Public);

use POSIX;

my $basedir =  qq(/Users/ste/Pictures);


my $dbh->{PrintError} = 1; # enable
# $dbh = DBI->connect('DBI:mysql:movies', 'ste', 'ste' ) || die "Could not connect to database: $DBI::errstr";
$dbh = DBI->connect(          
    "dbi:SQLite:dbname=$basedir/catalog.db", 
    "",                          
    "",                          
    { RaiseError => 1  },         
) or die $DBI::errstr;


sub readRecord() {
	my ($id) = @_;


	# TODO: scoprire che ha id 252
	my $sql=qq(select * from catalog 
		left join imageTags using (id)
		left join collider using (idi)
		left join lensTags using (idl)
		left join settingsTags using (ids)
		left join cameraTags using (idc)
		where id = 2246);

	my $sth = $dbh->prepare( $sql );


	$sth->execute();

=pod
	while ( my $ref = $sth->fetchrow_hashref() ) 
	{

		my @headers = keys %{$ref};
		foreach my $k (keys %{$ref}) {
			printf "%25s => %35s\n", $k, $$ref{$k};
		}

	}
=cut
	my $ref = $sth->fetchrow_hashref();

	$sth->finish();
	$dbh->disconnect();

	return $ref;
}

=pod
my $sth = $dbh->prepare( "SELECT * FROM Cars LIMIT 8" );  
my $headers = $sth->{NAME};

my ($id, $name, $price) = @$headers;
printf  "%s %-10s %s\n", $id, $name, $price;

$sth->execute();

my $row;
while($row = $sth->fetchrow_hashref()) {
    printf "%2d %-10s %d\n", $row->{Id}, $row->{Name}, $row->{Price};
}

=cut



my $row = readRecord();
my $q = new CGI;

print $q->header;
print $q->start_html;
print $q->h1("Hello World!");

my @headers = keys %{$row};

my %h = %{$row};
my @record = @h{@headers};


print $q->table(
        {-border=>1, cellpadding=>3},
        $q->Tr([ $q->th(\@headers), $q->td(\@record) ]),
    );


=pod

while ( my $ref = $sth->fetchrow_hashref() ) 
{

	foreach my $k (keys %{$ref}) {
		printf "%25s => %35s\n", $k, $$ref{$k};
	}

}
=cut

print $q->end_html;
