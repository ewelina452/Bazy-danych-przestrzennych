create extension postgis;
--zad1

drop table obiekty;
create table obiekty (id INT PRIMARY KEY, geometry geometry  NOT NULL, name varchar(20));

insert into obiekty(id, geometry, name) values(1, St_GeomFromText('MULTICURVE(LINESTRING(0 1, 1 1), 
CIRCULARSTRING(1 1,2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1),LINESTRING(5 1, 6 1))',0),'obiekt1');

insert into obiekty (id, geometry, name) values 
(2, ST_GeomFromText('MULTICURVE(LINESTRING(10 6, 14 6),CIRCULARSTRING(14 6, 16 4, 14 2),CIRCULARSTRING(14 2,12 0,10 2),LINESTRING(10 2,10 6),CIRCULARSTRING(11 2, 13 2, 11 2))',0),'obiekt2');

insert into obiekty (id, geometry, name) values (3,ST_GeomFromText('POLYGON((7 15, 12 13, 10 17, 7 15))',0 ),'obiekt3');

insert into obiekty (id, geometry, name) values (4,ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21,22 19, 20.5 19.5)',0 ),'obiekt4');

insert into obiekty (id, geometry, name) values (5,ST_GeomFromText('MULTIPOINTM(30 30 59, 38 32 234)',0),'obiekt5');

insert into obiekty (id, geometry, name) values (6,ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))',0),'obiekt6');


SELECT id, ST_CurveToLine(obiekty.geometry), name FROM obiekty;

--zad2 Wyznacz pole powierzchni bufora o wielkości 5 jednostek,
--który został utworzony wokół najkrótszej linii łączącej obiekt 3 i 4.

select ST_Area(ST_buffer(ST_ShortestLine(obiekt3.geometry,obiekt4.geometry),5))
from obiekty obiekt3,obiekty obiekt4 where obiekt3.name = 'obiekt3' and obiekt4.name = 'obiekt4';

--zad3 Zamień obiekt4 na poligon. 
--Jaki warunek musi być spełniony, aby można było wykonać to zadanie? Zapewnij te warunki.

SELECT ST_MakePolygon(ST_LineMerge(ST_CollectionExtract(ST_Collect(obiekty.geometry, 'LINESTRING(20.5 19.5 , 20 20)'), 2)))
FROM obiekty WHERE name = 'obiekt4';

--zad4 W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu 3 i obiektu 4.

insert into obiekty (id, geometry, name) 
values (7,(select ST_Collect(obiekt3.geometry, obiekt4.geometry) from obiekty obiekt3, obiekty obiekt4 
where obiekt3.name = 'obiekt3' and obiekt4.name = 'obiekt4'),'obiekt7');
		   
SELECT id, ST_CurveToLine(obiekty.geometry), name FROM obiekty;

--zad5 Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek,
--które zostały utworzone wokół obiektów nie zawierających łuków.

select name, ST_Area(ST_buffer(obiekty.geometry,5)) from obiekty where ST_HasArc(obiekty.geometry) = false;


select sum(ST_Area(ST_buffer(obiekty.geometry,5))) from obiekty where ST_HasArc(obiekty.geometry) = false;



