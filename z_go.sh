
perl -w z.pl > md5
sort md5 | cut -c-32 | uniq -d > doppi
for i in $(cat doppi) 
do 
	echo
	grep ^${i} md5 | cut -c34-
done 
