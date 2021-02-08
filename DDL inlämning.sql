drop table if exists shoppinglista;
drop table if exists betyg;
drop table if exists sko;
drop table if exists beställning;
drop table if exists typ;
drop table if exists kund;
drop table if exists märke;
drop table if exists modell;

create table if not exists märke(
id int not null auto_increment,
primary key (id),
namn varchar(50) not null,
created timestamp default current_timestamp,
lastupdated timestamp default current_timestamp on update current_timestamp
);

insert into märke(namn) value
('Underground'),
('Converse'),
('Nike'),
('Prada'),
('Ecco');

create table if not exists modell
(id int not null auto_increment,
namn varchar(50) not null,
primary key (id),
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp default CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP);

insert into modell (namn, id) VALUES ('barnsko', 1);
insert into modell (namn, id) VALUES ('klacksko', 2);
insert into modell (namn, id) VALUES ('sportsko', 3);
insert into modell (namn, id) VALUES ('promenadsko', 4);
insert into modell (namn, id) VALUES ('vandringskänga', 5);

create table if not exists kund
(id int not null auto_increment,
primary key (id),
förnamn varchar(50) not null,
efternamn varchar(50) not null,
ort varchar(50) not null,
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp default CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP);

insert into kund (förnamn, efternamn, ort) VALUES ('Agda','Ädla','Spånga');
insert into kund (förnamn, efternamn, ort) VALUES ('Pål','Pålsson','Spånga');
insert into kund (förnamn, efternamn, ort) VALUES ('Jason','Vorhees','Camp Crystal');
insert into kund (förnamn, efternamn, ort) VALUES ('Freddy','Krueger','Springwood');
insert into kund (förnamn, efternamn, ort) VALUES ('Michael','Myers','Haddonfield');
insert into kund (förnamn, efternamn, ort) VALUES ('Nancy','Thompson','Springwood');

create table if not exists typ
(nr int not null,
modellid int,
primary key (nr, modellid),
foreign key (modellid) references modell(id),
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);

insert into typ(nr, modellid) values
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,2),
(6,3),
(7,1),
(7,3),
(8,2),
(8,5);

create table if not exists beställning
(
id int not null auto_increment,
primary key (id),
kundid int,
foreign key (kundid) references kund(id) on delete set null, -- beställningen skall finnas kvar i historiken om kunden tas bort
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

insert into beställning (kundid,created) values
(3,'2020-10-01'),
(3,'2020-10-03'),
(4,'2020-10-20'),
(1,'1998-01-10'),
(5,'2015-12-12'),
(2,'2017-02-23');

create table if not exists sko
(id int not null auto_increment,
primary key (id),
märkesid int not null,
foreign key (märkesid) references märke(id),
färg varchar(20) not null,
storlek int not null,
pris int not null,
typnr int not null,
foreign key (typnr) references typ(nr),
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

insert into sko (märkesid, färg, storlek, pris, typnr) values
(1, 'Svart', 52, 1500, 8),
(3, 'Blå', 38, 800, 3),
(2, 'Blå', 42, 800, 3),
(3, 'Grön', 42, 600, 3),
(4, 'Beige', 35, 900, 3),
(2, 'Röd', 42, 500, 4),
(5, 'Svart', 39, 1000, 7),
(5, 'Brun', 45, 1200, 4);

create table if not exists betyg
(id int not null auto_increment,
poäng int not null,
kommentar varchar(50),
kundid int not null,
skoid int not null,
primary key (id),
foreign key (kundid) references kund(id) on delete cascade, -- om kunden tas bort så skall betyget tas bort för det ska inte finnas anonyma betyg
foreign key (skoid) references sko(id),
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp default CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP);

insert into betyg (kommentar, kundid, skoid, poäng) VALUES ('Tysta skor :)', 3, 2, 40);
insert into betyg (kommentar, kundid, skoid, poäng) VALUES ('Lite dyra...', 4, 1,30);
insert into betyg (kommentar, kundid, skoid, poäng) VALUES ('Usch!', 2, 4, 10);
insert into betyg (kommentar, kundid, skoid, poäng) VALUES ('Fin färg!', 5, 2,20);
insert into betyg (kommentar, kundid, skoid, poäng) VALUES ('Jag har väntat', 1, 5, 10);

create table if not exists shoppinglista
(
id int not null auto_increment,
beställningsid int not null,
skoid int not null,
primary key (id),
foreign key (beställningsid) references beställning(id),
foreign key (skoid) references sko(id),
created timestamp DEFAULT CURRENT_TIMESTAMP,
lastUpdate timestamp default CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP);

insert into shoppinglista (beställningsid, skoid) VALUES (1, 3);
insert into shoppinglista (beställningsid, skoid) VALUES (2, 2);
insert into shoppinglista (beställningsid, skoid) VALUES (4, 5);
insert into shoppinglista (beställningsid, skoid) VALUES (3, 1);
insert into shoppinglista (beställningsid, skoid) VALUES (5, 2);
insert into shoppinglista (beställningsid, skoid) VALUES (6, 4);
insert into shoppinglista (beställningsid, skoid) VALUES (6, 7);

-- index på skofärgen så att det går snabbare att söka på webbshoppen
CREATE INDEX ix_sko_färg ON sko (färg);

-- multi-index på kundernas förnamn och efternamn så att butikspersonalen kan söka efter kunder snabbt
CREATE INDEX ix_kund_namn ON kund(förnamn,efternamn);

-- index på märkesnamn så att det går snabbt att sortera på webbshoppen
Create INDEX ix_märke_namn ON märke(namn);

-- on update cascade har vi valt att inte använda då vi 
-- använder oss av syntetiska id:n som nycklar. 
-- Antingen har vi on update cascade på alla FK eller så ser vi till att inte ändra på ID:n
