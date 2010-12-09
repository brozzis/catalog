
gzip -cd ind | grep CR2 | perl -ne 'print qq(insert into indonesia (file,size,type) values ("$2", $1 ,1);\n) if (m/\S+\s+\S+\s+\S+\s+\S+\s+(\d+)\s+\S+\s+\S+\s+\S+\s+(\S+)/)' | mysql -pste ste 
gzip -cd ind2 | grep CR2 | perl -ne 'print qq(insert into indonesia (file,size,type) values ("$2", $1 ,0);\n) if (m/\S+\s+\S+\s+\S+\s+\S+\s+(\d+)\s+\S+\s+\S+\s+\S+\s+(\S+)/)' | mysql -pste ste 

# se 1>0
# echo " select file from indonesia where type=0 and file not in (select file from indonesia where type=1);" | mysql -pste ste 

mysql -pste ste < check.sql
