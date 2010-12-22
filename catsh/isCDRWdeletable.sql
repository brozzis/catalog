
--
-- verifica che tutto quello che si trova sul cd è presente anche altrove
--
SELECT * from images i where mit=13 and exists (select q.md5 from quantity q where count=1 and q.md5=i.md5);
