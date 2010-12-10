#!/usr/bin/perl -w


use DBI;



sub fnumber
{
    my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

    my $sth1 = $dbh->prepare("select exif_fnumber, id from thumbs where exif_fnumber is not null");
    my $sth2 = $dbh->prepare("update thumbs set fnum=round(?,1) where id=?");

    $sth1->execute();

    while ( @row = $sth1->fetchrow_array ) {
	$sth2->execute( eval ($row[0]), $row[1] );
    }

    $dbh->disconnect;
}

sub focallength
{
    my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

    my $sth1 = $dbh->prepare("select temp_focallength, id from thumbs where temp_focallength is not null");
    my $sth2 = $dbh->prepare("update thumbs set exif_focallength=round(?,1) where id=?");

    $sth1->execute();

    while ( @row = $sth1->fetchrow_array ) {
	$sth2->execute( eval ($row[0]), $row[1] );
    }

    $dbh->disconnect;
}


sub exposurebiasvalue
{
    my $dbh = DBI->connect("dbi:Pg:dbname=image", "", "") or die ("no connection");

    my $sth1 = $dbh->prepare("select exif_exposurebiasvalue, id from thumbs where exif_exposurebiasvalue is not null");
    my $sth2 = $dbh->prepare("update thumbs set ebv=round(?,1) where id=?");

    $sth1->execute();

    while ( @row = $sth1->fetchrow_array ) {
	$sth2->execute( eval ($row[0]), $row[1] );
    }

    $dbh->disconnect;
}



exposurebiasvalue();


