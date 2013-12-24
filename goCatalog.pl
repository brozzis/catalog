#!/usr/bin/perl -w

use File::Basename;
use DBI;
use Data::Dump qw(dump);
use File::stat; 
use strict;
use File::Find ();
use Cwd 'abs_path';

use Digest::MD5 qw(md5 md5_hex md5_base64);

use Image::ExifTool qw(:Public);

my @set_files;

my $cameras = {};
my $settings = {};
my $lenses = {};
my $collider = {};



my $dbh;



foreach my $f (@ARGV)
{
    $f = qq(/Users/ste/Pictures);
    readDirectory( abs_path($f) );
}



exit;



sub readDirectory {

    my ($basedir) = @_;

    # Set the variable $File::Find::dont_use_nlink if you're using AFS,
    # since AFS cheats.

    # for the convenience of &wanted calls, including -eval statements:
    use vars qw/*name *dir *prune/;
    *name   = *File::Find::name;
    *dir    = *File::Find::dir;
    *prune  = *File::Find::prune;

    sub wanted;


    File::Find::find({wanted => \&wanted}, $basedir);

    # dump(@set_files);

    # SELECT userId, url, FROM_UNIXTIME(epoch,"%Y-%m-%d")

    $dbh->{PrintError} = 1; # enable
    # $dbh = DBI->connect('DBI:mysql:movies', 'ste', 'ste' ) || die "Could not connect to database: $DBI::errstr";
    $dbh = DBI->connect(          
        "dbi:SQLite:dbname=$basedir/catalog.db", 
        "",                          
        "",                          
        { RaiseError => 1  },         
    ) or die $DBI::errstr;




    eval {
    #    $dbh->do( qq(drop TABLE  "catalog") );
        $dbh->do( qq(CREATE TABLE IF NOT EXISTS "catalog" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "d" varchar(255) DEFAULT NULL,
      "f" varchar(255) DEFAULT NULL,
      "size" decimal(10,0) DEFAULT NULL,
      "f_date" int(11) DEFAULT NULL,
      "created_at" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ));

     #   $dbh->do(qq(CREATE INDEX "catalog_IX_hash" ON "catalog" ("hash"));));

        # TODO: gestire tab control (label - data)
        $dbh->do(qq(create table if not exists control ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "label" varchar(32), dts timestamp, dte timestamp) ));

    };



    #  insertFiles();


    print "leggo da db le immagini row... ";
    my $res = readCatalog('cr2');
    print "lette\n";

    print "estraggo le informazioni...\n";
    my $n=0;
    foreach my $id (keys %$res) {
        $n++;
        my $f = $$res{$id}{'d'}."/".$$res{$id}{'f'};
        readRawImage($f);
        printf "\r%d", $n unless ($n % 100);
        goto X if ($n > 200) 

    }

X:
#    dump($cameras);
#    dump($lenses);
 #   dump($settings);


    dump($collider);
}









=pod

per pulire il nome dir, da chiamare in insert: cleandir(dirname)
mai testata

=cut

sub cleandir {
    my ($basedir, $dir) = @_;
    $dir =~ s/^${basedir}//;
    return $dir;
}


sub _Attempt_video
{
    my $f = qq(/Users/ste/Downloads/DSCF3094.AVI);
    my @x = qw(Compression Description MIMEType ImageSize);
    my $info = ImageInfo($f, @x);

}



# ancora non utilizzato
my %exts = ( 
    'pics' => qw(jpg jpeg png gif),  
    'video' => qw(avi divx mpg mpeg), 
    'music' => qw(mp3 mp4),
    'raw' => qw(crw cr2)
    );



# TODO: leggere la data dell'ultima lettura
# TODO: fare la differenza  di data
# TODO: scrivere l'attuale
# TODO: aggiungere l'opzione per la  


=pod
per selezionare la singola entry
=cut
sub getRecordPerID {
    my ($id) = @_;
    my $sql = qq(select * from catalog where id=?);

    print "$sql, $id\n";
    my $sth = $dbh->prepare($sql);
    $sth->execute($id);
    my $href = $sth->fetchall_arrayref($id) ;

    $sth->finish();

    return $href;
}



=pod
shortcut per estrarre particolari estensioni (i.e images)
=cut
sub readCatalog {
    my ($ext) = @_;
    my $sql = qq(select * from catalog where f like "%$ext" );

    my $sth = $dbh->prepare($sql);
    $sth->execute();
#   my @result = $sth->fetchrow_array();
    my $href = $sth->fetchall_hashref('id') ;

    $sth->finish();
#    $results = $dbh->selectall_hashref($sql, 'id');
#    foreach my $id (keys %$results) {
#        print "Value of ID $id is $results->{$id}->{val}\n";
#    }


    return $href;
}


=pod



my $s1=qq(select id,volname,located,date from vols where volname=?);
my $s2=qq(replace into vols (volname,located,date) values (?,?,date(now())) where id=?);

my $sth1 = $dbh->prepare($s1);
$sth1->execute('tera');

my $row = $sth1->fetchrow_hashref;

my $sth2 = $dbh->prepare($s2);
$sth2->execute('tera', $basedir, $row->{"id"});

=cut


#
#
#
sub insertFiles {

    # my $sql=qq(insert into mp3_files (size, md5, title) values (?,?,?));
    my $sql=qq(insert into catalog (d, f, size, f_date) values (?,?,?,?));
    my $ins = $dbh->prepare($sql);

    my $i=0;

    $dbh->{AutoCommit} = 1;
    $dbh->begin_work;  
    $dbh->do("PRAGMA synchronous = OFF");
    $dbh->do("PRAGMA journal_mode=MEMORY");
    foreach my $f (@set_files) {
    	$ins->execute($f->{"dir"}, $f->{"short"}, $f->{"size"}, stat($f->{"dir"}."/".$f->{"short"})->mtime);
    	$i++;
    }

    $dbh->commit;

    printf "\nTerminato. Inseriti %d files.\n", $i;
}



sub saveImageData {
    return;
}
 



sub readRawImage {


    my ($f) = @_; # 
    my @tags = qw(serComment Title ShutterSpeed Lens ISO CameraID Aperture Description ImageSize);

    @tags = qw(
        ApertureValue
        AutoExposureBracketing
        AutoISO
        BaseISO
        CameraType
        CanonExposureMode
        CanonFlashMode
        CanonImageType
        CanonModelID
        ContinuousDrive
        CreateDate
        ExposureCompensation
        ExposureLevelIncrements
        ExposureProgram
        ExposureTime
        FNumber
        Flash
        FocalLength
        FocusMode
        ISO
        ImageSize
        Lens
        LensID
        LensType
        MIMEType
        Make
        MaxAperture
        MaxFocalLength
        MeasuredEV
        MeteringMode
        MinAperture
        MinFocalLength
        ModifyDate
        SerialNumber
        ShutterCount
        ShootingMode
        ShutterSpeed
        ShutterSpeedValue
        TargetAperture
        TargetExposureTime
    );


#        ShutterSpeedValue
#        TargetAperture
#        TargetExposureTime


    my @imageTags = qw(
        ApertureValue
        CanonFlashMode
        CreateDate
        ExposureCompensation
        ExposureTime
        FNumber
        Flash
        FocalLength
        FocusMode
        ISO
        ImageSize
        MeasuredEV
        ModifyDate
        ShootingMode
        
        ShutterSpeed
        );


    my @Canon1Ds = qw(ShutterCount);

#    CanonExposureMode
#    ExposureProgram

    my @settingsTags = qw(
        AutoExposureBracketing
        CanonFlashMode
        ContinuousDrive
        ExposureLevelIncrements
        Flash
        FocusMode
        ISO
        MeteringMode
        ShootingMode
    );


    my @lensTags = qw(
        Lens
        LensID
        LensType
        MaxAperture
        MaxFocalLength
        MinAperture
        MinFocalLength
    );

    my @cameraTags = qw(
        CameraType
        CanonImageType
        CanonModelID
        Make
        SerialNumber
    );


=pod
foreach my $tag (@x) {
    # body...
    print qq/\t"$tag"  varchar(30),\n/;
}
=cut



    my $info = ImageInfo($f, @tags);

    die if (! defined($info));
    my %hash = %{ $info };

    my $digest;

    # dumpTags();
    #    exit;


    # debug... dump di tutti i tags
    #    dumpTags();

    sub dumpTags {
        foreach my $t (@imageTags) {
            printf "%20s => %-30s\n", $t, $hash{$t};
        }

        
        print " === all tags \n";
    #    dump(@tags);
        dump(@hash{@tags});

        print join(':',@hash{@tags});
        print qq(\n);
        $digest = md5_hex(join(':',@hash{@tags}));
        print $digest."\n";


        print " === lens tags \n";
    #    dump(@lensTags);
        dump(@hash{@lensTags});
        print join(':',@hash{@lensTags});
        print qq(\n);
        $digest = md5_hex(join(':',@hash{@lensTags}));
        print $digest."\n";

        print " === camera tags \n";
    #    dump(@cameraTags);
        dump(@hash{@cameraTags});
        $digest = md5_hex(join(':',@hash{@cameraTags}));
    #    print $digest."\n";

        print " === image tags \n";
    #    dump(@imageTags);
        dump(@hash{@imageTags});
        $digest = md5_hex(join(':',@hash{@imageTags}));
        print $digest."\n";

        print " === settings tags \n";
    #    dump(@imageTags);
        dump(@hash{@settingsTags});
        $digest = md5_hex(join(':',@hash{@settingsTags}));
        print $digest."\n";

    }


    my $imageAdds = {};


    $digest = md5_hex(join(':',@hash{@cameraTags}));
    $imageAdds->{'camera'} = $digest;
    $cameras->{substr($digest,0,8)} = [ @hash{@cameraTags} ];

    $digest = md5_hex(join(':',@hash{@settingsTags}));
    $imageAdds->{'settings'} = $digest;
    $settings->{substr($digest,0,8)} = [ @hash{@settingsTags} ];

    $digest = md5_hex(join(':',@hash{@lensTags}));
    $imageAdds->{'lens'} = $digest;
    $lenses->{substr($digest,0,8)} = [ @hash{@lensTags} ];

    $imageAdds->{'ShutterCount'} = $hash{'ShutterCount'};

    $digest = md5_hex(join(':',@hash{@imageTags}));
#    $imageAdds->{'image'} = $digest;
    $collider->{$digest} = $imageAdds;

    return;

    # aggiungo campo per id immagine
    push(@tags, 'idCollider');

    my $keystr = (join ",", (@tags));
    my $valstr = join ',', (split(/ /, "? " x (scalar(@tags))));
    my @values = @hash{@tags};

    # aggiungo id immagine
    push(@values, $digest);

    my $query = qq/
        INSERT INTO exifRaw (
            $keystr
        )
        VALUES (
            $valstr
        )
    /;

    my $sth = $dbh->prepare($query) 
        or die "Can't prepare insert: ".$dbh->errstr()."\n";

    $sth->execute(@values)
        or die "Can't execute insert: ".$dbh->errstr()."\n";


    # TODO: mancano  insert dei dati normalizzati

}



sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ 
  #  &&
  #   (int(-M _) < 5)
    && do { push(@set_files,  { 'dir' => $dir, 'short' => $_, 'size' => -s $_ } ); }
}

