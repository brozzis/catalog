select * from images i where md5 in (select md5 from images i1 where i.id <> i1.id);
