SELECT *
FROM
  tutorial.us_housing_units;

SELECT
  year,
  MONTH,
  month_name,
  south,
  west,
  midwest,
  northeast
FROM
  tutorial.us_housing_units;

year MONTH month_name south west midwest northeast -- -------------------------------------------------------------------------        
SELECT
  *
FROM
  tutorial.billboard_top_100_year_end
ORDER BY
  year DESC,
  year_rank;
-- ========================================
-- 
-- ========================================     
  

SELECT *
FROM tutorial.aapl_historical_stock_price;  
-- total rows = 3555

date
year
month
open
high
low
close
volume
id

-- -----------------------------------------------------------

SELECT * 
FROM benn.college_football_players
LIMIT 100;

SELECT count(*) 
FROM benn.college_football_players;
-- 26298

	school_name
	player_name
	position
	height
	weight
	year
	hometown
	state
	id

------------------------------------------------------------------------------------------------------------
--	Joins
	
SELECT * 
FROM benn.college_football_teams;
-- 252
	-- 	FBS (Division I-A Teams)
	--	FCS (Division I-AA Teams)


SELECT *
FROM benn.college_football_players;
-- 26298
-------------------------------------------------------------------------------------

--Left Join related database/tables

SELECT *
FROM tutorial.crunchbase_companies;
-- Rows = 27327, columns = 19 
/* 
	PRIMARY KEY is permalink
 */ 
SELECT count(permalink)
FROM tutorial.crunchbase_companies;
-- 27327


SELECT *
FROM tutorial.crunchbase_acquisitions;
-- Rows = 7414, columns = 21 
/*
	Here, foreign keys are 2 with 
*/
SELECT 
	count(company_permalink),
	count(acquirer_permalink)
FROM tutorial.crunchbase_acquisitions;	
-- count(company_permalink) = 7414, count(acquirer_permalink) = 7414

SELECT 
	count(DISTINCT company_permalink),
	count(DISTINCT acquirer_permalink)
FROM tutorial.crunchbase_acquisitions;		
/*
	count(DISTINCT company_permalink) = 7314
	count(DISTINCT acquirer_permalink) = 4062
*/	

SELECT *
FROM tutorial.crunchbase_investments;
-- Rows = 83893, columns = 21

/*
	tutorial.crunchbase_investments:- 
	This table is also sourced from Crunchbase and contains much of the same information as the 
	tutorial.crunchbase_companies data. It it structured differently, though: it contains one row per investment. 
	There can be multiple investments per company—it's even possible that one investor could invest in the same 
	company multiple times. The column names are pretty self-explanatory. What's important is that company_permalink 
	in the tutorial.crunchbase_investments table maps to permalink in the tutorial.crunchbase_companies table. 
*/

SELECT *
FROM tutorial.crunchbase_investments_part1;
-- Rows = 42483 columns = 21 

SELECT *
FROM tutorial.crunchbase_investments_part2;
-- Rows = 41410 columns = 21 
-------------------------------------------------------------------------------------------