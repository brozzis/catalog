#!/bin/bash
#
# stefano, febbraio 2003
#
gdialog --yesno "un nuovo cd??" 20 20
RES=$?

# vecchio
[ $RES == 247 ] && {
echo -n "dialog --menu stefano 18 60 12 " >/tmp/zumba
psql -Pfieldsep=' ' -Precordsep=' ' -A -t -c "select id||' \"'||medium||'\"' from media" image >>/tmp/zumba
sh /tmp/zumba > /tmp/res 2>&1
[ $? == 0 ] || {
	echo "errore nella scelta del vecchio supporto. esco"
	exit
}

MIT=`cat /tmp/res`
    # cancellare vecchio contenuto
    gdialog --yesno "cancello i vecchi dati?" 20 20
    [ $? == 248 ] || exit
    psql image -c "delete from images where mit=$MIT"
    psql image -c "update media set data = now() where id=$MIT"
    sh catimg.sh $MIT
}

# nuovo
[ $RES == 248 ] && {
    NOME=`gdialog --inputbox "nome del medium" 20 20 2>&1` 
    TIPO=`gdialog --menu "tipo del supporto" 20 20 15 1 cdrom 2 cdrw 3 hd 4 zip 2>&1`
    psql image -c "insert into media (medium, mt, data ) values ('$NOME','$TIPO',now());" | cut -c8-13 > /tmp/res
    MIT=`cat /tmp/res`
    psql image -Pfieldsep=' ' -Precordsep=' ' -A -t -c "select id from media where oid=$MIT" > /tmp/res
    MIT=`cat /tmp/res`
    psql image -c "select * from media" 
    sh catimg.sh $MIT
}

