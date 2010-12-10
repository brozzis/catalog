
drop view images;
create view  images as 
SELECT i.id, i.name, i.md5, i.mit, t.bytes, i.data, t.d1, t.d2, t.camera, i.dir, i.fname, t.thumbnail FROM (img_table i LEFT JOIN thumbs t ON ((i.id_thumb = t.id)));
