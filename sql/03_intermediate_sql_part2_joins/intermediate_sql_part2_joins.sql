-- ========================================
-- -- SQL Joins
-- ========================================   

/*
Practice Problem
Write a query that selects the school name, player name, position, and weight for every player in Georgia, 
ordered by weight (heaviest to lightest). Be sure to make an alias for the table, and to reference all 
column names in relation to the alias.
*/
SELECT 
      players.full_school_name, 
      players.school_name, 
      players.player_name, 
      players.position, 
      players.weight
FROM benn.college_football_players players 
WHERE players.state = 'GA'
ORDER BY players.weight DESC;

/*
you might have a table called schools with a field called id, which could be joined against 
school_id in any other table. These relationships are sometimes called "mappings." teams.school_name 
and players.school_name, the two columns that map to one another, are referred to as "foreign keys" or "join keys." 
Their mapping is written as a conditional statement:
*/
ON teams.school_name = players.school_name

SELECT *
FROM benn.college_football_players players
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name;
-- 26298

SELECT * 
FROM benn.college_football_teams teams
JOIN benn.college_football_players players
ON teams.school_name = players.school_name;
-- 26298

-- ========================================
-- -- SQL INNER JOIN
-- ========================================   
/*
 Inner joins eliminate rows from both tables that do not satisfy the join condition set forth in the ON 
 statement. 
 In mathematical terms, an inner join is the intersection of the two tables.
*/

SELECT 
      players.school_name AS players_school_name,
      teams.school_name AS teams_school_name
FROM benn.college_football_players players
INNER JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name;

/*
Practice Problem
Write a query that displays player names, school names and conferences for schools in the 
"FBS (Division I-A Teams)" division.
*/
SELECT 
      players.player_name, 
      players.school_name, 
      teams.conference, 
      teams.division
FROM benn.college_football_players players
INNER JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name
WHERE teams.division = 'FBS (Division I-A Teams)'; 

-- ========================================
-- -- SQL OUTER JOIN
-- ========================================   
Follow for understanding JOIN visually - https://joins.spathon.com/

-- ========================================
-- -- SQL LEFT JOIN
-- ========================================   
-- Inner Join 
SELECT 
      COUNT(*) OVER () AS total_rows,
      companies.permalink AS companies_permalink,
      companies.name AS companies_name,
      acquisitions.company_permalink AS acquisitions_permalink,
      acquisitions.acquired_at AS acquisitions_acquired_date
FROM tutorial.crunchbase_companies AS companies 
JOIN tutorial.crunchbase_acquisitions AS acquisitions
ON companies.permalink = acquisitions.company_permalink;
-- 1673

-- LEFT JOIN
SELECT COUNT(*) OVER () AS total_rows, *
FROM tutorial.crunchbase_companies AS companies 
LEFT JOIN tutorial.crunchbase_acquisitions AS acquisitions
ON companies.permalink = acquisitions.company_permalink;
-- 27355

SELECT 
      COUNT(*) OVER() AS total_row_count,
      companies.permalink AS companies_permalink,
      companies.name AS companies_name,
      acquisitions.company_permalink AS acquisitions_permalink,
      acquisitions.acquired_at AS acquisitions_acquired_date
FROM tutorial.crunchbase_companies AS companies 
LEFT JOIN tutorial.crunchbase_acquisitions AS acquisitions
ON companies.permalink = acquisitions.company_permalink;
-- 27355

/*
The LEFT JOIN command tells the database to return all rows in the table in the FROM clause, 
regardless of whether or not they have matches in the table in the LEFT JOIN clause.
*/

/*
Practice Problem
Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table 
and the tutorial.crunchbase_companies table, but instead of listing individual rows, count the 
number of non-null rows in each table.
*/
SELECT 
      a.company_permalink, 
      c.permalink,
      COUNT(*) OVER()
FROM tutorial.crunchbase_acquisitions AS a
INNER JOIN tutorial.crunchbase_companies AS c
ON a.company_permalink = c.permalink;
-- 1673

-- Alternate solution
SELECT 
      COUNT(c.permalink) AS companies_rowcount,
      COUNT(a.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_acquisitions AS a
INNER JOIN tutorial.crunchbase_companies AS c
ON a.company_permalink = c.permalink;
-- companies_rowcount=1673, acquisitions_rowcount=1673

/*
Practice Problem
Modify the query above to be a LEFT JOIN. Note the difference in results.
*/

SELECT
      COUNT(*) OVER(),
      *
      -- COUNT(a.company_permalink) AS acquisitions_rowcount,
      -- COUNT(c.permalink) AS companies_rowcount
FROM tutorial.crunchbase_acquisitions AS a
LEFT JOIN tutorial.crunchbase_companies AS c
ON a.company_permalink = c.permalink;
-- Total rows in results are 7414

SELECT
      COUNT(a.company_permalink) AS acquisitions_rowcount,
      COUNT(c.permalink) AS companies_rowcount
FROM tutorial.crunchbase_acquisitions AS a
LEFT JOIN tutorial.crunchbase_companies AS c
ON a.company_permalink = c.permalink;
-- acquisitions_rowcount=7414, companies_rowcount = 1673

/*
LEFT JOIN of table tutorial.crunchbase_companies with table tutorial.crunchbase_acquisitions
*/
SELECT
      COUNT(a.permalink) AS companies_rowcount,
      COUNT(c.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_companies AS a
LEFT JOIN  tutorial.crunchbase_acquisitions AS c
ON a.permalink = c.company_permalink;
-- companies_rowcount=27355, acquisitions_rowcount=1673

-- I can derive same above output with RIGHT JOIN
SELECT
      COUNT(a.company_permalink) AS acquisitions_rowcount,
      COUNT(c.permalink) AS companies_rowcount
FROM tutorial.crunchbase_acquisitions AS a
RIGHT JOIN tutorial.crunchbase_companies AS c
ON a.company_permalink = c.permalink;
-- companies_rowcount=27355, acquisitions_rowcount=1673


/*
Practice Problem
Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
Do not include results for which there is no state data, and order by the number of acquired companies from highest to lowest.
*/

SELECT
      *
FROM tutorial.crunchbase_companies AS companies
LEFT JOIN  tutorial.crunchbase_acquisitions AS acquisitions
ON companies.permalink = acquisitions.company_permalink;
-- Rows 27355, columns 40

SELECT
      companies.state_code,
      COUNT(companies.permalink) AS unique_companies,
      COUNT(acquisitions.company_permalink) AS unique_companies_acquired
FROM tutorial.crunchbase_companies AS companies
LEFT JOIN  tutorial.crunchbase_acquisitions AS acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE companies.state_code IS NOT NULL 
GROUP BY companies.state_code
ORDER BY unique_companies_acquired DESC;
-- 51 rows

-- ========================================
-- -- SQL RIGHT JOIN
-- ========================================   
/*
It's worth noting that LEFT JOIN and RIGHT JOIN can be written as LEFT OUTER JOIN and RIGHT OUTER JOIN, respectively.
*/

/*
Practice Problem
Rewrite the previous practice query in which you counted total and acquired companies by state, but with a RIGHT JOIN 
instead of a LEFT JOIN. The goal is to produce the exact same results.
*/

SELECT
      companies.state_code,
      COUNT(companies.permalink) AS unique_companies,
      COUNT(acquisitions.company_permalink) AS unique_companies_acquired
FROM tutorial.crunchbase_acquisitions AS acquisitions
RIGHT JOIN  tutorial.crunchbase_companies AS companies
ON companies.permalink = acquisitions.company_permalink
WHERE companies.state_code IS NOT NULL 
GROUP BY companies.state_code
ORDER BY unique_companies_acquired DESC;

-- ========================================
-- -- SQL Joins Using WHERE or ON
-- ========================================   

SELECT 
       companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
ORDER BY companies.permalink;
-- Rows = 27355

SELECT 
       companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
AND acquisitions.company_permalink != '/company/1000memories'
ORDER BY companies.permalink;
-- Row = 27355
/*
SQL logical processing order:
1. FROM
2. LEFT JOIN
3. ON
4. AND  (part of the ON predicate)
5. SELECT
6. ORDER BY

AND is Part of the ON predicate” = it’s inside the boolean condition that defines the join match.
In this LEFT join, ON predicate is -

companies.permalink = acquisitions.company_permalink
AND acquisitions.company_permalink != '/company/1000memories'
*/

SELECT *
FROM tutorial.crunchbase_acquisitions acquisitions
WHERE acquisitions.company_permalink = '/company/1000memories';
-- rows = 1

-- Filtering in the WHERE clause
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE acquisitions.company_permalink != '/company/1000memories'
OR acquisitions.company_permalink IS NULL
ORDER BY companies.permalink;
-- Rows = 27354
/*
- WHERE: is evaluated after the join is completed.
-In a LEFT JOIN, rows with no match on the right have acquisitions.* = NULL.
-Your WHERE has:
  acquisitions.company_permalink != '/company/1000memories'
-In SQL, any comparison with NULL is UNKNOWN (not TRUE).
-The WHERE clause keeps only rows where the condition is TRUE.
-So all the NULL-right-side rows get filtered out → your LEFT JOIN behaves like an INNER JOIN.
-To keep unmatched left rows, you must allow the NULL case:

WHERE acquisitions.company_permalink != '/company/1000memories'
OR acquisitions.company_permalink IS NULL

SQL logical processing order:
1. FROM
2. LEFT JOIN … ON
3. WHERE
4. SELECT
5. ORDER BY
*/

/*
Practice Problem
Write a query that shows a company's name, "status" (found in the Companies table), and the number of 
unique investors in that company. Order by the number of investors from most to fewest. Limit to only 
companies in the state of New York.
*/
SELECT *
FROM tutorial.crunchbase_companies;
-- Rows = 27327, columns = 19 

SELECT *
FROM tutorial.crunchbase_investments;
-- Rows = 83893, columns = 21

SELECT COUNT(*)
FROM tutorial.crunchbase_companies companies
INNER JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink;
/*Out of 27327 companies, 66849 companies have investment. One company may have multiple 
investments, so rows count is more than 27327
*/
SELECT 
      companies.name, 
      companies.status
FROM tutorial.crunchbase_companies companies
WHERE companies.state_code = 'NY';
-- Rows = 1731

-- Actual answer to the Practice Problem 

SELECT 
      companies.name, 
      companies.status, 
      COUNT(DISTINCT(investments.investor_permalink)) AS NumberOfUniqueInvestor
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
WHERE companies.state_code = 'NY'
GROUP BY companies.name, companies.status
ORDER BY NumberOfUniqueInvestor DESC;
-- Rows = 1731

/*
Practice Problem
Write a query that lists investors based on the number of companies in which they are invested. Include a row for 
companies with no investor, and order from most companies to least.
*/

SELECT
      CASE 
          WHEN investments.investor_permalink IS NULL THEN 'No Investor'
          ELSE investments.investor_permalink 
      END AS investor,    
      COUNT(DISTINCT companies.permalink) AS total_no_companies_invested_in
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
GROUP BY investments.investor_permalink
ORDER BY total_no_companies_invested_in DESC;
      
-- Alternate Solution -      
SELECT
      investments.investor_permalink AS investors,
      COUNT(DISTINCT companies.permalink) AS total_no_companies_invested_in
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
AND investments.investor_permalink IS NOT NULL
GROUP BY investments.investor_permalink
ORDER BY total_no_companies_invested_in DESC;

-- ========================================
-- -- SQL FULL OUTER JOIN
-- ========================================   

/*
 - LEFT JOIN and RIGHT JOIN each return unmatched rows from one of the tables—
 - FULL JOIN returns unmatched rows from both tables. 
 - It is commonly used in conjunction with aggregations to understand the amount of overlap between two tables.
*/
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
FROM tutorial.crunchbase_companies companies
FULL JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
-- companies_only = 25682, both_tables = 1673, acquisitions_only = 5741

/*
Practice Problem
Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1 
using a FULL JOIN. Count up the number of rows that are matched/unmatched as in the example above.
*/
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments_part1.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments_part1.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND investments_part1.company_permalink IS NOT NULL
                  THEN investments_part1.company_permalink ELSE NULL END) AS investments_part1_only
FROM tutorial.crunchbase_companies companies
FULL JOIN tutorial.crunchbase_investments_part1 investments_part1
ON companies.permalink = investments_part1.company_permalink;

-- ========================================
-- -- SQL UNION
-- ========================================   

/* 
- SQL joins allow you to combine two datasets side-by-side, but UNION allows you to stack one dataset on 
  top of the other. 
- UNION only appends distinct values. 
- More specifically, when you use UNION, the dataset is appended, and any rows in the appended table(2nd table)
  that are exactly identical to rows in the first table are dropped.
- If you'd like to append all the values from the second table, use UNION ALL.
*/

/*
SQL has strict rules for appending data(for using UNION and UNION ALL):

1. Both tables must have the same number of columns
2. The columns must have the same data types in the same order as the first table
*/

SELECT *
FROM tutorial.crunchbase_investments_part1

UNION

SELECT *
FROM tutorial.crunchbase_investments_part2;
------------------------------------------------------------------

SELECT *
  FROM tutorial.crunchbase_investments_part1

 UNION ALL

 SELECT *
   FROM tutorial.crunchbase_investments_part2

------------------------------------------------------------------
/*
Practice Problem
Write a query that appends the two crunchbase_investments datasets above (including duplicate values). 
Filter the first dataset to only companies with names that start with the letter "T", and filter the 
second to companies with names starting with "M" (both not case-sensitive). Only include the company_permalink,
company_name, and investor_name columns.
*/

SELECT 
      investments_part1.company_permalink,
      investments_part1.company_name, 
      investments_part1.investor_name
FROM tutorial.crunchbase_investments_part1 investments_part1
WHERE investments_part1.company_name ILIKE 'T%'

UNION ALL 

SELECT 
      investments_part2.company_permalink,
      investments_part2.company_name, 
      investments_part2.investor_name
FROM tutorial.crunchbase_investments_part2 investments_part2
WHERE investments_part2.company_name ILIKE 'M%';
-- Rows = 4883

/*
Practice Problem
Write a query that shows 3 columns. The first indicates which dataset (part 1 or 2) the data comes from, 
the second shows company status, and the third is a count of the number of investors.

Hint: you will have to use the tutorial.crunchbase_companies table as well as the investments tables. 
And you'll want to group by status and dataset.
*/

SELECT 
      PART 1,
      COUNT (DISTINCT investments.investor_permalink)
FROM tutorial.crunchbase_companies companies
INNER JOIN tutorial.crunchbase_investments_part1 investments_part1
ON companies.permalink = investments_part1.company_permalink
GROUP BY companies.permalink, companies.status

UNION ALL 

SELECT 
FROM tutorial.crunchbase_investments_part1 investments_part2
