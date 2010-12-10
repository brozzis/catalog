#!/bin/sh

[ -f /tmp/opt1 ] && ( /bin/rm /tmp/opt1 || exit )


gdialog --inputbox "directory di ricerca" 8 40 "/mnt/cdrom" > /tmp/opt1 2>&1 
# codice di errroe diverso da quello indicato da man page
[ $? == 251 ] || {
  echo "nessuna directory scelta"
  exit
}
SRCDIR=`cat /tmp/opt1`
[ -d $SRCDIR ] || {
   echo "directory non accessibile o non trovata"
   exit
}
echo "directory utilizzata: $SRCDIR"

[ -n "$1" ] && {
	LABEL=$1
}

[ -n "$1" ] || {
  gdialog --inputbox "label" 8 40 "*label*" > /tmp/opt1 2>&1 
  [ $? == 251 ] || {
    echo "nessuna label scelta"
    exit
  }
  LABEL=`cat /tmp/opt1`
}

[ -n "$LABEL" ] || {
    echo "devi indicare un LABEL per catalogare il cd!!"
    exit
}
echo "variabile inserita: [$LABEL]"

/bin/rm -f /tmp/list.files

echo $SRCDIR

#    -iname \*.xcf -o \

if [ -s $SRCDIR/index.md5 ] 
then
    ln -sf $SRCDIR/index.md5 /tmp/list.files
else

# memo>   find $SRCDIR \( -type f  \
# memo>     -iname \*.jpg -o \
# memo>     -iname \*.tif -o \
# memo>     -iname \*.bmp \) \
# memo>     -a ! \( -path \*.xvpics\* -o path \*mini\* \) -print0 | xargs -0 md5sum > /tmp/list.files

  find $SRCDIR \( -type f  \
    -iname \*.jpg -o \
    -iname \*.tif -o \
    -iname \*.bmp \) \
     -print0 | xargs -0 md5sum > /tmp/list.files

fi


NUM=`wc -l /tmp/list.files`
echo "ci sono : $NUM files in corso di catalogazione"
    
[ -s /tmp/list.files ] || { 
    echo "probabilmente directory non accessibile"
    echo "forse il cd non è montato ???"
    exit
}

perl catter.pl $LABEL | psql image

#perl -ne 'printf ("insert into images (name, md5, medium) values ".
#    "(%s,''%s'', "'.$LABEL.'")\n", $2, $1) if (m/(\S+)\s+(.+)/)' /tmp/list.files 


#
# deve essere lanciato dall'utente postgres, ora
#
for i in `cut -c35- /tmp/list.files`
do
  convert -size 120x120 "$i" -resize 120x120 +profile '*' /tmp/thumb.jpg 
  # echo  "insert into images (name, md5, medium) values ('$i','$MD5', '$1');" | psql image
  echo  "update images set thumbnail=lo_import('/tmp/thumb.jpg') where mit=$LABEL and name='$i'" | psql image
done

/bin/rm -f /tmp/list.files
