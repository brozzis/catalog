#
#
# ls -laR | grep _A2Y | grep CR2 | cut -c56- | sort > 1ds
# :-)
#
my $x=0;
#
# dovrebbe estrarre questo vnumero dal 1o numero della lista...
#
my $y=2663;

my $opt_d; # debug
my $opt_w; # warn on doppio

my $file = "1ds";
open(FH, $file) or die "uff! non trovo il file $file";
while (<FH>) {
	chomp;

  print "checking $_ with $y\n" if $opt_d;
  if (! m/$y/) {
#	print "$_\n";
	($num) = (m/(\d+)\.CR2/);
#	print "---> $num $y\n";
	
	# num=3064 y=3065
	if ($y<$num) { # /* mancano foto */
			
		print "Noooo $_ vs $y..." ;
	
		while (! m/$y/) {
			$x++;
			$y++;
		}
		print " $x files\n";
		# $y += $x;
		$x = 0;
	} elsif ($y>$num) { # /* foto doppie */
		my $doppie = 0;
		while($y>$num) {
		  chomp($_ = <FH>);
		  
		  ($num) = (m/(\d+)\.CR2/);
		  $doppie++;
		  
		}
		print "$_ ($doppie) doppi\n" if $opt_w;
	}

  }
  
  $y++;
}
close FH;
