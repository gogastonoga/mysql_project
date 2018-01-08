#SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

# A) Pracownicy o wieku wiekszym niz 25 lat
SELECT * 
FROM worker 
WHERE TIMESTAMPDIFF(YEAR, date_birth, NOW()) > 25; 


# B) Pracownicy o nazwisku dlyzszym niz 7 znakow
SELECT * 
FROM worker 
WHERE LENGTH(surname) > 7;


# C) Pracownicy o nazwisku z druga litera A
SELECT * 
FROM worker 
WHERE surname LIKE '_A%' COLLATE utf8_bin;


# D) Samochody z najwiekszym przebiegiem
SELECT * 
FROM car 
ORDER BY mileage DESC;


# E) Ilosc samochodow ktorych przebieg zawiera sie w przedziale 200000 km a 300000 km
SELECT COUNT(mileage) 
FROM car 
WHERE mileage > 200000 AND mileage < 300000;


# F) Pracownicy ktorzy sa kierownikami
SELECT * 
FROM worker 
WHERE position_id = 2;


# G) Klienci z najwieksza liczba wypozyczen
SELECT r.client_id, client.name, client.surname, count(r.client_id) AS count 
FROM rent as r 
JOIN client ON r.client_id = client.id 
GROUP BY r.client_id 
HAVING count = 
	(SELECT * FROM client_counter);
                



# H) Klienci, ktorzy wypozyczyli najwieksza liczbe roznych samochodow
SELECT r.client_id, client.name, client.surname, COUNT(DISTINCT r.client_id, r.car_id) as count
FROM rent as r 
JOIN client ON r.client_id = client.id
GROUP BY r.client_id
HAVING count = 
	(SELECT max(clients.count)
		FROM
			(SELECT count(DISTINCT r.client_id, r.car_id) AS count
				FROM rent AS r 
				GROUP BY r.client_id) AS clients
		);


# I) Samochody najczesciej wypozyczane
SELECT r.car_id, car.make, car.type, count(r.car_id)  as count
FROM rent as r 
JOIN car ON r.car_id = car.id 
GROUP BY r.car_id
ORDER BY count DESC
LIMIT 4;


# J) Klienci, ktorzy zaplacili najwiecej za wypozyczenia samochodu w roku 2017
SELECT r.client_id, client.name, client.surname, ROUND(SUM(r.cost), 2) as sum
FROM rent as r
JOIN client ON client.id = r.client_id AND YEAR(r.date_rent) = 2017
GROUP BY r.client_id
ORDER BY sum DESC
LIMIT 5; 


# K) Klienci, ktorzy wypozyczyli samochod o ID = 85 w przedziale czasowym od 10. do 16. marca
SELECT client.name, client.surname, r.car_id, r.date_rent, r.date_return
FROM rent as r
JOIN client ON (r.date_rent BETWEEN '2016-03-10' AND '2016-03-16') AND r.car_id = 85 AND r.client_id = client.id;


# L) Aktualizacja koloru samochodu
UPDATE car SET color = 'Pink' WHERE id = 1;


# M) Klienci majacy najwiecej wypozyczen z roznym miejscem odbioru i oddania samochodu
SELECT r.client_id, client.name, client.surname, count(r.client_ID) as count 
FROM rent as r 
JOIN client ON client.id = r.client_id
GROUP BY r.client_id
HAVING count = 
	(SELECT max(clients.count)
		FROM
			(SELECT count(r.client_id) as count
			FROM rent as r
            WHERE r.agency_from_id != r.agency_to_id
            GROUP BY r.client_id) as clients
            );


# O) Domena, w ktorej klienci maja najczesciej email
SELECT substring_index(email, '@', -1) domain, COUNT(email) AS count
FROM client
GROUP BY substring_index(email, '@', -1)
HAVING count = 
	(SELECT max(email.count)
		FROM 
			(SELECT COUNT(email) AS count
				FROM client 
              GROUP BY substring_index(email, '@', -1)) AS email
			);

# P) Samochody, ktore maja co najmniej dwoch opiekunow
SELECT r.car_id, car.make, car.type, count(r.car_ID) as carers 
FROM carer as r 
JOIN car ON car.id = r.car_id 
GROUP BY r.car_id 
HAVING carers > 1;


# R) Pracownicy, ktorzy nie opiekuja sie zadnym samochodem
SELECT worker.id, worker.name, worker.surname, c.worker_id 
FROM carer as c
RIGHT JOIN worker ON worker.id = c.worker_id 
WHERE c.worker_id is null;