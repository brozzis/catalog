use Digest::MD5;

 $ctx = Digest::MD5->new;

# $ctx->add($data);
 
 
 open FILE, $ARGV[0] or die "cannot open file $ARGV[0]";
 $ctx->addfile(*FILE);

# $digest = $ctx->digest;
 $digest = $ctx->hexdigest;
 print $digest;
# $digest = $ctx->b64digest;

close FILE;