############
#
# GRUPA A
#
############
1.
SELECT nazwa, ceil(dlugosc/60.0) AS czAS
    FROM utwory
    WHERE dlugosc BETWEEN 60 AND 300
    ORDER BY nazwa ASC, czAS DESC;

2.
-- nie skoczyli
(SELECT idwykonawcy
    FROM wykonawcy
    WHERE data_zakonczenia IS NULL)
INTERSECT
-- maja album w listopadzie
(SELECT idwykonawcy
    FROM albumy
    WHERE date_part('month', data_wydania) = 11);

3.
SELECT DISTINCT gatunek
    FROM albumy
    JOIN utwory     USING (idalbumu)
    JOIN zawartosc  USING (idutworu)
    JOIN playlisty  USING (idplaylisty)
    JOIN klienci    USING (idklienta)
    WHERE data_rejstracji = (SELECT data_urodzenia FROM klienci WHERE login = "jim");

4.
with x AS (
    (SELECT idutworu
        FROM klienci
        NATURAL JOIN playlisty
        NATURAL JOIN zawartosc
        WHERE login = 'kamila')
    EXCEPT
    (selet idutworu 
        FROM klienci
        JOIN oceny
        WHERE login = 'kamila')
)

SELECT nazwa, coalesce(AVG(lubi::INT), 0.5)
    FROM utwory
    LEFT JOIN oceny USING(idutworu)
    WHERE idutworu IN x
    GROUP BY nazwa, idutworu;

5.
UPDATE zawartosc z
    SET idplaylisty = 30
    FROM utwory u
    WHERE
        z.idutworu = u.idutworu
        AND z.idplaylisty = 20
        AND u.dlugosc < 30
        AND z.idutworu NOT IN (SELECT idutworu FROM oceny)


############
#
# GRUPA B
#
############

1.
SELECT nazwa, floor(dlugosc/60.0) AS Czas
    FROM utwory
    WHERE dlugosc BETWEEN 120 AND 600
    ORDER BY nazwa DESC, Czas ASC;

2.
(SELECT idwykonawcow
    FROM wykonawcy
    WHERE data_zakonczenia IS NOT NULL)
UNION
(SELECT idwykonawcow
    FROM albumy
    WHERE date_part('month', data_wydania) = 12); 

3.
SELECT DISTINCT gatunek
    FROM albumy
    JOIN utwory     USING (idalbumu)
    JOIN zawartosc  USING (idalbumu)
    JOIN playlisty  USING (idplaylisty)
    JOIN klienci    USING (idklienta)
    WHERE data_urodzenia = (SELECT data_rejstracji FROM klienci WHERE login = "jim");

4.
with x AS (
    SELECT idutworu 
        FROM klienci 
        JOIN playlisty USING(idklienta)
        JOIN zawartosc USING(idplaylisty)
        WHERE
        login = 'kamila')

SELECT nazwa, coalesce(AVG(lubi::INT), 0.5)
    FROM utwory
    LEFT JOIN oceny USING(idutworu) 
    WHERE idutworu NOT IN x
    GROUP BY nazwa, idutworu;

5.
INSERT INTO playlisty(idplaylisty, idklienta, nazwa)
values( 30, (SELECT idklienta FROM playlisty WHERE idplaylisty = 20), 'kopiapopu')

INSERT INTO zawartosc(idplaylisty, idutworu)
SELECT 30, idutworu FROM zawartosc WHERE idplaylisty = 20;