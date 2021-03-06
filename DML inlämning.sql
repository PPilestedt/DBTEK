-- Lista antalet produkter per kategori. Listningen ska innehålla kategori-namn och antalet produkter.

select modell.namn, count(modell.namn) as antal from modell
join typ on modell.id = typ.modellid
join sko on typ.nr = sko.typnr
group by modell.namn;


-- Skapa en kundlista med den totala summan pengar som varje kund har handlat för. Kundens
-- för- och efternamn, samt det totala värdet som varje person har shoppats för, skall visas.

SELECT kund.förnamn, kund.efternamn, sum(sko.pris) as summa
FROM kund
INNER JOIN beställning
ON beställning.kundid = kund.id
INNER JOIN shoppinglista
ON shoppinglista.beställningsid = beställning.id
INNER JOIN sko
ON shoppinglista.skoid = sko.id
GROUP BY kund.id;


-- Vilka kunder har köpt blåa sportskor med storlek 38 av märket Nike? Lista deras namn.

SELECT kund.förnamn, kund.efternamn
FROM kund
INNER JOIN beställning
ON kund.id = beställning.kundid
INNER JOIN shoppinglista
ON shoppinglista.beställningsid = beställning.id
INNER JOIN sko
ON shoppinglista.skoid = sko.id
WHERE sko.id = 2;

-- Skriv ut en lista på det totala beställningsvärdet per ort där beställningsvärdet är större än 1000 kr. 
-- Ortnamn och värde ska visas. (det måste finnas orter i databasen där det har
-- handlats för mindre än 1000 kr för att visa att frågan är korrekt formulerad)

SELECT kund.ort, sum(sko.pris) as summa
FROM kund
INNER JOIN beställning
ON kund.id = beställning.kundid
INNER JOIN shoppinglista
ON shoppinglista.beställningsid = beställning.id
INNER JOIN sko
ON shoppinglista.skoid = sko.id
GROUP BY kund.ort
HAVING summa > 1000;

-- Skapa en topp-5 lista av de mest sålda produkterna.

SELECT sko.id as sko, märke.namn as märke, sko.färg, count(sko.id) as antal
FROM sko
INNER JOIN shoppinglista
ON shoppinglista.skoid = sko.id
INNER JOIN märke
ON sko.märkesid = märke.id
GROUP BY sko.id
ORDER BY antal desc
LIMIT 5;

-- Vilken månad hade du den största försäljningen? (det måste finnas data som anger försäljning 
-- för mer än en månad i databasen för att visa att frågan är korrekt formulerad)

SELECT MONTH(beställning.created) as månad, sum(sko.pris) as summa
FROM beställning
INNER JOIN shoppinglista
ON shoppinglista.beställningsid = beställning.id 
INNER JOIN sko
ON shoppinglista.skoid = sko.id
GROUP BY månad
ORDER BY summa desc
LIMIT 1;
