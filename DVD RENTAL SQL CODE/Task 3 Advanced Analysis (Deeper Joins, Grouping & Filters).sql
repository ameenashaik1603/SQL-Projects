-- 1. Top 5 customers by total payment amount
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name, SUM(p.amount) AS total_spent
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- 2. Top 3 most rented film categories
SELECT cat.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY total_rentals DESC
LIMIT 3;

-- 3. Average rental duration per film category
SELECT cat.name AS category_name, AVG(r.return_date - r.rental_date) AS avg_rental_duration
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY avg_rental_duration DESC;

-- 4. Monthly revenue per store for the most recent year in the dataset
SELECT s.store_id, DATE_TRUNC('month', p.payment_date) AS revenue_month, SUM(p.amount) AS monthly_revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
WHERE EXTRACT(YEAR FROM p.payment_date) = (SELECT EXTRACT(YEAR FROM MAX(payment_date)) FROM payment)
GROUP BY s.store_id, revenue_month
ORDER BY s.store_id ASC, revenue_month ASC;

-- 5. Find films that were never rented
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

-- 6. Customers who have spent over $100 in total
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name, SUM(p.amount) AS total_spent
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > 100
ORDER BY total_spent DESC;

-- 7. Staff member with the highest total payments processed
SELECT st.staff_id, st.first_name || ' ' || st.last_name AS staff_name, SUM(p.amount) AS total_processed
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
GROUP BY st.staff_id, st.first_name, st.last_name
ORDER BY total_processed DESC
LIMIT 1;

-- 8. Average film length per category, only for categories with an above-average length
SELECT c.name AS category_name, ROUND(AVG(f.length), 2) AS avg_film_length
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > (SELECT AVG(length) FROM film)
ORDER BY avg_film_length DESC;