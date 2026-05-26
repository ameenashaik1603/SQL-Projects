-- 1. First 10 film titles in alphabetical order
SELECT title 
FROM film 
ORDER BY title ASC 
LIMIT 10;

-- 2. Titles and release years of all films released in 2006, sorted by title
SELECT title, release_year 
FROM film 
WHERE release_year = 2006 
ORDER BY title ASC;

-- 3. Titles and ratings of films rated PG or PG-13, sorted by title in reverse alphabetical order
SELECT title, rating 
FROM film 
WHERE rating IN ('PG', 'PG-13') 
ORDER BY title DESC;

-- 4. Show all the distinct film ratings in the database
SELECT DISTINCT rating 
FROM film;

-- 5. Total number of films in the database
SELECT COUNT(*) AS total_films 
FROM film;

-- 6. Number of films for each rating, sorted by largest count first
SELECT rating, COUNT(*) AS film_count 
FROM film 
GROUP BY rating 
ORDER BY film_count DESC;

-- 7. Number of films per rating, only if there are at least 200 films
SELECT rating, COUNT(*) AS film_count 
FROM film 
GROUP BY rating 
HAVING COUNT(*) >= 200 
ORDER BY film_count DESC;

-- 8. The 10 longest films (titles and lengths), starting with the longest
SELECT title, length 
FROM film 
ORDER BY length DESC 
LIMIT 10;

-- 9. Each film category and the number of films in it, sorted largest to smallest
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC;

-- 10. The 10 most frequently rented films with their rental counts
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 10;

-- 11. Customer's full name and number of rentals, sorted by highest first
SELECT c.first_name || ' ' || c.last_name AS customer_name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC;

-- 12. Customer's full name, total paid, and number of payments, sorted by highest paid first
SELECT c.first_name || ' ' || c.last_name AS customer_name, 
       SUM(p.amount) AS total_amount_paid, 
       COUNT(p.payment_id) AS payment_count
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_amount_paid DESC;

-- 13. Customers who live in Canada with their city and email address
SELECT cu.first_name || ' ' || cu.last_name AS customer_name, cu.email, ci.city
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- 14. Average payment amount for each month, with the newest month first
SELECT DATE_TRUNC('month', payment_date) AS payment_month, AVG(amount) AS average_payment
FROM payment
GROUP BY payment_month
ORDER BY payment_month DESC;

-- 15. Film title and number of actors, only if the film has at least 5 actors
SELECT f.title, COUNT(fa.actor_id) AS actor_count
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
HAVING COUNT(fa.actor_id) >= 5
ORDER BY actor_count DESC;

-- 16. Each store and the total payment amount it has processed, sorted highest to lowest
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;