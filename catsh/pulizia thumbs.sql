update thumbs set del=true where thumbs.thumbnail is null and exists (select * from thumbs t1 where thumbs.md5=t1.md5 and thumbnail is not null);

update thumbs set del=true where exists (select * from thumbs t1 where thumbs.md5=t1.md5 and thumbnail <> t1.thumbnail);

create table t as select distinct md5 from thumbs;

update t set thumbnail = (select thumbnail from thumbs where md5=t.md5 and thumbnail is not null limit 1);


BEGIN WORK;
DECLARE liahona CURSOR FOR SELECT * FROM films;

-- Fetch first 5 rows in the cursor liahona:
FETCH FORWARD 5 IN liahona;

 code  |          title          | did | date_prod  |  kind    | len
-------+-------------------------+-----+------------+----------+-------
 BL101 | The Third Man           | 101 | 1949-12-23 | Drama    | 01:44
 BL102 | The African Queen       | 101 | 1951-08-11 | Romantic | 01:43
 JL201 | Une Femme est une Femme | 102 | 1961-03-12 | Romantic | 01:25
 P_301 | Vertigo                 | 103 | 1958-11-14 | Action   | 02:08
 P_302 | Becket                  | 103 | 1964-02-03 | Drama    | 02:28

-- Fetch previous row:
FETCH BACKWARD 1 IN liahona;

 code  | title   | did | date_prod  | kind   | len
-------+---------+-----+------------+--------+-------
 P_301 | Vertigo | 103 | 1958-11-14 | Action | 02:08

-- close the cursor and commit work:

CLOSE liahona;
COMMIT WORK;


declare xx cursor for select md5 from t;
fetch forward 
