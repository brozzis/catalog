#!/usr/bin/perl -w

require 5;
use diagnostics;
use strict;

use DBD::sqlite;
use Digest::MD5;

use File::Find ();
use File::Basename;

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;
sub calc_MD5;

#my $dbh = DBI->connect("DBI:sqlite:database=divx;host=localhost", "ste", "ste", {'RaiseError' => 1});
my $dbh = DBI->connect("dbi:SQLite:dbname=/Users/stefanobrozzi/.docs.db", "", "");

getCloud();


my @F;
 
sub getCloud
{

    my @kw;
    my $sth = $dbh->prepare("select id, file from docs");
    my %new_kw;
	my $limit =5;
 
 	$sth->execute();

	my $ign = 0;

	while (my $ref = $sth->fetchrow_hashref()) {
		my $f = basename($ref->{'file'});
		# $f =~ s/\_/\ /g;
		my $x='';
		while($f=~m/(\w+)/g) {
			# print "<h2>$x</h2>" if ($ign); # mostrsa gli ignorati
			$x = $1; # handy & nasty
			$ign = 1;
			next if ($x =~ m/^(o|di|d|is|you|know|do|t|g|b|q|i|f|what|ii|iii|cs2|cs3|cs4|1st|\d+\w|\d+ed|\d+th|an|en|to|about|fly|how|run|idea|the|if|and|lib|for|of|on|e|by|in|s|ed|2nd|3rd|a|with|using|beyond|where|\w\d+|ch|like|but|were|afraid\d+)$/ig);
			next if ($x =~ m/^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)$/ig);
			next if ($x =~ m/\d/);
			next if ($x =~ m/chm|pdf|djvu/ig);
			next if ($x =~ m/berlusconi|mafia|massoni/ig);
			next if ($x =~ m/lonely|planet|wiley|manning|malestrom|kelby|auerbach|john|ibm|reilly|press|addison|wesley|prentice|mcgraw|hill|nutshell|hall|edition|cookbook|book|ebook|guide|sons/ig);
			next if ($x =~ m/laxxuss|allbooksfree|^tk$|tqw|mixtorrents|peachpit|wrox|darkside|sharereactor|shareconnector|master|studio/ig);
			next if ($x =~ m/professional|guida|guide|bible|dummies|building|understand|publishing|success|everything|training|expert|explain|practice|product|effective|your|new|pocket|group|definitive|reference|inside|defense|principles|more|from|second|third/ig);
			$ign = 0;
			push( @kw, $x );
			$new_kw{$x}++; # non è meglio ?? (nov 2009)
		}

         #  print "Found a row: id = $ref->{'id'}, name = $f\n";
	
	}

	# perlfaq4
             my @unique = ();
               my %seen   = ();

               foreach ( @kw )
                       {
                       next if (m/^\d+$/);
                       my $elem = lc();
                       next if $seen{ $elem }++;
                       push @unique, $elem;
                       }

	print "<div id='container' style='border: 3px solid #000; margin: auto; width:80%; padding:5px; -moz-border-radius: 15px;'>";
	foreach my $el (@unique) {
		my $sql = sprintf("insert into keywords (kw, c) values ('%s',%d);", $el, $seen{$el});
    		my $sth = $dbh->prepare($sql);
 		$sth->execute();
		if ($seen{$el}>$limit) {
			
			printf "<span style='font-size:%dpt'>%s</span>&nbsp;\n",  5+$seen{$el}, $el;
	      		}
	}
	print "</div>";

         $sth->finish();

}




sub insert 
{

  my @F = @_;

	foreach my $D (qw(DOC @misto Docs doc3 photography)) {
  		print "desc dir $D\n";
  		File::Find::find({wanted => \&wanted}, '/Users/stefanobrozzi/Documents/'.$D.'/');
	}
    
    my $sth = $dbh->prepare("insert into docs (md5, file, size) values (?,?,?)");

	foreach my $i (@F) {
	  #	printf "%s %s %d\n", calc_MD5($i), $i, -s $i;
	  $sth->execute(calc_MD5($i), $i, -s $i);
	  
#         while (my $ref = $sth->fetchrow_hashref()) {
#           print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
#         }

}

         $sth->finish();

}

         
         $dbh->disconnect();


exit;


sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _
    && push( @F, "$name");
}
 
