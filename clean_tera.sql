delete from tera where f like '.%' and size = 4096; 
delete from tera where f = '.DS_Store';
update tera set hash=md5(concat(size,f)) where hash is null;
-- 
update tera set flag_movie=true where size > 500000 and (f like '%.avi' or f like '%.wvm' or f like '%.mpg' or f like '%.mpeg');

