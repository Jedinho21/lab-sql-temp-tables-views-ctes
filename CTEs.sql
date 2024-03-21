USE SAKILA;

CREATE VIEW customer_rental_summary AS
SELECT c.customer_id,
CONCAT(c.first_name, c.last_name) AS customer_name, c.email,
COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


CREATE TEMPORARY TABLE temp_total_paid AS 
SELECT rs.customer_id, rs.customer_name, SUM(p.amount) AS total_paid 
FROM customer_rental_summary rs 
JOIN payment p ON rs.customer_id = p.customer_id 
GROUP BY rs.customer_id, rs.customer_name;

WITH rental_payment_summary AS (
SELECT crs.customer_name, crs.email, crs.rental_count, ttp.total_paid
FROM customer_rental_summary crs
JOIN temp_total_paid ttp ON crs.customer_id = ttp.customer_id
)
SELECT * FROM rental_payment_summary;


WITH rental_payment_summary AS (
SELECT crs.customer_name, crs.email, crs.rental_count, ttp.total_paid
FROM customer_rental_summary crs
JOIN temp_total_paid ttp ON crs.customer_id = ttp.customer_id
)
SELECT 
customer_name, email, rental_count, total_paid, total_paid / rental_count AS average_payment_per_rental
FROM 
rental_payment_summary;

