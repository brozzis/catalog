#!/usr/bin/perl -w
my($LABEL)=$ARGV[0];
open (FH,"/tmp/list.files") or die();
while(<FH>) {
  printf ("insert into images (name, md5, mit) values ".
    "('%s','%s','%s');\n", $2, $1, $LABEL) if (m/(\S+)\s+(.+)/);
}
close(FH);
