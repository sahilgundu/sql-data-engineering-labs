-- ========================================
-- -- SQL Aggregate Functions
-- ========================================   

/* Arithmetic operators only perform operations across rows. Aggregate functions are used to perform 
operations across entire columns (which could include millions of rows of data or more).*/


-- ========================================
-- -- SQL COUNT
-- ========================================   
SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price;

SELECT COUNT(2)
  FROM tutorial.aapl_historical_stock_price;

-- The following code will provide a count of all of rows in which the high column is not null.
SELECT COUNT(high)
  FROM tutorial.aapl_historical_stock_price;

/*
Practice Problem
Write a query to count the number of non-null rows in the low column.
*/
SELECT count(low) AS "Low_NonNull_Count"
FROM tutorial.aapl_historical_stock_price;

-- Counting non-numerical columns
SELECT COUNT(date) AS count_of_date_column
  FROM tutorial.aapl_historical_stock_price;
  
/*
Practice Problem
Write a query that determines counts of every single column. With these counts, 
can you tell which column has the most null values?
*/  

SELECT 
  COUNT(date) AS count_of_date, 
  COUNT(year) AS count_of_year, 
  COUNT(month) AS count_of_month, 
  COUNT(open) AS count_of_open, 
  COUNT(high) AS count_of_high, 
  COUNT(low) AS count_of_low,
  COUNT(close) AS count_of_close,
  COUNT(volume) AS count_of_volume,
  COUNT(id) AS count_of_id
FROM tutorial.aapl_historical_stock_price;


-- ========================================
-- -- SQL SUM
-- ========================================   
-- Unlike COUNT, you can only use SUM on columns containing numerical values.

SELECT SUM(volume)
  FROM tutorial.aapl_historical_stock_price;

/*
An important thing to remember: aggregators only aggregate vertically. If you want to perform a calculation across 
rows, you would do this with simple arithmetic.

You don't need to worry as much about the presence of nulls with SUM as you would with COUNT, as SUM treats nulls as 0.
*/

/*
Practice Problem
Write a query to calculate the average opening price (hint: you will need to use both COUNT and SUM, as well as some 
simple arithmetic.).
*/
SELECT sum(open)/ count(open) AS "average opening price"
FROM tutorial.aapl_historical_stock_price;

-- ========================================
-- -- SQL MIN/MAX
-- ========================================   
/*
	MIN and MAX are SQL aggregation functions that return the lowest and highest values in a particular column.
	
	They're similar to COUNT in that they can be used on non-numerical columns. 
	
	Depending on the column type, 
	MIN will return the lowest number, earliest date, or non-numerical value as close alphabetically to "A" as possible. 
	As you might suspect, MAX does the opposite—it returns the highest number, the latest date, or the non-numerical 
	value closest alphabetically to "Z."
*/

SELECT MIN(volume) AS min_volume,
       MAX(volume) AS max_volume
FROM tutorial.aapl_historical_stock_price;

/*
	Practice Problem
	What was Apple's lowest stock price (at the time of this data collection)?
*/
SELECT MIN(low) AS lowest_stock_price
FROM tutorial.aapl_historical_stock_price;

/*
Practice Problem - very good problem
What was the highest single-day increase in Apple's share value?
*/
SELECT MAX(close - open) AS highest_single_day_increase
FROM tutorial.aapl_historical_stock_price;


-- ========================================
-- -- SQL AVARAGE
-- ========================================   
/*
AVG is a SQL aggregate function that calculates the average of a selected group of values. 
It's very useful, but has some limitations. First, it can only be used on numerical columns. 
Second, it ignores nulls completely. 
*/
SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price
 WHERE high IS NOT NULL;
--166.4377

SELECT AVG(high)   -- only non-null values are considered in denominator
FROM tutorial.aapl_historical_stock_price;
--166.4377

SELECT sum(high)/count(high) AS avarage_without_null_values  -- only non-null values are considered in denominator 
FROM tutorial.aapl_historical_stock_price;
--166.4377

SELECT sum(high)/count(*) AS avarage_with_null_values - -- all values inclusing non-null values are considered in denominator
FROM tutorial.aapl_historical_stock_price;
-- 165.3140 

/*
Practice Problem
Write a query that calculates the average daily trade volume for Apple stock.
*/
SELECT AVG(volume) as "average daily trade volume"
FROM tutorial.aapl_historical_stock_price;

-- ========================================
-- -- SQL GROUP BY
-- ========================================   

-- The SQL GROUP BY clause
SELECT year, count(*)
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year;

SELECT count(*)
FROM tutorial.aapl_historical_stock_price
GROUP BY year;

-- GROUP BY multiple columns
SELECT year, month, count(*)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;

/*
Practice Problem - very good and very difficult problem
Calculate the total number of shares traded each month. Order your results chronologically.
*/
SELECT year, month, sum(volume)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;

-- ========================================
-- Using GROUP BY with ORDER BY
-- ========================================    

SELECT year, month, sum(volume)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;

SELECT year, month, sum(volume)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month
LIMIT 100;

-- simply put, LIMIT is applicable to FINAL RESULT. 

/*
Practice Problem - Good Problem
Write a query to calculate the average daily price change in Apple stock, grouped by year.
*/
SELECT year, AVG(close - open)
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year;

/*
Practice Problem
Write a query that calculates the lowest and highest prices that Apple stock achieved each month.
*/
-- This is correct solution
SELECT 
    year, 
    month, 
    MIN(low), 
    MAX(high)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;

-- This is incorrect solution
SELECT month, MIN(low), MAX(high)
FROM tutorial.aapl_historical_stock_price
GROUP BY month
ORDER BY month;


-- ========================================
-- -- SQL HAVING
-- ========================================   

/*
The WHERE clause won't work for this because it doesn't allow you to filter on aggregate columns—that's 
    where the HAVING clause comes in:
Note: HAVING is the "clean" way to filter a query that has been aggregated, but this is also commonly done 
    using a subquery.
  
WHERE - non-aggregated columns only - before aggregation
HAVING - aggregated columns  - after aggregation, but HAVING can be used on GROUPED Columns like year in below query 
but generally, it is used for aggregate values.
*/

SELECT 
    year, 
    month, 
    MAX(high)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING MAX(high) > 400
ORDER BY year, month;

SELECT *
FROM tutorial.aapl_historical_stock_price
WHERE year = 2014
LIMIT 100;

-- HAVING used for GROUPED column, faced no error
SELECT 
    year, 
    month, 
    MAX(high)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING year > 2011
ORDER BY year, month;

-- WHERE used for GROUPED column, faced syntax error
SELECT 
    year, 
    month, 
    MAX(high)
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
WHERE year > 2011
ORDER BY year, month;

/*
Query clause order - 
As mentioned in prior lessons, the order in which you write the clauses is important. Here's the order for everything you've learned so far:

SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY

When to use all three?
Whenever you need to:
1. Filter data before aggregation (WHERE)
2. Group data (GROUP BY)
3. Filter after aggregation (HAVING)
*/

-- Very Important Query where I have used WHERE, GROUP BY, HAVING

SELECT 
    year, 
    month, 
    MAX(high) AS max_high
FROM tutorial.aapl_historical_stock_price
WHERE high < 500   -- Filter data before aggregation (WHERE)
GROUP BY year, month  -- Group data (GROUP BY)
HAVING MAX(high) > 400  -- Filter after aggregation (HAVING)
ORDER BY year, month;

-- ========================================
-- -- SQL CASE
-- ========================================   

-- Dataset used for this queries - 

/*
1. The CASE statement always goes in the SELECT clause
2. CASE must include the following components: WHEN, THEN, and END. ELSE is an optional component.
3. You can make any conditional statement using any conditional operator (like WHERE ) between WHEN and THEN. 
    This includes stringing together multiple conditional statements using AND and OR.
4. You can include multiple WHEN statements, as well as an ELSE statement to deal with any unaddressed conditions.
*/

SELECT * 
FROM benn.college_football_players;

-- The SQL CASE statement
/*
Problem Statement - 
here's what's happening:

1. The CASE statement checks each row to see if the conditional statement—year = 'SR' is true.
2. For any given row, if that conditional statement is true, the word "yes" gets printed in the column that we have named is_a_senior.
3. In any row for which the conditional statement is false, nothing happens in that row, leaving a null value in the is_a_senior column.
4. At the same time all this is happening, SQL is retrieving and displaying all the values in the player_name and year columns.
*/

SELECT
      player_name,
      year,
      CASE WHEN year = 'SR' THEN 'YES'
           ELSE NULL END 
          -- AS is_a_senior
FROM benn.college_football_players
LIMIT 100;

SELECT
      player_name,
      year,
      CASE WHEN year = 'SR' THEN 'YES'
           ELSE NULL END AS is_a_senior
FROM benn.college_football_players
LIMIT 100;

/* 
   In SELECT statement, CASE creates new column because it is written in place of column name. 
   Otherwise CASE don't create new column as such.
*/

SELECT
      player_name,
      year,
      CASE WHEN year = 'SR' THEN 'Yes'
           ELSE 'No' END AS is_a_senior
FROM benn.college_football_players
LIMIT 100;

/*
Practice Problem - Very Important problem as we are using ORDER BY on column, created Run-time.
Write a query that includes a column that is flagged "yes" when a player is from California, 
and sort the results with those players first.
*/
SELECT
      player_name,
      state,
      CASE WHEN state = 'CA' THEN 'yes'
           ELSE NULL END AS is_from_california
FROM benn.college_football_players
ORDER BY is_from_california;

-- ========================================
-- ORDER OF EXECUTION IN SQL
-- ========================================   

SELECT
      player_name,
      state AS state_name
FROM benn.college_football_players
LIMIT 100;

SELECT
      player_name,
      state AS state_name
FROM benn.college_football_players
WHERE state = 'CA'
LIMIT 100;

SELECT
      player_name,
      state AS state_name
FROM benn.college_football_players
WHERE state_name = 'CA'
LIMIT 100;

-- ------------------------------------------------------------------------------------------------

-- Adding multiple conditions to a CASE statement
SELECT
      player_name,
      weight,
      CASE WHEN weight > 250 THEN 'over 250'
           WHEN weight > 200 THEN '201-250'
           WHEN weight > 150 THEN '151-200'
           ELSE '150 or under' 
      END AS weight_group
FROM benn.college_football_players;

/*
Best Practice Rule-
Always order your WHEN clauses from most specific/restrictive to least restrictive—i.e., highest boundary to lowest.
*/

SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 AND weight <= 250 THEN '201-250'
            WHEN weight > 175 AND weight <= 200 THEN '176-200'
            ELSE '175 or under' 
       END AS weight_group
  FROM benn.college_football_players;


/*
Practice Problem
Write a query that includes players' names and a column that classifies them into four categories based on height.
Keep in mind that the answer we provide is only one of many possible answers, since you could divide players' heights in many ways.
*/

SELECT
      MIN(height) AS max_height,
      MAX(height) AS min_height
FROM benn.college_football_players;

SELECT  
      player_name,
      height,
      CASE WHEN height >= 75 AND height <= 83 THEN 'Very Good height'
           WHEN height >= 65 AND height <= 74 THEN 'Good height'
           WHEN height >= 55 AND height <= 64 THEN 'Avarage height'
           ELSE 'Less height' 
      End AS height_group
FROM benn.college_football_players;



/*
Practice Problem
Write a query that selects all columns from benn.college_football_players and adds an additional column that 
displays the player's name if that player is a junior or senior.
*/
SELECT 
      school_name,
      player_name,
      position,
      height,
      weight,
      year,
      hometown,
      state,
      id,
      CASE WHEN year = 'SR' THEN player_name
           WHEN year = 'JR' THEN player_name
           ELSE NULL
      END AS player_sr_jr
FROM benn.college_football_players;

SELECT 
      *,
      CASE WHEN year IN ('SR', 'JR') THEN player_name
           ELSE NULL
      END AS player_sr_jr
FROM benn.college_football_players;

-- Using CASE with aggregate functions

SELECT COUNT(*) AS fr_count
FROM benn.college_football_players
WHERE year = 'FR';

-- Not understood
SELECT 
      CASE WHEN year = 'FR' THEN 'FR'
           ELSE 'Not FR' END AS year_group,
            COUNT(*) AS count
FROM benn.college_football_players
GROUP BY 
        CASE WHEN year = 'FR' THEN 'FR'
             ELSE 'Not FR' END;

-- Not understood
SELECT 
      CASE WHEN year = 'FR' THEN 'FR'
           ELSE 'Not FR' 
      END AS year_group,
      COUNT(*) AS count
FROM benn.college_football_players
GROUP BY 
        year;

-- counting multiple conditions in one query:
SELECT 
      CASE  WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' 
      END AS year_group,
      COUNT(1) AS count
FROM benn.college_football_players
GROUP BY 1;

SELECT 
      CASE  WHEN year = 'FR' THEN 'FR_CASE'
            WHEN year = 'SO' THEN 'SO_CASE'
            WHEN year = 'JR' THEN 'JR_CASE'
            WHEN year = 'SR' THEN 'SR_CASE'
            ELSE 'No Year Data' 
      END AS year_group,
      COUNT(*) AS count
FROM benn.college_football_players
GROUP BY year;

-- Below query without CASE and above query with CASE is giving exactly same output.
SELECT COUNT(*) AS count
FROM benn.college_football_players
GROUP BY year;














/*
Practice Problem
Write a query that counts the number of 300lb+ players for each of the following regions: West Coast (CA, OR, WA), 
Texas, and Other (everywhere else).
*/

/*
Practice Problem
Write a query that calculates the combined weight of all underclass players (FR/SO) in California 
as well as the combined weight of all upperclass players (JR/SR) in California.
*/

-- Using CASE inside of aggregate functions


/*
Practice Problem
Write a query that displays the number of players in each state, with FR, SO, JR, and SR players in separate columns 
and another column for the total number of players. Order results such that states with the most players come first.
*/

/*
Practice Problem
Write a query that shows the number of players at schools with names that start with A through M, and the number 
at schools with names starting with N - Z.
*/


-- ========================================
-- -- SQL DISTINCT
-- ========================================   

-- Using SQL DISTINCT for viewing unique values

SELECT DISTINCT month
FROM tutorial.aapl_historical_stock_price
ORDER BY month;

-- If you include two (or more) columns in a SELECT DISTINCT clause, your results will contain all of the 
-- unique pairs of those two columns:

SELECT DISTINCT year, month
FROM tutorial.aapl_historical_stock_price
ORDER BY year, month;

/*
Practice Problem
Write a query that returns the unique values in the year column, in chronological order.
*/
SELECT DISTINCT year
FROM tutorial.aapl_historical_stock_price
ORDER BY year;

-- Using DISTINCT in aggregations
SELECT month
FROM tutorial.aapl_historical_stock_price;

SELECT COUNT(DISTINCT month)
FROM tutorial.aapl_historical_stock_price;

-- DISTINCT performance
-- It's worth noting that using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.

/*
Practice Problem - Good Problem
Write a query that counts the number of unique values in the month column for each year.
*/
SELECT year, COUNT(DISTINCT month)
FROM tutorial.aapl_historical_stock_price
GROUP BY year;

/*
Practice Problem
Write a query that separately counts the number of unique values in the month column and the number of 
unique values in the `year` column.
*/
SELECT 
      COUNT (DISTINCT year) as "DISTINCT_year_count", 
      COUNT (DISTINCT month) as "DISTINCT_month_count"
FROM tutorial.aapl_historical_stock_price;


