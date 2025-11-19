-- CTE (Common TABLE Expression) OR WITH Clause OR Subquery Factoring - 

/*
 * CTE Advantages:
 * 	1. More readable
 * 	2. Performance is increased
 * 	3. Can be used as an alternate of Creating view or creating temporary table. 
 *	4. When to use CTE - when you are using subquery more than once in your solution. 
 **/


create table emp
( emp_ID int
, emp_NAME varchar(50)
, SALARY int);

insert into emp values(101, 'Mohan', 40000);
insert into emp values(102, 'James', 50000);
insert into emp values(103, 'Robin', 60000);
insert into emp values(104, 'Carol', 70000);
insert into emp values(105, 'Alice', 80000);
insert into emp values(106, 'Jimmy', 90000);


select * 
from emp;


-- QUERY 1 : Fetch employee who earn more than average salary of all employee.

-- ERROR: aggregate functions are not allowed in WHERE. So below query will not work.
SELECT * 
FROM emp e
WHERE e.salary > avg(e.salary);


-- using subquery in WHERE
SELECT e.* 
FROM emp e
WHERE e.salary > 
				(
				 SELECT avg(salary)
				 FROM emp
				);


-- using WITH clause/CTE
WITH avg_salary(avg_sal) AS 
							(
								SELECT avg(salary)
								FROM emp
							)
SELECT *
FROM emp e, avg_salary av
WHERE e.salary > av.avg_sal;

/*  
 * 	Order of execution in above query - 
	WITH 
	FIRST associated query with WITH clause (select cast(avg(salary) as int) from emp)
	Assigning above value to avg_salary(avg_sal) table 
	FROM in main query
	WHERE in main query
	SELECT in main query
*/


-- avg_salary is CTE - Common Table Expression, we will print it below to understand it.
-- It's a table having 1 row and 1 column. Column name is avg_sal

with avg_salary(avg_sal) as
		(
		select cast(avg(salary) as int) 
		from emp
		)
SELECT *
FROM avg_salary;


-- Industry-standard (cleaner, more explicit) way is as below, using Cross/Cartesian join - 

WITH avg_salary(avg_sal) as
							(
								SELECT avg(salary)
								FROM emp
							)
SELECT *
FROM emp e
CROSS JOIN avg_salary av
WHERE e.salary > av.avg_sal;


-- CROSS Join/ cartesian Join of emp and avg_salary tables (for practice & understanding)

WITH avg_salary(avg_sal) AS (
    SELECT cast(avg(salary) AS int) 
    FROM emp
)
SELECT *
FROM emp
CROSS JOIN avg_salary;


-- using WITH clause and Inner Join:

WITH avg_sal(avg_salary) AS
		(
		SELECT cast(avg(salary) AS int) 
		FROM emp
		)
SELECT *
FROM emp e
INNER JOIN avg_sal av 
ON e.salary > av.avg_salary;

/* Order of execution - 
 *  WITH 
	FIRST associated query with WITH clause (select cast(avg(salary) as int) from emp)
	Assigning above value to avg_salary(avg_sal) table 
	FROM in main query
	Join
	ON
	SELECT in main query
 */



----------------------------------------------------------------------------------------

create table IF NOT EXISTS customer.sales
(
	store_id  		int,
	store_name  	varchar(50),
	product			varchar(50),
	quantity		int,
	cost			int
);


insert into sales values
(1, 'Apple Originals 1','iPhone 12 Pro', 1, 1000),
(1, 'Apple Originals 1','MacBook pro 13', 3, 2000),
(1, 'Apple Originals 1','AirPods Pro', 2, 280),
(2, 'Apple Originals 2','iPhone 12 Pro', 2, 1000),
(3, 'Apple Originals 3','iPhone 12 Pro', 1, 1000),
(3, 'Apple Originals 3','MacBook pro 13', 1, 2000),
(3, 'Apple Originals 3','MacBook Air', 4, 1100),
(3, 'Apple Originals 3','iPhone 12', 2, 1000),
(3, 'Apple Originals 3','AirPods Pro', 3, 280),
(4, 'Apple Originals 4','iPhone 12 Pro', 2, 1000),
(4, 'Apple Originals 4','MacBook pro 13', 1, 2500);

select * from customer.sales;


-- QUERY 2 : Find stores who's sales is better than the average sales accross all stores. 
--			 (Note:There are total 4 stores) 

-- We will divide above query in these 3 steps -  
-- 1. Find total sales per each store
-- 2. Find average sales with respect to all stores
-- 3. Find stores who's sales is better than the average sales accross all stores 


-- 1. Find total sales per each store -- total_sales_per_store
select 
	s.store_id, 
	sum(s.cost) as total_sales_per_store
from sales s
group by s.store_id
ORDER BY s.store_id; 


-- 2. Find average sales with respect to all stores -- avg_sale_for_all_store
SELECT
	avg(x.total_sales_per_store) AS avg_sale_for_all_store
FROM 
	(
		SELECT 
			s.store_id, 
			sum(s.cost) as total_sales_per_store
		FROM sales s
		GROUP BY s.store_id
		ORDER BY s.store_id
	) AS x;


-- 3. (Without using WITH clause) Find stores who's sales is better than the average sales accross all stores 

SELECT *
FROM   (
			SELECT 
				s.store_id, 
				sum(s.cost) AS total_sales_per_store
			FROM sales s
			GROUP BY s.store_id
			ORDER BY s.store_id
	   ) AS total_sales 
	   
INNER JOIN (
		SELECT
			avg(x.total_sales_per_store) AS avg_sale_for_all_store
		FROM 
		(SELECT 
			s.store_id, 
			sum(s.cost) as total_sales_per_store
		FROM sales s
		GROUP BY s.store_id
		ORDER BY s.store_id
		) AS x
	) AS avg_sales
	   
ON total_sales.total_sales_per_store > avg_sales.avg_sale_for_all_store;

/*
 	
  SELECT *
  FROM 
	(
		subquery1
	)
  INNER JOIN
  	(
  		subquery2
  		(
  			subquery1
  		)
  	)
  ON Condition;
  	
 */


-- 3. (Using WITH clause) Find stores who's sales is better than the average sales accross all stores 


WITH total_sales(store_id, total_sales_per_store) AS 
		(
			SELECT 
				s.store_id, 
				sum(s.cost) AS total_sales_per_store
			FROM sales s
			GROUP BY s.store_id
			ORDER BY s.store_id
		),

	avg_sales(avg_sale_for_all_store) AS 
		(
			SELECT
				avg(total_sales.total_sales_per_store) AS avg_sale_for_all_store
			FROM total_sales		
		)
		
SELECT *
FROM total_sales ts
INNER JOIN avg_sales av
ON ts.total_sales_per_store > av.avg_sale_for_all_store;


/*
 
WITH
 	CTE1 AS 
		 	(
		 	
		 	),
 	CTE2 AS 
		 	(
		 	
		 	),
 	CTE3 AS 
		 	(
		 	
		 	)
 	
SELECT *
FROM 
JOIN
On;
 	
*/


/*
 
 Order of Execution:
 	WITH Clause
 	total_sales query
 	avg_sales query
 	FROM total_sales ts  
 	INNER JOIN avg_sales av
	ON
	SELECT *
	
*/








