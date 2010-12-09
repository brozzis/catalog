
select file from indonesia where type=0 and file not in (select file from indonesia where type=1);
update indonesia set md5=md5(concat(file,size));
select file from indonesia where type=0 and md5 not in (select md5 from indonesia where type=1);

