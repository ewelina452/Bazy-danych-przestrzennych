
--zad1
select*from trees;
select sum(area_km2) from trees where vegdesc='Mixed Trees';
select sum(ST_Area(trees.geom)) from trees where vegdesc='Mixed Trees';

--zad2
select trees.geom from trees where vegdesc='Mixed Trees';
select trees.geom from trees where vegdesc='Evergreen';
select trees.geom from trees where vegdesc='Deciduous';

--zad3
select*from railroads;
select*from regions;

select sum(ST_Length(railroads.geom)) from regions,railroads where ST_Contains(regions.geom, railroads.geom)=true and name_2 = 'Matanuska-Susitna';

--zad4
select*from airports;

select avg(elev), count(name) as liczba from airports where use='Military' ;
delete from airports where use='Military' and elev>1400;
select count(name) as liczba from airports where use='Military' and elev>1400;

--5
select*from popp
select*from rivers;
select*from regions;

select popp.geom from popp, regions where ST_Contains(regions.geom,popp.geom) and name_2='Bristol Bay' and f_codedesc='Building';
select count(popp.geom) from popp, regions where ST_Contains(regions.geom,popp.geom) and name_2='Bristol Bay' and f_codedesc='Building';
select popp.geom from popp, rivers, regions where ST_Contains(regions.geom,popp.geom)=true and name_2='Bristol Bay'  and popp.f_codedesc='Building' and ST_Distance(popp.geom,rivers.geom)<=100000;


--6
select Sum(ST_nPoints(ST_Intersection(majrivers.geom,railroads.geom))) as przeciecia from majrivers,railroads where ST_Intersects(majrivers.geom,railroads.geom);

--7

select ST_DumpPoints(railroads.geom) from railroads;

--8
select * from airports;
select * from railroads;



select ST_Intersection(ST_Difference(ST_union(ST_buffer(airports.geom,328083)),st_union(ST_buffer(railroads.geom,164041))),ST_union(ST_buffer(trails.geom,6561))) from airports, railroads,trails;

select ST_Intersection(ST_Difference(ST_buffer(airports.geom,328083),ST_buffer(railroads.geom,164041)),ST_buffer(trails.geom,6561)) from airports,railroads,trails;


--9
select SUM(ST_nPoints(swamp.geom)), SUM(swamp.areakm2) as sum_pole from swamp;