
-- Creating tables given in the question:

CREATE TABLE country (
  country_id INT PRIMARY KEY,
  country_iso_code CHAR(2) NOT NULL,
  country_name VARCHAR(255) NOT NULL
);

CREATE TABLE language (
  language_id INT PRIMARY KEY,
  language_name VARCHAR(255) NOT NULL,
  language_code CHAR(2) NOT NULL
);

CREATE TABLE language_role (
  role_id INT PRIMARY KEY,
  language_role VARCHAR(255) NOT NULL
);

CREATE TABLE genre (
  genre_id INT PRIMARY KEY,
  genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE keyword (
  keyword_id INT PRIMARY KEY,
  keyword_name VARCHAR(255) NOT NULL
);

CREATE TABLE movie (
  movie_id INT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  budget BIGINT,
  homepage VARCHAR(255),
  overview TEXT,
  popularity FLOAT,
  release_date DATE,
  revenue BIGINT,
  runtime INTEGER,
  movie_status VARCHAR(255),
  tagline VARCHAR(255),
  votes_avg FLOAT,
  votes_count INTEGER
);

CREATE TABLE production_company (
  company_id INT PRIMARY KEY,
  company_name VARCHAR(255) NOT NULL
);

CREATE TABLE gender (
  gender_id INT PRIMARY KEY,
  gender VARCHAR(10) NOT NULL
);

CREATE TABLE person (
  person_id INT PRIMARY KEY,
  person_name VARCHAR(255) NOT NULL
);

CREATE TABLE department (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(255) NOT NULL
);

CREATE TABLE production_country (
  movie_id INT NOT NULL,
  country_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE movie_languages (
  movie_id INT NOT NULL,
  language_id INT NOT NULL,
  language_role_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (language_id) REFERENCES language(language_id)
);

CREATE TABLE movie_genre (
  movie_id INT NOT NULL,
  genre_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

CREATE TABLE movie_keywords (
  movie_id INT NOT NULL,
  keyword_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (keyword_id) REFERENCES keyword(keyword_id)
);

CREATE TABLE movie_company (
  movie_id INT NOT NULL,
  company_id INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (company_id) REFERENCES production_company(company_id)
);

CREATE TABLE movie_cast (
  movie_id INT NOT NULL,
  gender_id INT NOT NULL,
  person_id INT NOT NULL,
  character_name VARCHAR(255),
  cast_order INTEGER,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
  FOREIGN KEY (person_id) REFERENCES person(person_id)
);

CREATE TABLE movie_crew (
  person_id INT NOT NULL,
  movie_id INT NOT NULL,
  department_id INT NOT NULL,
  job VARCHAR(255),
  FOREIGN KEY (person_id) REFERENCES person(person_id),
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
  FOREIGN KEY (department_id) REFERENCES department(department_id)
);

-----------------------------------------------------------------------------------

-- QUESTIONS:
-- 1. Write SQL query to show all the data in the Movie table.

SELECT * FROM movie;

-- 2. Write SQL query to show the title of the longest runtime movie.

SELECT TOP 1 title FROM movie ORDER BY runtime DESC;

-- 3. Write SQL query to show the highest revenue generating movie title.

SELECT TOP 1 title FROM movie ORDER BY revenue DESC;

-- 4. Write SQL query to show the movie title with maximum value of revenue/budget.

SELECT TOP 1 title FROM movie ORDER BY revenue DESC, BUDGET;

-- 5. Write a SQL query to show the movie title and its cast details like name of the person, gender, character 
 name, cast order.

SELECT title, person_name,gender,cast_order 
FROM movie m INNER JOIN movie_cast mc ON m.movie_id = mc.movie_id
             INNER JOIN gender g ON mc.gender_id =g.gender_id
			 INNER JOIN person p ON mc.person_id = p.person_id;
			 

-- 6. Write a SQL query to show the country name where maximum number of movies has been produced, along 
with the number of movies produced.

SELECT TOP 1 country_name, COUNT(*) AS num_movies
FROM country c
JOIN production_country pc ON c.country_id = pc.country_id
GROUP BY country_name
ORDER BY num_movies DESC;

-- 7. Write a SQL query to show all the genre_id in one column and genre_name in second column

SELECT genre_id, genre_name
FROM genre;

-- 8. Write a SQL query to show name of all the languages in one column and number of movies in that particular column in another column.

SELECT l.language_name, COUNT(DISTINCT ml.movie_id) AS num_movies
FROM language l
JOIN movie_languages ml ON l.language_id = ml.language_id
GROUP BY l.language_id;

-- 9. Write a SQL query to show movie name in first column, no. of crew members in second column and
number of cast members in third column.

SELECT m.title, 
       COUNT(DISTINCT mc.person_id) AS num_crew_members, 
       COUNT(DISTINCT mcc.person_id) AS num_cast_members
FROM movie m
LEFT JOIN movie_crew mc ON m.movie_id = mc.movie_id
LEFT JOIN movie_cast mcc ON m.movie_id = mcc.movie_id
GROUP BY m.movie_id;

-- 10. Write a SQL query to list top 10 movies title according to popularity column in decreasing order.

SELECT TOP 10 title, popularity
FROM movie
ORDER BY popularity DESC;

-- 11. Write a SQL query to show the name of the 3rd most revenue generating movie and its revenue.

SELECT TOP 1 title, revenue
FROM movie
ORDER BY revenue DESC
OFFSET 2;

-- 12. Write a SQL query to show the names of all the movies which have “rumoured” movie status.

SELECT title
FROM movie
WHERE movie_status = 'Rumoured';

--13. Write a SQL query to show the name of the “United States of America” produced movie which generated
maximum revenue.

SELECT TOP 1 m.title
FROM movie m
JOIN production_country pc ON m.movie_id = pc.movie_id
JOIN country c ON pc.country_id = c.country_id
WHERE c.country_name = 'United States of America'
ORDER BY m.revenue DESC
;

-- 14. Write a SQL query to print the movie_id in one column and name of the production company in the second column for all the movies.

SELECT m.movie_id, pc.company_name
FROM movie m
JOIN movie_company mc ON m.movie_id = mc.movie_id
JOIN production_company pc ON mc.company_id = pc.company_id;

-- 15. Write a SQL query to show the title of top 20 movies arranged in decreasing order of their budget.

SELECT TOP 20 title FROM movie ORDER BY budget DESC;








