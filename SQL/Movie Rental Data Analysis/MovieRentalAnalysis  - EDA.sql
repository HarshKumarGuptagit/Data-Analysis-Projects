use sakila;
show tables;
/*--------------------------------------------------------------
-- TASK 1 : Display the full name of all actors 
----------------------------------------------------------------*/
SELECT 
    CONCAT(first_name, ' ', last_name) AS Fullname
FROM
    actor;
    
    
/* -----------------------------------------------------------------------------
	TASK 2: 
	Display the number of time each first name appears in the database
----------------------------------------------------------------------------------*/

SELECT 
    first_name, COUNT(*) AS occurances
FROM
    actor
GROUP BY first_name
ORDER BY occurances DESC;
	
/*--------------------------------------------------------------
  TASK 2(ii): Count of actors who have unique first name in the database and display them
----------------------------------------------------------------*/
SELECT DISTINCT
    first_name AS unique_first_name
FROM
    actor;
    
/*--------------------------------------------------------------
  TASK 3(i): Display the number of times each last names appers in the database
----------------------------------------------------------------*/
SELECT 
    last_name, COUNT(*) AS Number_of_occurance
FROM
    actor
GROUP BY last_name
ORDER BY Number_of_occurance DESC;

/*--------------------------------------------------------------
  TASK 3(ii): Display all the unique last names in the database
----------------------------------------------------------------*/
SELECT DISTINCT
    last_name
FROM
    actor;
    
/*--------------------------------------------------------------
  TASK 4(i): Display the list of movies with the rating R
----------------------------------------------------------------*/
SELECT 
    title
FROM
    film
WHERE
    rating = 'R';
/*--------------------------------------------------------------
  TASK 4(ii): Display the list of movies which are not rated R
----------------------------------------------------------------*/
SELECT 
    title
FROM
    film
WHERE
    rating != 'R';
    
/*--------------------------------------------------------------
  TASK 4(iii): Display the list of movies which are suitable for the childer below 13 years
----------------------------------------------------------------*/

SELECT 
    title
FROM
    film
WHERE
    rating IN ('G' , 'PG');
    
 /*--------------------------------------------------------------
  TASK 5(i): Display the records of movies whose replacement cost is upto $11
----------------------------------------------------------------*/  

SELECT 
    *
FROM
    film
WHERE
    replacement_cost <= 11
ORDER BY replacement_cost DESC;
    
 /*--------------------------------------------------------------
  TASK 5(ii): Display the records of movies whose replacement cost is upto $11
----------------------------------------------------------------*/  
SELECT 
    *
FROM
    film
WHERE
    replacement_cost BETWEEN 11 AND 20
ORDER BY replacement_cost DESC;

 /*--------------------------------------------------------------
  TASK 5(iii): Display the records of all movies in descending odered of their replacement cost
----------------------------------------------------------------*/ 	
SELECT 
    *
FROM
    film
ORDER BY replacement_cost DESC;
 
  /*--------------------------------------------------------------
  TASK 6 : Display the name of top 3 movies with the most number of actors
----------------------------------------------------------------*/ 
SELECT 
    title, COUNT(DISTINCT actor_id) AS Number_of_Actor
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY title
ORDER BY Number_of_Actor DESC
LIMIT 3;

  /*--------------------------------------------------------------
  TASK 7 : Display the titles of the movies which start with 'K' and 'Q'
----------------------------------------------------------------*/ 
SELECT 
    title
FROM
    film
WHERE
    title LIKE 'E%' OR title LIKE 'Q%';

  /*--------------------------------------------------------------
  TASK 8 : Display the names of all actors who appeared in the movie 'Agent Truman'
  -------------------------------------------------------------*/ 
  
SELECT 
    CONCAT(first_name, ' ', last_name) AS ActorName, title
FROM
    film f
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
        INNER JOIN
    actor a ON fa.actor_id = a.actor_id
WHERE
    title = 'Agent Truman';

  /*--------------------------------------------------------------
  TASK 9 : Identify all the mmovies that are categorised as family movies
  -------------------------------------------------------------*/ 
SELECT 
    title,name AS CategoryName
FROM
    film f
    INNER JOIN film_category fc ON fc.film_id=f.film_id
    INNER JOIN category c ON c.category_id=fc.category_id
WHERE
    name = 'Family';
    
  /*--------------------------------------------------------------
  TASK 10(i) : Display the maximum, minimum and Average rental rate of all movie rating
  -------------------------------------------------------------*/ 
SELECT 
    rating,
    MAX(rental_rate) AS MinimumRate,
    MIN(rental_rate) AS MinimumRate,
    AVG(rental_rate) AS AverageRate
FROM
    film
GROUP BY rating
ORDER BY AverageRate DESC;
    
    
  /*--------------------------------------------------------------
  TASK 10 (ii): Display the movies in descending order of their rental frequencies
  -------------------------------------------------------------*/
  
SELECT 
    title, COUNT(rental_id) AS RentCount
FROM
    film f
        INNER JOIN
    inventory i ON i.film_id = f.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
GROUP BY title
ORDER BY RentCount DESC;
  
  /*--------------------------------------------------------------
  TASK 11: Display in how many category the differencec between the average film replacement cost and the average rent in more than 15
  -------------------------------------------------------------*/
SELECT 
    Name,
    ROUND(AVG(replacement_cost), 2) AS AverageReplacementCost,
    ROUND(AVG(rental_rate), 2) AS AverageRentalRate,
    ROUND(AVG(replacement_cost) - AVG(rental_rate),2) AS Difference
FROM
    category c
        INNER JOIN
    film_category fc ON fc.category_id = c.category_id
        INNER JOIN
    film f ON f.film_id = fc.film_id
GROUP BY Name
HAVING Difference > 15
ORDER BY Difference DESC;	  
            
		
  /*--------------------------------------------------------------
  TASK 12: Display the film category where the number of movies is greater than 70
  -------------------------------------------------------------*/

SELECT 
    Name, COUNT(title) AS Num_Of_Movies
FROM
    film f
        INNER JOIN
    film_category fc ON f.film_id = fc.film_id
        INNER JOIN
    category c ON c.category_id = fc.category_id
GROUP BY Name
HAVING Num_Of_Movies > 70
ORDER BY Num_Of_Movies DESC;



