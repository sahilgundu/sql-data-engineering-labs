SELECT *
FROM benn.college_football_teams cft 
INNER JOIN benn.college_football_players cfp 
ON cft.school_name = cfp.school_name; 


SELECT 
	cft.school_name AS players_school_name,
	cfp.school_name AS teams_school_name
FROM benn.college_football_teams cft 
INNER JOIN benn.college_football_players cfp 
ON cft.school_name = cfp.school_name; 


/*
Practice Problem:
	Write a query that displays player names, school names and conferences for schools in the 
	"FBS (Division I-A Teams)" division.
*/

SELECT 
	cfp.player_name ,
	cfp.school_name ,
	cft.conference 
FROM benn.college_football_teams cft 
INNER JOIN benn.college_football_players cfp 
ON cfp.school_name = cft.school_name 
WHERE cft.division = 'FBS (Division I-A Teams)' 		
	 

/*
Practice Problem:
	Write a query that displays player names, school names and conferences for schools in the 
	"FBS (Division I-A Teams)" division.
*/

SELECT 
	cfp.player_name, 
	cfp.school_name,
	cft.conference 
FROM benn.college_football_players cfp 
INNER JOIN benn.college_football_teams cft 
ON cfp.school_name = cft.school_name 
WHERE cft.division = 'FBS (Division I-A Teams)'


/*
	Practice Problem:
	Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table 
	and the tutorial.crunchbase_companies table, but instead of listing individual rows, count the 
	number of non-null rows in each table.
*/

SELECT *
--	count(cc.permalink) AS rows_in_crunchbase_companies,
--	count(ca.company_permalink) AS rows_in_crunchbase_acquisitions
FROM tutorial.crunchbase_companies cc 
INNER JOIN tutorial.crunchbase_acquisitions ca 
ON cc.permalink = ca.company_permalink;


SELECT
	count(*),
	count(cc.permalink) AS rows_in_crunchbase_companies,
	count(ca.company_permalink) AS rows_in_crunchbase_acquisitions
FROM tutorial.crunchbase_companies cc 
LEFT JOIN tutorial.crunchbase_acquisitions ca 
--LEFT JOIN tutorial
ON cc.permalink = ca.company_permalink;


/*
Practice Problem: important, good problem: 
	Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
	Do not include results for which there is no state data, and order by the number of acquired companies from highest 
	to lowest.	 
	
*/

DESCRIBE tutorial.crunchbase_companies;  -- DESCRIBE is a MySQL command — doesn't work in PostgreSQL. 

SELECT *
FROM information_schema.columns
WHERE table_name = 'crunchbase_companies';


SELECT 
	cc.state_code,
	count(DISTINCT(cc.permalink)) AS companies_number_per_state	 
FROM tutorial.crunchbase_companies cc 
WHERE 
	cc.state_code IS NOT NULL AND
	NULLIF(cc.state_code, '') IS NOT NULL     			-- price_amount != '' Note: here, we are finding blank string
														-- https://claude.ai/chat/c2b3f09f-a55f-48f4-bf3b-961624ba9a1e	
GROUP BY cc.state_code
ORDER BY companies_number_per_state DESC;


SELECT 
	ca.company_state_code,
	count(DISTINCT(ca.company_permalink)) AS aquired_companies_per_state	  
FROM tutorial.crunchbase_acquisitions ca 
WHERE 
	ca.company_state_code IS NOT NULL AND 
	NULLIF (ca.company_state_code, '') IS NOT NULL 
GROUP BY ca.company_state_code
ORDER BY aquired_companies_per_state DESC;


-- Below is LEFY JOIN for this problem.

SELECT
	cc.state_code,
	count(DISTINCT(cc.permalink)) AS companies_number_per_state,
	count(DISTINCT(ca.company_permalink)) AS aquired_companies_per_state	 	
FROM tutorial.crunchbase_companies cc 
LEFT JOIN tutorial.crunchbase_acquisitions ca
On cc.permalink = ca.company_permalink
WHERE 
	cc.state_code IS NOT NULL AND
	NULLIF(cc.state_code, '') IS NOT NULL  
GROUP BY cc.state_code
ORDER BY companies_number_per_state DESC;

-- 51 rows in result set


/*
Practice Problem
Write a query that shows a company's name, "status" (found in the Companies table), and the number of 
unique investors in that company. Order by the number of investors from most to fewest. Limit to only 
companies in the state of New York.

a company's name, 
"status" (found in the Companies table), and 
the number of unique investors in that company. 
Order by the number of investors 
	from most to fewest. 
Limit to only companies in the state of New York.
*/

SELECT 
	cc."name" ,
	cc.status 
	
FROM tutorial.crunchbase_companies cc 
RIGHT JOIN tutorial.crunchbase_investments ci 
WHERE companies in the state of New York
ORDER BY number of investors from most to fewest
companies in the state of New York













