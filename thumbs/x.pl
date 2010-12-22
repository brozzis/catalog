#!/usr/bin/perl -w

$EXT="jpg";

my($SRCDIR)=qq(test/img/*.$EXT);
my(@lista) = (< $SRCDIR >);

for (< $SRCDIR >) {

#  print $_, -M $_;


  $x++;
  
  s/[- ]/_/g;
  my($ffile)=(m#.*/(.*)\.jpg#g);
  print "$x ",$x%3," $ffile\n";
}
