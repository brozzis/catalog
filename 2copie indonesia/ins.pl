#!/usr/bin/perl -w

=head1 ins.pl

verifica l'esistenza dei files

inserisce in indonesia il risultato di un ls -laR
le ultime due righe commentate SQL permettono una verifica
è necessario cambiare l'ultimo parametro di execute() per ogni inserimento

=cut

use DBI;

$dsn = "DBI:mysql:database=ste;host=localhost";
$dbh = DBI->connect($dsn, 'ste', 'ste');

#-rwxrwxrwx  1 root  admin  13650639  8 Ago  2007 _A2Y7346.CR2

$sth = $dbh->prepare("insert into indonesia (file,size,type) values (?,?,?)");

open(FH, shift) or die;
while(<FH>) {
    next unless(m/CR2/);
    chomp;
    my($r,$n,$user,$group,$size,$d,$m,$y,$file) = split(/\s+/);
    # @x = (m(/^(\S{10})\s+(\d+)\s+(\w+)\s+(\w+)\s+(\d+)\s+(\d+)\s+(\w+)\s+(\d+)\s+(\w+\.\w+)/));
    $sth->execute($file,$size,2);
}
close(FH);

# update indonesia set md5=concat(file,size);
# if 1<2 -> should be empty set
# select md5 from indonesia where type=1 and file not in (select md5 from indonesia where type=2);
