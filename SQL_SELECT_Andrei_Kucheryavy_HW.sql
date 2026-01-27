/* Part 1: Write SQL queries to retrieve the following data
•	All animation movies released between 2017 and 2019 with rate more than 1, alphabetical
*/ 
SELECT 
    f.title,
    f.release_year,
    f.rating
FROM 
    film f
    inner join  film_category fc ON f.film_id = fc.film_id 
    inner join category c2 on fc.category_id = c2.category_id 
WHERE 
    c2."name"   = 'Animation'
    AND f.release_year BETWEEN 2017 AND 2019
    AND f.rental_rate > 1
ORDER BY 
    f.title ASC

/*•	The revenue earned by each rental store since March 2017 (columns: address and address2 – as one column, revenue)
*/ 

select concat(a.address, ' ', a.address2) as full_adress,
		sum(p.amount) as revenue
    from store s
    inner join address a 
    on s.address_id = a.address_id
    inner join staff st 
    on s.store_id = st.store_id
    inner join payment p 
    on st.staff_id = p.staff_id
    where p.payment_date >= '2017-03-01'
	group by a.address, a.address2
	order by revenue desc

/*•	Top-5 actors by number of movies (released since 2015) they took part in (columns: first_name, last_name, number_of_movies, sorted by number_of_movies in descending order)
*/ 

select a.first_name, a.last_name, count(fa.film_id) as number_of_movies
from actor a
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join film f 
on fa.film_id = f.film_id 
where f.release_year >= 2015
group by a.actor_id, a.first_name, a.last_name
order by number_of_movies DESC
limit 5


/*•	Number of Drama, Travel, Documentary per year (columns: release_year, number_of_drama_movies, number_of_travel_movies, number_of_documentary_movies), sorted by release year in descending order. Dealing with NULL values is encouraged)
*/ 


/*•	For each client, display a list of horrors that he had ever rented (in one column, separated by commas), and the amount of money that he paid for it
*/ 

