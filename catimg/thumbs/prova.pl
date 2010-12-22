use DBI;
my $dbh = DBI->connect('dbi:Pg:dbname=ste', undef, undef,
		       { RaiseError => 1 });

$dbh->{'AutoCommit'} = 0;

my $RW = ($dbh->{pg_INV_WRITE} | $dbh->{pg_INV_READ});
my $lob_id = $dbh->func($RW, 'lo_creat');

my $lob_fd = $dbh->func($lob_id, $RW, 'lo_open');
$dbh->func($lob_fd, pack('c*', 1, 2), 2, 'lo_write');		### [1]
$dbh->commit;
$lob_fd = $dbh->func($lob_id, $RW, 'lo_open');
$dbh->func($lob_fd, pack('c*', 3, 4, 5), 3, 'lo_write');	### [2]
#$dbh->commit;

my $buffer;
local $^W = 0;
$dbh->func($lob_fd, 0, 0, 'lo_lseek');
my $read = $dbh->func($lob_fd, $buffer, 3, 'lo_read');

print "Read $read; got ", unpack('c*', $buffer), "\n";
