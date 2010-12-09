#!/usr/bin/perl -w

use DBI;

$dbh = DBI->connect("DBI:mysql:database=divx;host=localhost", ste, ste, {'RaiseError' => 1});

