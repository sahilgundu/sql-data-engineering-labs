SELECT * 
FROM tutorial.us_housing_units;


SELECT count(*) 
FROM tutorial.us_housing_units;


SELECT
	year,
	month,
	month_name,
	south,
	west,
	midwest,
	northeast
FROM tutorial.us_housing_units; 
	

SELECT 
	west AS west_region,
	south AS south_region
FROM tutorial.us_housing_units uhu; 


SELECT 
	west AS "West_Region",
	south AS "South_Region"
FROM tutorial.us_housing_units uhu; 


SELECT *
FROM tutorial.us_housing_units uhu 
LIMIT 15;


SELECT *
FROM tutorial.us_housing_units uhu 
WHERE uhu."month_name" = 'March';


SELECT *
FROM tutorial.us_housing_units uhu 
WHERE "month_name" = 'December';


SELECT 
	south,
	west,
	south + west AS "Sum of Columns"
FROM tutorial.us_housing_units uhu 


/* Write a query that returns all rows for which more units were produced 
in the West region than in the Midwest and Northeast combined.*/

SELECT 
	*,
	midwest + northeast AS "SUM",
	west,
	(west - (midwest + northeast)) AS "Greater in west"

FROM tutorial.us_housing_units uhu 
WHERE west > (midwest + northeast)


/*
Practice Problem:
	Write a query that calculates the percentage of all houses completed in the United States represented by each region. 
	Only return results from the year 2000 and later.
	
	Hint: There should be four columns of percentages.
*/    


SELECT 
	uhu.south + uhu.west + uhu.midwest + uhu.northeast AS total,
	south,
	uhu.south:: numeric /(uhu.south + uhu.west + uhu.midwest + uhu.northeast) AS south_perc,
	west,
	uhu.west:: numeric /(uhu.south + uhu.west + uhu.midwest + uhu.northeast) AS west_perc,
	midwest,
	uhu.midwest:: numeric /(uhu.south + uhu.west + uhu.midwest + uhu.northeast) AS midwest_perc,
	northeast,
	uhu.northeast:: numeric /(uhu.south + uhu.west + uhu.midwest + uhu.northeast) AS northeast_perc
FROM tutorial.us_housing_units uhu
WHERE uhu."year" >= 2000;


/*
Practice Problem:
Write a query that returns all rows for which Ludacris was a member of the group.
*/

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye.group_name LIKE '%Ludacris%';


/*
Practice Problem:
Write a query that returns all rows for which the first artist listed in the group has a name that begins with "DJ".
*/
SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye.group_name LIKE '%DJ%';


 /*
Practice Problem
Write a query that shows all top 100 songs from January 1, 1985 through December 31, 1990. 
 */

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye."year" BETWEEN 1985 AND 1990;


SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE artist IS NULL;


/*
Practice Problem
Write a query that surfaces all rows for top-10 hits for which Ludacris is part of the Group.
*/   

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	btye.year_rank <= 10 AND
	btye.group_name ILIKE '%Ludacris%';


/*
Practice Problem
Write a query that surfaces the top-ranked records in 1990, 2000, and 2010.
*/

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	btye.year_rank = 1 AND 
	btye."year" IN (1990, 2000, 2010);
   
	
/*
Practice Problem
Write a query that lists all songs from the 1960s with "love" in the title.
*/ 

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	btye."year" BETWEEN 1960 AND 1969 AND 
	btye.song_name ILIKE '%love%';


/*
Practice Problem
Write a query that returns all rows for top-10 songs that featured either Katy Perry or Bon Jovi.
*/
SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	btye.year_rank <= 10 AND
	(btye.group_name ILIKE '%Katy Perry%' OR btye.group_name ILIKE '%Bon Jovi%');  


/*
Practice Problem:
Write a query that returns all songs with titles that contain the word "California" in either the 1970s or 1990s.
*/
SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	((btye."year" BETWEEN 1970 AND 1979) OR (btye."year" BETWEEN 1990 AND 1999)) AND 
	btye.song_name ILIKE '%California%';

/*
Practice Problem
Write a query that lists all top-100 recordings that feature Dr. Dre before 2001 or after 2009.
*/

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	btye.year_rank <= 100 AND 
	btye.group_name ILIKE '%Dr. Dre%' AND
	(btye."year" < 2001 OR btye."year" > 2009);


/*
Practice Problem
Write a query that returns all rows for songs that were on the charts in 2013 and do not contain the letter "a".
*/
SELECT * 
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye."year" = 2013 AND btye.song_name NOT ILIKE '%a%';


 /*
 Practice Problem
Write a query that returns all rows from 2012, ordered by song title from Z to A.
 */

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye."year" = 2012
ORDER BY btye.song_name DESC; 


/* Problem - query makes the most recent years come first but orders top-ranks songs before lower-ranked songs 
   and show only top 3 ranks.
   Below, data is sorted by column year first and then it is sorted by column year_rank.
*/

SELECT * 
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye.year_rank <=3
ORDER BY 
	btye."year" DESC, 
	year_rank ASC;


/*
	Practice Problem
	Write a query that returns all rows from 2010 ordered by rank, with artists ordered alphabetically for each song.
*/

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye."year" = 2012
ORDER BY 
	btye.year_rank ASC,  
	btye.song_name ASC; 


/*
	Practice Problem
	Write a query that shows all rows for which T-Pain was a group member, ordered by rank on the charts, 
	from lowest to highest rank (from 100 to 1).
*/

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE btye.group_name ILIKE '%T-Pain%'
ORDER BY btye.year_rank DESC; 


/*
	Practice Problem:
	Write a query that returns songs that ranked between 10 and 20 (inclusive) in 1993, 2003, or 2013. 
	Order the results by year and rank, and leave a comment on each line of the WHERE clause to indicate 
	what that line does.
*/

SELECT *
FROM tutorial.billboard_top_100_year_end btye 
WHERE 
	(btye.year_rank BETWEEN 10 AND 20) AND 		-- select year_rank between 10 & 20, inclusive
	(btye."year" IN (1993, 2003, 2013))			-- combines above condition (AND) with year filter 1993 or 2003 or 2013
ORDER BY btye."year", btye.year_rank;  	





