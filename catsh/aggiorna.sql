-- $Id :$
--
-- update images set name='/opt/canon/'||name;
-- update images set name = substr(name,1,11)||substr(name,14) ;

--
-- ho cambiato il find, non dovrebbe più mettere le immagini mini
-- 
-- delete from images where name ~* '/mini/';
-- 
delete from img_table where name ~* '/.xvpics/';


--
-- va lanciato a fronte di nuovo inserimento
-- 
-- drop table quantity;
-- vacuum;
--create table quantity (
-- md5 text not null constraint pk_quantity primary key,
-- count int ); 

--insert into quantity SELECT md5, count(*) from img_table group by md5;
--grant all on quantity to stefano;

update thumbs set count = (select count(*) from img_table where thumbs.md5=img_table.md5);



--
-- da lanciare ad ogni modifica della tabella images
-- 
-- drop table stats;
-- create table stats (sd text, val int);
truncate table stats;
INSERT INTO STATS (SD, val) values ('numero di immagini', (select count(*) from img_table));
insert into stats (sd, val) values ('numero di immagini diverse', (select count(distinct md5) from img_table));
insert into stats (sd, val) values ('numero di thumbnail inseriti', (select count(*) from thumbs));
insert into stats (sd, val) values ('numero di immagini senza una copia', (select count(*) from thumbs where count=1));
insert into stats (sd, val) values ('numero dei supporti [logici e fisici]', (select count(*) from media));
insert into stats (sd, val) values ('numero dei supporti CD e CDRW', (select count(*) from media where mt in (1,2)));
insert into stats (sd, val) 
	values ('numero di immagini con informazioni EXIF', (select count(*) from thumbs where exif_width is not null));
insert into stats (sd, val) 
	VALUES ('percentuale di immagini con info EXIF', 
	(select 100*count(id)/(select count(id) from thumbs) from thumbs where exif_width is not null));


-- immagine vuota
-- delete from img_table where md5='d41d8cd98f00b204e9800998ecf8427e';

-- calcola ogni volta il numero di immagini x supporto...
-- sarebbe da gestire applicativamente (data???)
-- aggiunta di now() non verificato!!!
update media set count = (select count(*) from img_table where media.id=img_table.mit) 
	where data= date_trunc('day',now());

-- drop table num_images;
-- create table num_images as select m.id, count(*) from media m, images i where m.id=i.mit group by m.id;
-- grant all on num_images to stefano;

-- per correggere l'errore in inserimento
update img_table set id_thumb = thumbs.id where id_thumb is null and img_table.md5=thumbs.md5;

-- vacuum analyze;

