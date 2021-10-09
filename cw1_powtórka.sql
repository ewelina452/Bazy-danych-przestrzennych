create database firma3;

create schema ksiegowosc;

create table ksiegowosc.pracownicy(ID_pracownika INTEGER PRIMARY KEY NOT NULL, imie VARCHAR(20), nazwisko VARCHAR(20),adres VARCHAR(20), telefon VARCHAR(20));
create table ksiegowosc.godziny (ID_godziny INTEGER PRIMARY KEY, data DATE, liczba_godzin INTEGER NOT NULL, ID_pracownika INTEGER NOT NULL); 
create table ksiegowosc.pensje (ID_pensji INTEGER PRIMARY KEY, stanowisko VARCHAR(20), kwota INTEGER NOT NULL);
create table ksiegowosc.premie (ID_premii INTEGER PRIMARY KEY, rodzaj VARCHAR(20), kwota MONEY);
create table ksiegowosc.wynagrodzenie (ID_wynagrodzenia INTEGER PRIMARY KEY, data DATE, ID_pracownika INTEGER, ID_godziny INTEGER, ID_pensji INTEGER, ID_premii INTEGER);


drop table ksiegowosc.pracownicy 

ALTER TABLE ksiegowosc.godziny ADD FOREIGN KEY (ID_pracownika) REFERENCES ksiegowosc.pracownicy(ID_pracownika);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_pracownika) REFERENCES ksiegowosc.pracownicy (ID_pracownika);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_godziny) REFERENCES ksiegowosc.godziny (ID_godziny);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_pensji) REFERENCES ksiegowosc.pensje(ID_pensji);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_premii) REFERENCES ksiegowosc.premie(ID_premii);

ALTER TABLE ksiegowosc.godziny ADD FOREIGN KEY (ID_pracownika) REFERENCES ksiegowosc.pracownicy (ID_pracownika);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_pracownika) REFERENCES ksiegowosc.pracownicy (ID_pracownika);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_godziny) REFERENCES ksiegowosc.godziny (ID_godziny);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_pensji) REFERENCES ksiegowosc.pensje(ID_pensji);
ALTER TABLE ksiegowosc.wynagrodzenie ADD FOREIGN KEY (ID_premii) REFERENCES ksiegowosc.premie(ID_premii);

EXEC sys.sp_addextendedproperty 
@name=N'Comment', 
@value=N'Tabela zawiera dane pracowników',
@level0type=N'SCHEMA', @level0name='ksiegowosc',
@level1type=N'TABLE', @level1name='pracownicy'
GO

INSERT INTO ksiegowosc.pracownicy VALUES (1,'Anna','Nowak', 'Kraków', 567989654);
INSERT INTO ksiegowosc.pracownicy VALUES (2,'Krzysztof','Kowalski', 'Warszawa' , 534213567);
INSERT INTO ksiegowosc.pracownicy VALUES(3,'Natalia','Sokó³','Gdañsk',789543234);
INSERT INTO ksiegowosc.pracownicy VALUES(4,'Agnieszka', 'Sowa','Zakopane',789654235);
INSERT INTO ksiegowosc.pracownicy VALUES(5,'Rafa³','Adamczyk','Wieliczka',567890432);
INSERT INTO ksiegowosc.pracownicy VALUES(6,'Piotr','Kula','Bochnia',765348765);
INSERT INTO ksiegowosc.pracownicy VALUES(7,'Magdalena','Krawczyk','Gdynia',765234678);
INSERT INTO ksiegowosc.pracownicy VALUES(8,'Weronika','Zieliñska','Andrychów',654234154);
INSERT INTO ksiegowosc.pracownicy VALUES(9,'Beata','Drabek','Lublin',768983236);
INSERT INTO ksiegowosc.pracownicy VALUES(10,'Józef','Kowalczyk','Opole',765287598);


INSERT INTO ksiegowosc.godziny VALUES(1,'2021-02-01',161,2);
INSERT INTO ksiegowosc.godziny VAlUES(2,'2021-03-03',162,1);
INSERT INTO ksiegowosc.godziny VALUES(3,'2021-05-02',170,5);
INSERT INTO ksiegowosc.godziny VALUES(4,'2021-08-02',160,7);
INSERT INTO ksiegowosc.godziny VALUES(5,'2021-12-04',169,3);
INSERT INTO ksiegowosc.godziny VALUES(6,'2021-02-20',169,6);
INSERT INTO ksiegowosc.godziny VALUES(7,'2021-02-25',168,10);
INSERT INTO ksiegowosc.godziny VALUES(8,'2021-02-28',160,9);
INSERT INTO ksiegowosc.godziny VALUES(9,'2021-03-02',164,4);
INSERT INTO ksiegowosc.godziny VALUES(10,'2021-03-05',160,8);


INSERT INTO ksiegowosc.pensje VALUES (1,'prezes', 10000);
INSERT INTO ksiegowosc.pensje VALUES (2,'dyrektor', 7000);
INSERT INTO ksiegowosc.pensje VALUES (3,'zastêpca dyrektora', 6000);
INSERT INTO ksiegowosc.pensje VALUES (4,'menad¿er',6000);
INSERT INTO ksiegowosc.pensje VALUES (5,'menad¿er',6000);
INSERT INTO ksiegowosc.pensje VALUES (6,'m³odszy ksiêgowy',5000);
INSERT INTO ksiegowosc.pensje VALUES (7, 'sekretarka',2800);
INSERT INTO ksiegowosc.pensje VALUES (8,'kierownik zespo³u',8000);
INSERT INTO ksiegowosc.pensje VALUES (9,'informatyk',7500);
INSERT INTO ksiegowosc.pensje VALUES (10,'informatyk',7000);


INSERT INTO ksiegowosc.premie VALUES(1,'œwi¹teczna',500);
INSERT INTO ksiegowosc.premie VALUES(2,'nadgodziny',700);
INSERT INTO ksiegowosc.premie VALUES(3,'jubileusz',2000);
INSERT INTO ksiegowosc.premie VALUES(4,'projektowa',1000);
INSERT INTO ksiegowosc.premie VALUES(5,'roczna',1000);
INSERT INTO ksiegowosc.premie VALUES(6,'bezwypadkowa',500);
INSERT INTO ksiegowosc.premie VALUES(7,'okolicznoœciowa',500);
INSERT INTO ksiegowosc.premie VALUES(8,'urodzinowa',600);
INSERT INTO ksiegowosc.premie VALUES(9,'kwartalna',300);
INSERT INTO ksiegowosc.premie VALUES(10,'wyniki_sprzeda¿y',500);

INSERT INTO ksiegowosc.wynagrodzenie VALUES (1,'2021-02-02',2,4,10,NULL);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (2,'2021-02-04',3,5,1,4);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (3,'2021-02-07',5,2,9,1);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (4,'2021-02-10',7,6,7,7);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (5,'2021-02-15',4,1,6,9);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (6,'2021-02-17',1,3,2,3);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (7,'2021-02-19',6,7,3,10);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (8,'2021-02-23',9,9,4,5);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (9,'2021-02-25',8,10,8,8);
INSERT INTO ksiegowosc.wynagrodzenie VALUES (10,'2021-02-27',10,8,5,6);

--6a

select ID_pracownika, nazwisko from ksiegowosc.pracownicy;

--b

select ID_pracownika, kwota from ksiegowosc.wynagrodzenie, ksiegowosc.pensje where kwota>1000 and ksiegowosc.wynagrodzenie.ID_pensji=ksiegowosc.pensje.ID_pensji;

--c

select ID_pracownika, kwota, ID_premii from ksiegowosc.wynagrodzenie, ksiegowosc.pensje where ksiegowosc.wynagrodzenie.ID_pensji=ksiegowosc.pensje.ID_pensji and ksiegowosc.wynagrodzenie.ID_premii is NULL and kwota>2000; 

--d

select imie, nazwisko from ksiegowosc.pracownicy where imie like 'j%';

--e
select imie, nazwisko from ksiegowosc.pracownicy where nazwisko like '%n%' and imie like '%a';

--f

select  imie, nazwisko, liczba_godzin-160  as nadgodziny from ksiegowosc.pracownicy, ksiegowosc.godziny where ksiegowosc.pracownicy.ID_pracownika=ksiegowosc.godziny.ID_pracownika;

--g 
select imie, nazwisko, kwota from ksiegowosc.pracownicy,ksiegowosc.pensje, ksiegowosc.wynagrodzenie where ksiegowosc.pensje.ID_pensji=ksiegowosc.wynagrodzenie.ID_pensji AND ksiegowosc.pracownicy.ID_pracownika=ksiegowosc.wynagrodzenie.ID_pracownika and kwota > 1500 and kwota <3000;

--h
select imie, nazwisko, liczba_godzin-160 as nadgodziny from ksiegowosc.wynagrodzenie,ksiegowosc.pracownicy,ksiegowosc.godziny
where ksiegowosc.pracownicy.ID_pracownika=ksiegowosc.godziny.ID_pracownika and 
ksiegowosc.wynagrodzenie.ID_pracownika=ksiegowosc.pracownicy.ID_pracownika and liczba_godzin-160 >0 and wynagrodzenie.ID_premii is null; 

--i
select imie, nazwisko , kwota from ksiegowosc.wynagrodzenie, ksiegowosc.pracownicy, ksiegowosc.pensje
where ksiegowosc.wynagrodzenie.ID_pracownika=ksiegowosc.pracownicy.ID_pracownika and ksiegowosc.pensje.ID_pensji=ksiegowosc.wynagrodzenie.ID_pensji order by kwota desc;

--j
select imie, nazwisko, premie.kwota, pensje.kwota from ksiegowosc.premie, ksiegowosc.wynagrodzenie, ksiegowosc.pracownicy, ksiegowosc.pensje
where ksiegowosc.wynagrodzenie.ID_premii=ksiegowosc.premie.ID_premii and ksiegowosc.wynagrodzenie.ID_pracownika=ksiegowosc.pracownicy.ID_pracownika and ksiegowosc.pensje.ID_pensji=ksiegowosc.wynagrodzenie.ID_pensji order by pensje.kwota desc , premie.kwota desc;

--k
select stanowisko, count(stanowisko) as liczba from ksiegowosc.pensje group by stanowisko;

--l
select stanowisko, AVG(kwota) as avg, min(kwota) as min, max(kwota) as max from ksiegowosc.pensje where stanowisko='informatyk' group by stanowisko;

--m
select sum(kwota) as suma from ksiegowosc.pensje;

--n
select stanowisko, count(stanowisko)as liczba_stanowisk, sum(kwota) as suma from ksiegowosc.pensje group by stanowisko;

--o
select stanowisko, count(stanowisko), count(ksiegowosc.pensje.kwota) as liczba_premii from ksiegowosc.pensje group by stanowisko;

--p
select imie, nazwisko, kwota from ksiegowosc.pracownicy, ksiegowosc.wynagrodzenie, ksiegowosc.pensje
where ksiegowosc.pracownicy.ID_pracownika=ksiegowosc.wynagrodzenie.ID_pracownika AND ksiegowosc.wynagrodzenie.ID_pensji= ksiegowosc.pensje.ID_pensji
delete from ksiegowosc.pensje where kwota<3000



SELECT*FROM ksiegowosc.pensje;