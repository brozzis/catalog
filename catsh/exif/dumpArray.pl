#!/usr/bin/perl -w
use Image::Info qw(image_info dim);

my @info = image_info("$ARGV[0]");
if (my $error = $info->{error}) {
    die "Can't parse image info: $error\n";
}
my $color = $info->{color_type};

my($w, $h) = dim($info);

#foreach (@info{ keys %info }) {
#    print $_;
#    print "\n";
#}

foreach $i (@info) {
    @k = keys %$i;
    @v = values %$i;

    $c=0;
    foreach(@k) {
	print $k[$c].": ";
	#
	if (ref($v[$c]) eq "ARRAY") {
	    foreach(@{ $v[$c] }) {
		print " # $_\n";
	    }
	} else {
	    print $v[$c]."\n";
	}
	#
	$c++;
    }
}


while (($key, $value) = each %info) {
    print $key, "\n";
#    delete $hash{$key};   # This is safe
}

