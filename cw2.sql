create database cw1;

Create extension postgis;

create table buildings (id INT PRIMARY KEY, geometry geometry  NOT NULL, name varchar(20));
create table roads (id INT PRIMARY KEY, geometry geometry NOT NULL, name varchar(20));
create table poi (id INT PRIMARY KEY, geometry geometry NOT NULL, name varchar(20));
drop table roads;
drop table buildings;
drop table poi;

insert into buildings (id, geometry, name) values (1,ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))',0),'BuildingA');
insert into buildings (id, geometry, name) values (2,ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))',0),'BuildingB');
insert into buildings (id, geometry, name) values (3,ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))',0),'BuildingC');
insert into buildings (id, geometry, name) values (4,ST_GeomFromText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))',0),'BuildingD');
insert into buildings (id, geometry, name) values (5,ST_GeomFromText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))',0),'BuildingF');



insert into roads (id, geometry,name) values (1,ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'RoadX');
insert into roads (id, geometry,name) values (2,ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)',0),'RoadY');



insert into poi (id, geometry, name) values (1, ST_GeomFromText('POINT(1 3.5)',0),'G');
insert into poi (id, geometry, name) values (2, ST_GeomFromText('POINT(5.5 1.5)',0),'H');
insert into poi (id, geometry, name) values (3, ST_GeomFromText('POINT(9.5 6)',0),'I');
insert into poi (id, geometry, name) values (4, ST_GeomFromText('POINT(6.5 6)',0),'J');
insert into poi (id, geometry, name) values (5, ST_GeomFromText('POINT(6 9.5)',0),'K');

select * from buildings;
select * from roads;
select*from poi;

--6a
select (select  ST_Length(roads.geometry) as dlugosc from roads where name='RoadY') + 
( select ST_Length(roads.geometry) as dlugosc from roads where name='RoadX') as dlugosc_calkowita; 

--6b

select name, ST_AsText(geometry), ST_Area(geometry) as pole, ST_Perimeter(geometry) as obwód from buildings where name='BuildingA';

--6c

select name, ST_Area(geometry) as pole from buildings order by name asc;

--6d

select name, ST_Perimeter(geometry) as obwod, ST_Area(geometry) as pole from buildings order by pole desc limit 2;

--6e
select ST_Distance(buildings.geometry, poi.geometry) as najkrótsza_odl from buildings, poi where poi.name = 'G' and buildings.name= 'BuildingC';

select ST_ShortestLine(buildings.geometry, poi.geometry) as najkrótsza_odl 
from buildings, poi where poi.name = 'G' and buildings.name= 'BuildingC' union select buildings.geometry from buildings 
where name= 'BuildingC' union select poi.geometry from poi where name='G';


 
--6f 

select ST_Area(ST_Difference((select buildings.geometry from buildings where name='BuildingC'),ST_buffer((select buildings.geometry from buildings where name ='BuildingB'),0.5)));

--6g

select buildings.name, ST_Centroid(buildings.geometry) as centroid from buildings, roads 
where ST_Y(ST_Centroid(buildings.geometry))> ST_Y(ST_Centroid(roads.geometry)) and roads.name='RoadX';

--6h


select ((select ST_Area(ST_Difference(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0),buildings.geometry)))
		+ (select ST_Area(ST_Difference(buildings.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0))))) as pole from buildings
		where buildings.name='BuildingC' ;

--select geometry from buildings union select geometry from roads union select geometry from poi;