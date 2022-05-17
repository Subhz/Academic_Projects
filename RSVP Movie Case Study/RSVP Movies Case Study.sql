USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 	COUNT(*)
FROM 	movie;
-- 7997 rows in movie table

SELECT 	COUNT(*)
FROM 	genre;
-- 14662 rows in genre table

SELECT 	COUNT(*)
FROM	director_mapping;
-- 3867 rows in director_mapping table

SELECT 	COUNT(*)
FROM	names;
-- 25735 rows in names table

SELECT 	COUNT(*)
FROM 	ratings;
-- 7997 rows in ratings table

SELECT 	COUNT(*)
FROM	role_mapping;
-- 15615 rows in role_mapping table







-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT SUM(
			CASE
				WHEN id IS NULL THEN 1
                ELSE 0
			END
		) AS Id_NULL_Count,
        SUM(
			CASE
				WHEN title IS NULL THEN 1
                ELSE 0
            END
        ) AS Title_NULL_Count,
        SUM(
			CASE
				WHEN year IS NULL THEN 1
                ELSE 0
            END
        ) AS Year_NULL_Count,
        SUM(
			CASE
				WHEN date_published IS NULL THEN 1
                ELSE 0
            END
        ) AS Date_Published_NULL_Count,
        SUM(
			CASE
				WHEN duration IS NULL THEN 1
                ELSE 0
            END
        ) AS Duration_NULL_Count,
        SUM(
			CASE
				WHEN country IS NULL THEN 1
                ELSE 0
            END
        ) AS Country_NULL_Count,
        SUM(
			CASE
				WHEN worlwide_gross_income IS NULL THEN 1
                ELSE 0
            END
        ) AS Worlwide_Gross_Income_NULL_Count,
        SUM(
			CASE
				WHEN languages IS NULL THEN 1
                ELSE 0
            END
        ) AS Languages_NULL_Count,
        SUM(
			CASE
				WHEN production_company IS NULL THEN 1
                ELSE 0
            END
        ) AS Production_Company_NULL_Count
FROM movie;

/*
Only 4 columns in the movie table have null values. Column names and null value count mentioned below - 
Country - 20
Worlwide_Gross_Income - 3724
Languages - 194
Production_Company - 528
*/






-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query to fetch number of movies released per year

SELECT	Year,
		COUNT(id) AS number_of_movies
FROM 	movie
GROUP BY year;

-- Query to fetch number of movies released per month

SELECT 	MONTH(date_published) AS month_num,
		COUNT(id) AS number_of_movies
FROM 	movie
GROUP BY month_num
ORDER BY month_num;






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 	COUNT(id) AS number_of_movies, year
FROM 	movie
WHERE 	(LOWER(country) LIKE '%india%' OR LOWER(country) LIKE '%usa%')
AND		year = 2019;

-- 1059 movies were prodecued in India and USA in 2019







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 	genre
FROM	genre
GROUP BY genre;

-- There are distinct 13 genres present in the genre table









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT	genre,
		COUNT(m.id) AS number_of_movies
FROM	genre AS g
	INNER JOIN
		movie AS m
	ON	g.movie_id = m.id
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;

-- There are 4285 movies with Drama as genre









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:



WITH movie_with_one_genre AS (
	SELECT 	movie_id, genre
	FROM 	movie AS m
		INNER JOIN
			genre AS g
		ON g.movie_id = m.id
	GROUP BY m.id
	HAVING COUNT(m.id) = 1
)
SELECT COUNT(movie_id) AS number_of_movies_with_one_genre
FROM movie_with_one_genre;

-- There are 3289 movies with one genre





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 	genre,
		ROUND(AVG(duration),2) AS avg_duration
FROM 	movie AS m
	INNER JOIN
		genre AS g
	ON	g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Horror genre has the lowest duration and Action genre has the highest duration






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank_summary AS (
	SELECT 	genre,
			COUNT(m.id) AS movie_count,
            RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank    
    FROM 	genre AS g
		INNER JOIN
			movie AS m
		ON 	g.movie_id = m.id
	GROUP BY genre
)

SELECT 	*
FROM 	genre_rank_summary
WHERE	lower(genre) = 'thriller';

-- There are 1484 movies with thriller genre and rank is 3






/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 	MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
        MAX(median_rating) AS max_median_rating
FROM 	ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_ranking AS (
	SELECT 	title,
			avg_rating,
			DENSE_RANK() OVER w1 AS movie_rank
	FROM	ratings AS r
		INNER JOIN
			movie AS m
		ON r.movie_id = m.id
	WINDOW w1 AS (ORDER BY avg_rating DESC)
)
SELECT 	*
FROM 	movie_ranking
WHERE	movie_rank <= 10;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT	median_rating,
		COUNT(movie_id) AS movie_count
FROM	ratings
GROUP BY median_rating
ORDER BY movie_count DESC;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_house_with_hit_movies AS (
	SELECT 	production_company,
			COUNT(id) AS movie_count,
            DENSE_RANK() OVER w1 AS prod_company_rank
	FROM 	movie AS m
		INNER JOIN
			ratings AS r
		ON m.id = r.movie_id
	WHERE 	avg_rating > 8 AND production_company IS NOT NULL
    GROUP BY production_company
    WINDOW w1 AS (ORDER BY COUNT(id) DESC)
)

SELECT 	*
FROM	production_house_with_hit_movies
WHERE	prod_company_rank = 1;

-- Most number of hit movies (avg_rating > 8) were produced by both Dream Warrior Pictures and National Theatre Live




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 	genre,
		COUNT(id) AS movie_count
FROM	genre AS g
	INNER JOIN
		movie AS m
			ON g.movie_id = m.id
	INNER JOIN
		ratings AS r
			ON r.movie_id = m.id
WHERE 	MONTH(date_published) = 3
AND		year = 2017
AND 	lower(country) LIKE '%usa%'
AND 	total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 	title,
		avg_rating,
        genre
FROM	movie AS m
	INNER JOIN 
		ratings AS r
			ON m.id = r.movie_id
	INNER JOIN
		genre AS g
			ON r.movie_id = g.movie_id
WHERE 	avg_rating > 8
AND 	lower(title) REGEXP '^the'
GROUP BY title
ORDER BY avg_rating DESC;

-- The Brighton Miracle has highest rating with genre as Drama
-- There are total 8 movies that start with 'the' and have average rating more than 8


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT	COUNT(id) AS number_of_movies
FROM	movie AS m
	INNER JOIN
		ratings AS r
			ON m.id = r.movie_id
WHERE 	median_rating = 8
AND		date_published BETWEEN '2018-04-01' AND '2019-04-01';


-- number of movies with median rating of 8 and released between 1 April 2018 and 1 April 2019 = 361





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH vote_count AS (
	SELECT 	languages,
			SUM(total_votes) AS votes
	FROM	movie AS m
		INNER JOIN
			ratings AS r
				ON m.id = r.movie_id
	WHERE 	lower(languages) LIKE '%german%'

	UNION

	SELECT 	languages,
			SUM(total_votes) AS votes
	FROM	movie AS m
		INNER JOIN
			ratings AS r
				ON m.id = r.movie_id
	WHERE 	lower(languages) LIKE '%italian%'
)

SELECT 	CASE
			WHEN lower(languages) = 'german' THEN 'YES'
            ELSE 'NO'
		END AS 'German movies have more votes ?'
FROM	vote_count
ORDER BY votes DESC
LIMIT 1;






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 	SUM(
			CASE
				WHEN name IS NULL THEN 1
                ELSE 0
            END
		) AS name_nulls,
		SUM(
			CASE
				WHEN height IS NULL THEN 1
                ELSE 0
            END
        ) AS height_nulls,
        SUM(
			CASE 
				WHEN date_of_birth IS NULL THEN 1
                ELSE 0
            END
        ) AS date_of_birth_null,
        SUM(
			CASE
				WHEN known_for_movies IS NULL THEN 1
                ELSE 0
            END        
        ) AS known_for_movies_nulls
FROM 	names;

-- height column has 17335 null values
-- date_of_birth column has 13431 null values
-- known_for_movies column has 15226 null values




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH three_top_genres AS (
	SELECT 	genre,
			COUNT(m.id) as number_of_movies
    FROM	movie AS m
		INNER JOIN
			genre AS g
				ON m.id = g.movie_id
		INNER JOIN
			ratings AS r
				ON m.id = r.movie_id
	WHERE 	avg_rating > 8
    GROUP BY genre
    ORDER BY number_of_movies DESC
    LIMIT 3
)

SELECT 	name AS director_name,
		COUNT(r.movie_id) AS movie_count
FROM 	director_mapping AS d
	INNER JOIN
		names AS n
			ON d.name_id = n.id
	INNER JOIN 
		ratings AS r
			ON r.movie_id = d.movie_id
	INNER JOIN 
		genre AS g
			ON g.movie_id = d.movie_id
	INNER JOIN
		three_top_genres AS t
			ON t.genre  = g.genre
WHERE 	avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

-- James Mangold is the director who has given 4 hit movies with average rating greater than 8





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT	name AS actor_name,
		COUNT(r.movie_id) AS movie_count
FROM 	role_mapping AS rm
	INNER JOIN
		names AS n
			ON rm.name_id = n.id
	INNER JOIN
		ratings AS r
			ON r.movie_id = rm.movie_id
WHERE 	median_rating >= 8
AND 	lower(category) = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;
	
-- Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_house_summary AS (
	SELECT 	production_company,
			SUM(total_votes) AS vote_count,
			ROW_NUMBER() OVER w1 AS prod_comp_rank
	FROM 	movie AS m
		INNER JOIN
			ratings AS r
				ON m.id = r.movie_id
	GROUP BY production_company
	WINDOW w1 AS (ORDER BY SUM(total_votes) DESC)
)
SELECT 	*
FROM 	prod_house_summary
WHERE	prod_comp_rank <= 3;

-- Top 3 production houses are Marvel studios, Twentieth Century Fox and Warner Bros.





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

		
	
WITH indian_actor_summary AS (
	SELECT	name AS actor_name,
			SUM(total_votes) AS total_votes,
			COUNT(m.id) AS movie_count,
			ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating			
	FROM 	movie AS m
		INNER JOIN 
			role_mapping AS rm
				ON m.id = rm.movie_id
		INNER JOIN
			ratings AS r
				ON r.movie_id = m.id
		INNER JOIN
			names AS n
				ON n.id = rm.name_id
	WHERE 	LOWER(rm.category) = 'actor'
	AND		LOWER(m.country) LIKE '%india%'
	GROUP BY name
	HAVING movie_count >= 5
)

SELECT 	*,
		DENSE_RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM 	indian_actor_summary;


-- Top three actors are Vijay Sethupati, Fahadh Faasil and Yogi Babu




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH hindi_actress_summary AS (
	SELECT	n.name AS actress_name,
			SUM(total_votes) AS total_votes,
            COUNT(m.id) AS movie_count,
            ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating
    FROM	movie AS m
		INNER JOIN
			ratings AS r
				ON r.movie_id = m.id
		INNER JOIN
			role_mapping AS rm
				ON rm.movie_id = m.id
		INNER JOIN 
			names AS n
				ON n.id = rm.name_id
    WHERE	LOWER(m.languages) LIKE '%hindi%'
    AND 	LOWER(rm.category) = 'actress'
	AND		LOWER(m.country) LIKE '%india%'
    GROUP BY name
    HAVING movie_count >= 3
)
SELECT 	*,
		DENSE_RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM 	hindi_actress_summary;


-- Top three Indian hindi actresses are Taapsee Pannu, Kriti Sanon and Divya Dutta



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 	m.id AS movie_id,
		m.title AS movie_title,
        r.avg_rating,
        CASE
			WHEN r.avg_rating > 8 THEN 'Superhit movies'
            WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
            WHEN r.avg_rating BETWEEN 5 AND 6.9 THEN 'One-time-watch movies'
            ELSE 'Flop movies'
        END AS movie_category
FROM	movie AS m
	INNER JOIN
		ratings AS r
			ON m.id = r.movie_id
	INNER JOIN genre AS g
			ON r.movie_id = g.movie_id
WHERE 	LOWER(genre) REGEXP 'thriller'
ORDER BY r.avg_rating DESC;



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_avg_duration AS (
	SELECT 	genre,
			ROUND(AVG(duration),2) AS avg_duration
	FROM	movie AS m
		INNER JOIN
			genre AS g
				ON m.id = g.movie_id
	GROUP BY genre
)
SELECT 	*,
		SUM(avg_duration) OVER w1 AS running_total_duration,
        AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM	genre_avg_duration
WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
	   w2 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);
		






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_three_genres AS (
	SELECT 	genre,
			COUNT(m.id) AS movie_count
	FROM 	movie AS m
		INNER JOIN
			genre AS g
				ON g.movie_id = m.id
	GROUP BY genre
	ORDER BY movie_count DESC
	LIMIT 3
),
movies_with_income AS (
	SELECT 	genre,
			year,
			title AS movie_name,
			CAST(replace(replace(ifnull(worlwide_gross_income,0),'$',''),'INR','') AS decimal(12)) AS worldwide_gross_income
	FROM 	movie AS m
		INNER JOIN 
			genre AS g
				ON m.id = g.movie_id
	WHERE 	genre IN (
			SELECT 	genre
			FROM 	top_three_genres
            )
	GROUP BY movie_name
),
highest_income_movies AS (
	SELECT 	*,
			ROW_NUMBER() OVER(PARTITION BY year ORDER BY worldwide_gross_income DESC) AS movie_rank
	FROM 	movies_with_income
)
SELECT 	*
FROM 	highest_income_movies
WHERE 	movie_rank <= 5;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_house_summary AS (
	SELECT 	production_company,
			COUNT(m.id) AS movie_count,
            ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
    FROM 	movie AS M
		INNER JOIN
			ratings AS r
				ON m.id = r.movie_id
	WHERE 	median_rating >= 8
    AND 	production_company IS NOT NULL
	AND 	position(',' in languages) > 0
    GROUP BY production_company
)
SELECT 	*		
FROM 	production_house_summary
WHERE 	prod_comp_rank < 3;

-- Star cinema and Twentieth Century Fox are the production houses which have produced highest hit movies with median rating >= 8



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS (
	SELECT 	name AS actress_name,
			SUM(total_votes) AS total_votes,
            COUNT(rm.movie_id) AS movie_count,
            ROUND(SUM(total_votes*avg_rating)/SUM(total_votes),2) AS actress_avg_rating
    FROM 	names AS n
		INNER JOIN
			role_mapping AS rm
				ON rm.name_id = n.id
		INNER JOIN
			ratings AS r
				ON r.movie_id = rm.movie_id
		INNER JOIN
			genre AS g
				ON g.movie_id = rm.movie_id
/*		INNER JOIN
			movie AS m
				ON m.id = rm.movie_id*/
	WHERE 	avg_rating > 8
    AND 	LOWER(rm.category) = 'actress'
    AND 	LOWER(genre) = 'drama'
    GROUP BY name
)

SELECT 	*,
		ROW_NUMBER() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM 	actress_summary
limit 3;

-- Actresses with super hit movies - Parvathy Thiruvothu, Susan Brown, Amanda Lawrence 




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_summary AS (
	SELECT 	dm.name_id AS director_id,
			n.name AS director_name,
			m.id AS movie_id,
			total_votes,
			avg_rating,
			duration,
			date_published,
			LEAD(date_published,1) OVER(PARTITION BY dm.name_id ORDER BY date_published, m.id) AS next_published_date
	FROM 	movie AS m
		INNER JOIN
			director_mapping AS dm
				ON m.id = dm.movie_id
		INNER JOIN 
			names AS n
				ON n.id = dm.name_id
		INNER JOIN 
			ratings AS r
				ON r.movie_id = m.id
),

director_publish_summary AS (
	SELECT 	*,
			DATEDIFF(next_published_date, date_published) AS date_difference
	FROM 	director_summary
)

SELECT 	director_id,
		director_name,
        COUNT(movie_id) AS number_of_movies,
        ROUND(AVG(date_difference)) AS avg_inter_movie_days,
        ROUND(AVG(avg_rating),2) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
FROM 	director_publish_summary
GROUP BY director_name
ORDER BY number_of_movies DESC
LIMIT 9;
        
		







