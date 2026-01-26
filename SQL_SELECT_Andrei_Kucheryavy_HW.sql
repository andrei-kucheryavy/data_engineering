Part 1: Write SQL queries to retrieve the following data
•	All animation movies released between 2017 and 2019 with rate more than 1, alphabetical

select *
from film
where rental_rate > 1 and release_year between 2017 and 2019
order by  title

•	The revenue earned by each rental store since March 2017 (columns: address and address2 – as one column, revenue)
•	Top-5 actors by number of movies (released since 2015) they took part in (columns: first_name, last_name, number_of_movies, sorted by number_of_movies in descending order)
•	Number of Drama, Travel, Documentary per year (columns: release_year, number_of_drama_movies, number_of_travel_movies, number_of_documentary_movies), sorted by release year in descending order. Dealing with NULL values is encouraged)
•	For each client, display a list of horrors that he had ever rented (in one column, separated by commas), and the amount of money that he paid for it
