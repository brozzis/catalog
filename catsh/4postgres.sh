#!/bin/sh
#
# come utente postgres
#

SRCDIR=/mnt/cdrom
LABEL=28

  find $SRCDIR \( -type f  \
    -iname \*.jpg -o \
    -iname \*.tif -o \
    -iname \*.bmp \)  > /tmp/list.files

for i in `cat /tmp/list.files`
do
  convert -size 120x120 "$i" -resize 120x120 +profile '*' /tmp/thumb.jpg 
  # echo  "insert into images (name, md5, medium) values ('$i','$MD5', '$1');" | psql image
  echo  "update images set thumbnail=lo_import('/tmp/thumb.jpg') where mit=$LABEL and name='$i'" | psql image
done

/bin/rm -f /tmp/list.files
