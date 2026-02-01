/* Part 1: Write SQL queries to retrieve the following data
•	All animation movies released between 2017 and 2019 with rate more than 1, alphabetical
*/ 
SELECT 
    f.title,
    f.release_year,
    f.rating
FROM film AS f
    INNER JOIN film_category AS fc 
        ON f.film_id = fc.film_id 
    INNER JOIN category AS c2 
       ON fc.category_id = c2.category_id 
WHERE c2."name" = 'Animation'
    AND f.release_year BETWEEN 2017 AND 2019
    AND f.rental_rate > 1
ORDER BY 
    f.title ASC

/*•	The revenue earned by each rental store since March 2017 (columns: address and address2 – as one column, revenue)
*/ 

SELECT
    CONCAT(a.address, ' ', a.address2) AS full_adress,
    SUM(p.amount) AS revenue
FROM store s
    INNER JOIN address AS a 
        ON s.address_id = a.address_id
    INNER JOIN staff AS st 
        ON s.store_id = st.store_id
    INNER JOIN payment AS p 
        ON st.staff_id = p.staff_id
WHERE p.payment_date >= '2017-03-01'
GROUP BY
    a.address,
    a.address2
ORDER BY
    revenue DESC

/*•	Top-5 actors by number of movies (released since 2015) they took part in (columns: first_name, last_name, number_of_movies, sorted by number_of_movies in descending order)
*/ 

SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS number_of_movies
FROM actor AS a
    INNER JOIN film_actor AS fa 
        ON a.actor_id = fa.actor_id
    INNER JOIN film AS f 
        ON fa.film_id = f.film_id
WHERE f.release_year >= 2015
GROUP BY
    a.actor_id,
    a.first_name,
    a.last_name
ORDER BY
    number_of_movies DESC
LIMIT
    5

/*•	Number of Drama, Travel, Documentary per year (columns: release_year, number_of_drama_movies, number_of_travel_movies, number_of_documentary_movies),
sorted by release year in descending order. Dealing with NULL values is encouraged)
*/ 
SELECT
    f.release_year,
    COUNT(
    CASE
        WHEN c.name = 'Drama' THEN 1
    END
        ) 
            AS number_of_drama_movies,
    COUNT(
    CASE
        WHEN c.name = 'Travel' THEN 1
    END
        ) 
            AS number_of_travel_movies,
    COUNT(
    CASE
        WHEN c.name = 'Documentary' THEN 1
    END
        )
            AS number_of_documentary_movies
FROM film AS f
    LEFT JOIN film_category AS fc 
        ON f.film_id = fc.film_id
    LEFT JOIN category AS c 
        ON fc.category_id = c.category_id
WHERE f.release_year IS NOT NULL
    AND c.name IN ('Drama', 'Travel', 'Documentary')
GROUP BY
    f.release_year
ORDER BY
    f.release_year DESC

/*	For each client, display a list of horrors that he had ever rented (in one column, separated by commas), 
and the amount of money that he paid for it
*/ 
SELECT
    c.first_name,
    c.last_name,
    f.title,
    SUM(p.amount) AS total_amount_paid
FROM customer c
    INNER JOIN payment AS p 
        ON c.customer_id = p.customer_id
    INNER JOIN rental AS r 
        ON p.rental_id = r.rental_id
    INNER JOIN inventory AS i 
        ON r.inventory_id = i.inventory_id
    INNER JOIN film AS f 
        ON i.film_id = f.film_id
    INNER JOIN film_category fc 
        ON f.film_id = fc.film_id
    INNER JOIN category AS c2 
        ON fc.category_id = c2.category_id
WHERE
    c2.name = 'Horror'
GROUP BY
    c.first_name,
    c.last_name,
    f.title
ORDER BY
    c.first_name,
    c.last_name

/* Part 2: Solve the following problems using SQL
Which three employees generated the most revenue in 2017? They should be awarded a bonus for their outstanding performance.
Assumptions:
staff could work in several stores in a year, please indicate which store the staff worked in (the last one);
if staff processed the payment then he works in the same store;
take into account only payment_date
*/

SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    (
        SELECT
            s2.store_id
        FROM payment AS p2
            INNER JOIN staff AS s2 
                ON p2.staff_id = s2.staff_id
        WHERE p2.staff_id = s.staff_id
            AND p2.payment_date >= '2017-01-01'
            AND p2.payment_date < '2018-01-01'
        ORDER BY
            p2.payment_date DESC
        LIMIT
            1
    )   
    AS last_store_id,
    SUM(p.amount) AS total_revenue
FROM payment AS p
    INNER JOIN staff AS s 
        ON p.staff_id = s.staff_id
WHERE p.payment_date >= '2017-01-01'
    AND p.payment_date < '2018-01-01'
GROUP BY
    s.staff_id,
    s.first_name,
    s.last_name
ORDER BY
    total_revenue DESC
LIMIT
    3

/* 2 Which 5 movies were rented more than others (number of rentals), 
and what's the expected age of the audience for these movies?
 To determine expected age please use 'Motion Picture Association film rating system
*/

SELECT
    f.title,
    COUNT(r.rental_id) AS number_of_rentals,
    CASE
        WHEN f.rating = 'G' THEN 'All ages'
        WHEN f.rating = 'PG' THEN '8+'
        WHEN f.rating = 'PG-13' THEN '13+'
        WHEN f.rating = 'R' THEN '17+'
        WHEN f.rating = 'NC-17' THEN '18+'
        ELSE 'Unknown'
    END AS expected_audience_age
FROM rental AS r
    INNER JOIN inventory AS i 
        ON r.inventory_id = i.inventory_id
    INNER JOIN film AS f 
        ON i.film_id = f.film_id
GROUP BY
    f.film_id,
    f.title,
    f.rating
ORDER BY
    number_of_rentals DESC
LIMIT
    5

/* Part 3. Which actors/actresses didn't act for a longer period of time than the others?**
The task can be interpreted in various ways, and here are a few options:
- *V1: gap between the latest release_year and current year per each actor;*
- *V2: gaps between sequential films per each actor;
*/

SELECT
    a.first_name,
    a.last_name,
    MAX(f_next.release_year - f.release_year) AS max_gap_years
FROM actor AS a
    INNER JOIN film_actor AS fa 
        ON a.actor_id = fa.actor_id
    INNER JOIN film AS f 
        ON fa.film_id = f.film_id
    INNER JOIN film_actor AS fa_next 
        ON a.actor_id = fa_next.actor_id
    INNER JOIN film AS f_next 
        ON fa_next.film_id = f_next.film_id
WHERE f_next.release_year > f.release_year
GROUP BY
    a.first_name,
    a.last_name
ORDER BY
    max_gap_years DESC