-- Exploration avec DISTINCT, COUNT et GROUP BY

-- Afficher tableau film : 

SELECT * FROM film;


-- Afficher les notes uniques (rating) des Etats Unis :

SELECT DISTINCT rating FROM film;


-- Compter le nombre des différents rating et rental_rate :

SELECT rating, COUNT(rating) FROM film GROUP BY rating;

SELECT rental_rate, COUNT(rental_rate) 
FROM film 
GROUP BY rental_rate;


-- Ranger dans l’ordre décroissant :

SELECT rating, COUNT(rating) 
FROM film 
GROUP BY rating 
ORDER BY rating desc;


-- Commande EXTRACT

-- Extraire le mois et le nom de la colonne :

SELECT rental_date, COUNT(rental_id) AS total_rentals FROM rental GROUP BY rental_date ORDER BY total_rentals desc;


-- Nombre de location par mois :

SELECT EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date), COUNT(rental_id)
FROM rental
GROUP BY 1, 2;


-- Nombre de location unique par mois et par année et la moyenne de location par client et par mois :

SELECT EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date), COUNT(rental_id), COUNT(DISTINCT customer_id), COUNT(rental_id)/COUNT(DISTINCT customer_id)
FROM rental
GROUP BY 1, 2;


-- Avec la donnée en décimal (pour avoir la virgule) :

SELECT EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date), COUNT(rental_id), COUNT(DISTINCT customer_id), 1.0 * COUNT(rental_id)/COUNT(DISTINCT customer_id)
FROM rental
GROUP BY 1, 2;


-- Exploration avec WHERE

SELECT email
FROM customer
WHERE first_name = 'Gloria' AND last_name = 'Cook';

SELECT title
FROM film
WHERE title = 'texas Watch';

SELECT phone
FROM address
WHERE address = '270 Toulon Boulevard';


-- Commande IN

WHERE colonne IN (valeur1, valeur2, …)

WHERE colonne1 IN (SELECT colonne2 FROM table)

SELECT customer_id, rental_id, return_date
FROM rental
WHERE customer_id IN (1,2)
ORDER BY return_date desc;

SELECT customer_id, rental_id, return_date
FROM rental
WHERE customer_id NOT IN (5,9,12)
ORDER BY return_date desc;


-- Commande LIKE

SELECT colonne1, colonne2, …
FROM table
WHERE colonne1 LIKE 'Jen%';

SELECT first_name
FROM customer
WHERE first_name LIKE 'Jen%';

SELECT first_name
FROM customer
WHERE first_name LIKE 'Jen_';

SELECT first_name
FROM customer
WHERE first_name LIKE '%er_';


-- Compter le nombre d’acteurs dont le nom de famille commence par P :

SELECT COUNT(last_name)
FROM actor
WHERE last_name LIKE 'P%';


-- Compter le nombre de films qui contiennent Truman dans leur titre :

SELECT COUNT(title)
FROM film
WHERE title LIKE '%Truman%';


-- Le client qui a le plus grand customer_id et dont le prénom commence par ‘E’ et a un address ID inférieur à 500 :

SELECT customer_id, first_name, last_name, address_id
FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id desc
LIMIT 1;


-- Challenge 1 :

-- Nous avons 2 équipes différentes qu’on appelle staff_id 1 et staff_id 2. Nous souhaitons donner un bonus à l’équipe qui a obtenu le plus de paiements.
-- Combien de paiement a réalisé chaque équipe et pour quel montant ?

SELECT staff_id, COUNT(amount), SUM(amount)
FROM payment
GROUP BY staff_id;


-- Challenge 2 :

-- Un cabinet d’audit est en train d’auditer le magasin et souhaiterait connaître le coût moyen de remplacement des films par lettre de notation (ex : R, PG, etc…)

SELECT rating, AVG(replacement_cost)
FROM film
GROUP BY rating;


-- Limiter à 2 chiffres après le virgule :

SELECT rating, ROUND(AVG(replacement_cost), 2)
FROM film
GROUP BY rating;


-- Challenge 3 :

-- Obtenir les IDs des 5 clients qui ont dépensé le plus d’argent dans le magasin :

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) desc
LIMIT 5;


-- Challenge 4 :

SELECT rating, AVG(rental_rate)
FROM film
WHERE rating IN ('R', 'G', 'PG')
GROUP BY rating;

SELECT rating, AVG(rental_rate)
FROM film
WHERE rating IN (‘R’, ‘G’, ‘PG’)
GROUP BY rating
HAVING AVG(rental_rate) > 3;

-- Les clients (avec IDs) qui totalisent au moins 30 transactions de paiement :

SELECT customer_id, COUNT(amount)
FROM payment
GROUP BY customer_id
HAVING COUNT(amount) > 30;


-- Challenge 5 :

-- Les notations dont la durée de location moyenne est supérieure à 5 jours :

SELECT rating, AVG(rental_duration)
FROM film
GROUP BY rating
HAVING AVG(rental_duration) > 5;


-- Challenge 6 :

-- Les IDs des clients qui ont payés plus de 110$ à l’équipe staff 2 :

SELECT customer_id, SUM(amount)
FROM payment
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) > 110;


-- JOINS

SELECT customer.customer_id, first_name, last_name, email, amount, payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id;

-- Ordre croissant de prénom :

SELECT customer.customer_id, first_name, last_name, email, amount, payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
ORDER BY first_name asc;

-- Mettre une condition :

SELECT customer.customer_id, first_name, last_name, email, amount, payment_date
FROM customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
WHERE customer.customer_id = 7;


-- LEFT OUTER JOIN

SELECT f.film_id, title, inventory_id, store_id
FROM film as f
LEFT OUTER JOIN inventory as i ON f.film_id = i.film_id;

-- Afficher seulement les résultats NULL

SELECT f.film_id, title, inventory_id, store_id
FROM film as f
LEFT OUTER JOIN inventory as i ON f.film_id = i.film_id
WHERE i.film_id IS NULL;


-- Challenge : 

-- Afficher la liste de tous les films accompagnés de la catégorie de films auxquelles ils appartiennent ainsi que la langue du film :

SELECT f.title, c.name as Category, l.name as Movie_language
FROM film as f
INNER JOIN film_category as fc ON f.film_id = fc.film_id
INNER JOIN category as c ON c.category_id = fc.category_id
INNER JOIN language as l ON l.language_id = f.language_id;


-- Challenge 2 :

-- Afficher tous les films avec leur nombre de location et les revenus que chaque film a généré.

SELECT film.title, COUNT(rental_rate), COUNT(rental_id) * rental_rate AS revenue
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title, rental_rate
ORDER BY revenue desc;


-- Challenge 3 :

-- Le magasin qui a vendu le plus (store 1 ou store 2)
-- Le total de ventes de chaque magasin (store_id)
-- Montant de la colonne amount de table payment :

SELECT store_id, SUM(p.amount) as revenue
FROM inventory as i
INNER JOIN rental as r ON r.inventory_id = i.inventory_id
INNER JOIN payment as p ON p.rental_id = r.rental_id
GROUP BY store_id
ORDER BY revenue desc;


-- Challenge 4 :

-- Nombre de locations pour les films d’action, pour les comédies et pour les films d’animation
-- Total des locations à côté des 3 types de film ci-dessus :

SELECT c.name as category, COUNT(r.rental_id) as number
FROM category as c
INNER JOIN film_category as fc ON c.category_id = fc.category_id
INNER JOIN film as f ON f.film_id = fc.film_id
INNER JOIN inventory as i ON i.film_id = f.film_id
INNER JOIN rental as r ON r.inventory_id = i.inventory_id
WHERE c.name IN (‘Action’, ‘Comedy’, ‘Animation’)
GROUP BY c.name;


-- Challenge 5 :

-- Les emails des clients qui ont loué plus de 40 films pour les contacter :

SELECT email, COUNT(rental_id) as number_or_retal
FROM customer as c 
INNER JOIN rental as r ON c.customer_id = r.customer_id
GROUP BY email
HAVING COUNT(rental_id) >=  40;