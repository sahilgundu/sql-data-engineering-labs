create table IF NOT EXISTS employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

--insert into employee values(101, 'Mohan', 'Admin', 4000);
--insert into employee values(102, 'Rajkumar', 'HR', 3000);
--insert into employee values(103, 'Akbar', 'IT', 4000);
--insert into employee values(104, 'Dorvin', 'Finance', 6500);
--insert into employee values(105, 'Rohit', 'HR', 3000);
--insert into employee values(106, 'Rajesh',  'Finance', 5000);
--insert into employee values(107, 'Preet', 'HR', 7000);
--insert into employee values(108, 'Maryam', 'Admin', 4000);
--insert into employee values(109, 'Sanjay', 'IT', 6500);
--insert into employee values(110, 'Vasudha', 'IT', 7000);
--insert into employee values(111, 'Melinda', 'IT', 8000);
--insert into employee values(112, 'Komal', 'IT', 10000);
--insert into employee values(113, 'Gautham', 'Admin', 2000);
--insert into employee values(114, 'Manisha', 'HR', 3000);
--insert into employee values(115, 'Chandni', 'IT', 4500);
--insert into employee values(116, 'Satya', 'Finance', 6500);
--insert into employee values(117, 'Adarsh', 'HR', 3500);
--insert into employee values(118, 'Tejaswi', 'Finance', 5500);
--insert into employee values(119, 'Cory', 'HR', 8000);
--insert into employee values(120, 'Monica', 'Admin', 5000);
--insert into employee values(121, 'Rosalin', 'IT', 6000);
--insert into employee values(122, 'Ibrahim', 'IT', 8000);
--insert into employee values(123, 'Vikram', 'IT', 8000);
--insert into employee values(124, 'Dheeraj', 'IT', 11000);


-- inserting NULL dept_no for "group by" row and then deleting again.

-- insert into employee values(999, 'Test_NULL', NULL, 7500);

--COMMIT;
--



/* *****************
   	Window Function 
   ***************** */

select * from customer.employee;
-- 24 rows


-- Using Aggregate function as Window Function
-- Without window function, SQL will reduce the no of records to one cell only. one cell result. 

SELECT max(salary)
FROM employee e ;
-- Gives reslut as single cell 

SELECT max(salary) over()
FROM employee e ;
-- Gives reslut as one, new column with same number of records as table employee e

-- SELECT MAX(salary) AS max_salary
-- FROM employee;

--------------------------------------------------------------------------------------

--This is group by case where NULL value is present in dept_no. 
--so we get separate row for that NULL value after group by. 


SELECT 
	dept_name, 
	MAX(salary)
FROM employee
GROUP BY dept_name;     


-- You can refer https://claude.ai/chat/bb679de8-b854-442d-8479-7249b738adf2

--------------------------------------------------------------------------------------

--We can count in GROUP BY query like below:

--EXPLAIN 
SELECT
    COUNT(DISTINCT dept_name)                       AS distinct_excl_null,
    COUNT(DISTINCT COALESCE(dept_name, '~NULL~'))   AS distinct_incl_null,
    (SELECT COUNT(*) FROM (SELECT dept_name FROM employee GROUP BY dept_name) g) AS group_by_rows
FROM employee;


-- Grain: पूर्ण table = एक row (GROUP BY नाही, फक्त aggregates)
-- Execution order:
--   1. FROM employee            -> पूर्ण table, 25 rows (NULL test row धरून)
--   2. WHERE                    -> नाही; सगळे rows पुढे जातात
--   3. GROUP BY                 -> नाही; aggregates असल्यामुळे पूर्ण table एक group
--   4. HAVING                   -> नाही; तो एकच group टिकतो
--   5. SELECT                   -> एका group वर तीन expressions:
--      5a. COUNT(DISTINCT dept_name)          -> NULL skip होतो -> 4
--      5b. COUNT(DISTINCT COALESCE(...))      -> NULL ला '~NULL~' करून मोजतो -> 5
--      5c. scalar subquery (InitPlan, एकदाच) -> inner-most पासून:
--          i.   FROM employee                 -> वेगळा scan, 25 rows
--          ii.  GROUP BY dept_name            -> 5 groups (NULL चा स्वतंत्र group)
--          iii. SELECT dept_name              -> 5 rows = derived table g
--          iv.  SELECT COUNT(*) FROM g        -> g एक group -> 5 (scalar)
--   6. ORDER BY                 -> नाही; 1 row असल्यामुळे फरक नाही
-- Note: COUNT(*) सोडून बाकी सगळे aggregates NULL skip करतात; GROUP BY NULL ला group बनवतो.
--       distinct_excl_null != group_by_rows म्हणजे grouping column मध्ये NULL आहे.
--       '~NULL~' sentinel कुठल्याही real dept_name शी collide होऊ नये.
-- Row count: input 25 rows -> output 1 row (expected: 4 | 5 | 5)

--------------------------------------------------------------------------------------

SELECT 
		dept_name, 
		MAX(salary) AS max_salary
FROM employee
GROUP BY dept_name; 


SELECT 
	MAX(salary)
FROM employee
GROUP BY dept_name;

-- Gives 4 rows in tabel and 1 column


SELECT 
	dept_name ,
	MAX(salary)
FROM employee
GROUP BY dept_name;


SELECT 
	employee.*,
	dept_name ,
	MAX(salary)
FROM employee
GROUP BY dept_name;

---------------------------------------------------------------------------------------

--WINDOW Fuction Queries stars here - 

SELECT 
		e.*,
		MAX(salary) OVER () AS max_salary
FROM employee e;

/*There is no column name mantioned inside over(). So window function over() checks against all 24 values present in the 
 * table (or column salary) and creates new window with same value as 11000.  
 * Here, we are using aggragate function but it becomes window function after the use of over().
 * There is only one window present here.
 * By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to 
 * each record.
*/
--------------------------------------------------------------------------------------

SELECT 
		e.*,
		MAX(salary) OVER (PARTITION BY dept_name) AS max_salary_partition		
FROM employee e;


-- Grain: one row per employee (same as source) -> no GROUP BY; window function adds dept-level value to each row
-- Execution order:
-- 1. FROM employee e        -> सगळ्या rows वाचल्या जातात, alias e लागतो
-- 2. WHERE                  -> नाही; सगळ्या rows पुढे जातात
-- 3. GROUP BY / HAVING      -> नाही; rows collapse होत नाहीत
-- 4. Window function        -> rows dept_name नुसार partitions मध्ये विभागल्या जातात; प्रत्येक partition वर MAX(salary) चालतो आणि तो value त्या partition मधल्या प्रत्येक row ला जोडला जातो
-- 5. SELECT projection      -> e.* + नवीन column max_salary_partition
-- 6. ORDER BY               -> नाही; त्यामुळे output चा row order guaranteed नाही
-- Note: OVER() मध्ये ORDER BY नाही, म्हणून MAX() पूर्ण partition वर चालतो. Partitions ची संख्या = distinct dept_name values (NULL असेल तर तीही वेगळी partition)
-- Row count: output rows = input rows


-- ####
-- for each distint value in dept_name, one window is created and max() function is performed on that window separately.
-- So we have such 4 windows in above query - Admin, Finance, HR, IT
-- ordering within each partition, by emp_id

-----------------------------

SELECT 
	emp_id,
	dept_name,
	row_number() over(PARTITION BY dept_name ORDER BY emp_id) -- AS row_number_partition
FROM customer.employee e;

------------------------------------------

SELECT 
		e.*,
		row_number() over(PARTITION BY dept_name) AS row_number_partition
FROM employee e;

------------------------------------------

SELECT 
		e.*,
		row_number() over(PARTITION BY dept_name ORDER BY emp_id) AS row_number_partition
FROM employee e;


-- Grain: one row per employee (input grain = output grain)
-- Execution order:  (>> = code मध्ये आहे,  .. = absent)

-- >> 1. FROM employee e              -> employee च्या सगळ्या rows load, alias e
            -- .. 2. WHERE                        -> absent; सगळ्या rows row_number() पर्यंत पोहोचतात
            -- .. 3. GROUP BY                     -> absent; rows collapse नाहीत
            -- .. 4. HAVING                       -> absent
-- >> 5. PARTITION BY dept_name       -> rows department-wise logical groups मध्ये वाटल्या
-- >> 6. ORDER BY emp_id (in OVER)    -> प्रत्येक partition आत emp_id ने sort, फक्त numbering साठी
-- >> 7. row_number()                 -> प्रत्येक partition मध्ये 1,2,3...; नवीन dept ला reset
-- >> 8. SELECT e.*, ... AS alias     -> columns project; alias इथे assign होतो
            -- .. 9. ORDER BY (outer)             -> absent; output order guaranteed नाही

-- Note: window function WHERE मध्ये वापरता येत नाही (WHERE आधी run होतं) -> filter हवा असेल तर subquery/CTE वापर
-- Note: OVER() मधला ORDER BY result चा display order ठरवत नाही; पक्का order हवा असेल तर शेवटी ORDER BY dept_name, emp_id
-- Row count: output rows = input rows (window function rows collapse करत नाही)

-------------------------------------------------------------------------------------------

-- Note: OVER() मधला ORDER BY result चा display order ठरवत नाही; पक्का order हवा असेल तर शेवटी ORDER BY dept_name, emp_id

SELECT 
	emp_id,
	dept_name,
	row_number() OVER(PARTITION BY dept_name ORDER BY emp_id)
FROM customer.employee
ORDER BY dept_name DESC;

------------------------------------------------------------------------------------------

SELECT 
	emp_id,
	dept_name,
	row_number() OVER(PARTITION BY dept_name ORDER BY emp_id)
FROM customer.employee
ORDER BY emp_id DESC;

-- Grain: one row per employee (input grain = output grain)
-- Execution order:  (>> = code मध्ये आहे,  .. = absent)

-- >> 1. FROM customer.employee         -> 25 rows load
            -- .. 2. WHERE                          -> absent; सगळ्या 25 rows पुढे
            -- .. 3. GROUP BY                       -> absent; rows collapse नाहीत
            -- .. 4. HAVING                         -> absent
-- >> 5. PARTITION BY dept_name         -> 5 partitions: IT, HR, Admin, Finance, NULL
-- >> 6. ORDER BY emp_id (in OVER)      -> प्रत्येक partition आत emp_id ASC sort
-- >> 7. row_number()                   -> ASC क्रमानुसार 1,2,3...; number इथेच fix
-- >> 8. SELECT emp_id, dept_name, ...  -> columns project; alias नाही -> row_number
-- >> 9. ORDER BY emp_id DESC (outer)   -> fixed numbers सकट rows पुन्हा DESC sort

-- Note: OVER() मधला ORDER BY numbering ठरवतो, outer ORDER BY display ठरवतो -> दोन्ही स्वतंत्र
-- Note: PARTITION BY मध्ये NULL dept_name = एक वेगळा partition (emp_id 999)
-- Row count: output rows = input rows = 25

------------------------------------------------------------------------------------------

-- row_number(), rank() and dense_rank()

SELECT 
		e.*,
		row_number() over() AS "Row_Number_Function"
FROM employee e;


-- Fetch the first 2 employees from each department to join the company.
-- Using subquery & row_number

SELECT *
FROM (
		SELECT 
			emp_id,
			dept_name,
			row_number() over(PARTITION BY dept_name ORDER BY emp_id ASC) AS rn
		FROM employee
		)
WHERE rn = 1 OR rn = 2

-- Alternate Queries
SELECT x.*
FROM(
		SELECT 
			e.*,
			row_number() over(PARTITION BY dept_name ORDER BY e.emp_id) AS rn
		FROM employee e 
	)x
WHERE x.rn <3;

-- same query logic with different variables only 
SELECT new_table.*
FROM (
		SELECT 
			e.*,
			row_number() over(PARTITION BY e.dept_name ORDER BY emp_id) AS RN_Column
		FROM employee e
		) AS new_table
WHERE new_table.RN_Column <3

-----------------------------------------------------------------------------------------------

-- Fetch the top 3 employees in each department earning the max salary.

-- using row_number()

SELECT new_table.*
FROM (
		SELECT 
			e.*,
			row_number() over(PARTITION BY e.dept_name ORDER BY salary desc) AS rn_column	
		FROM employee e 
	) AS new_table
WHERE new_table.rn_column <4
 

-- using rank()
SELECT 
		e.*,
		rank() over() AS rnk 
FROM employee e; 		


SELECT 
		e.*,
		rank() over(ORDER BY salary desc) AS rnk 
FROM employee e; 	


-- Final output of probelm statement - 
SELECT x.* 
FROM (
		SELECT 
				e.*,
				rank() over(PARTITION BY dept_name ORDER BY salary desc) AS rnk 
		FROM employee e
	 ) x
WHERE x.rnk < 4;


-- same query logic with different variables only 
SELECT new_table.*
FROM (
		SELECT 
			e.*,
			rank() over(PARTITION BY e.dept_name ORDER BY e.salary desc) AS rank_column
		FROM employee e 
		) AS new_table
WHERE new_table.rank_column <4


-- Checking the different between rank, dense_rnk and row_number window functions:

SELECT 
	e.*,
	rank() over(PARTITION BY dept_name ORDER BY salary desc) AS rnk,
	dense_rank() OVER () AS dense_rnk
FROM employee e;


SELECT 
	e.*,
	rank() over(PARTITION BY dept_name ORDER BY salary desc) AS rnk,
	dense_rank() OVER (ORDER BY salary desc) AS dense_rnk
FROM employee e;


SELECT 
	e.*,
	rank() over(PARTITION BY dept_name ORDER BY salary desc) AS rnk,
	dense_rank() OVER (PARTITION BY dept_name ORDER BY salary desc) AS dense_rnk
FROM employee e;


SELECT 
	e.*,
	rank() over(PARTITION BY dept_name ORDER BY salary desc) AS rnk,
	dense_rank() OVER (PARTITION BY dept_name ORDER BY salary desc) AS dense_rnk,
	row_number() over(PARTITION BY dept_name ORDER BY salary DESC) AS rn  -- ORDER BY salary DESC
FROM employee e;


-- lead and lag


SELECT 
	e.*,
	lag(salary) over() AS pervious_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lag(salary) over(PARTITION BY dept_name) AS pervious_emp_salary
FROM employee e;


SELECT 
	e.*,
	lag(salary) over(ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lag(salary, 1, 0) over(PARTITION BY dept_name ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 

SELECT 
	e.*,
	lag(salary, 1) over(PARTITION BY dept_name ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 
-- it gives same output as above query where we have not mentioned any arguments after salary in lag() function. 


SELECT 
	e.*,
	lag(salary, 2) over(PARTITION BY dept_name ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lag(salary, 2, 0) over(PARTITION BY dept_name ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lag(salary, 2, 6950) over(PARTITION BY dept_name ORDER BY emp_id) AS pervious_emp_salary
FROM employee e; 


/*
- in lag(), function, first parameter is column name which is mandatory.
- second parameter is value of lag, not mandatory parameter, by default value is 1
- third parameter is - "what should be missing/absent value" , not mandatory parameter, by default value is [NULL]
*/


-- lead() - 
SELECT 
	e.*,
	lead(salary) over() AS next_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lead(salary) over(PARTITION BY dept_name ORDER BY emp_id) AS next_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lead(salary, 1) over(PARTITION BY dept_name ORDER BY emp_id) AS next_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lead(salary, 1, 0) over(PARTITION BY dept_name ORDER BY emp_id) AS next_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lead(salary, 2, 0) over(PARTITION BY dept_name ORDER BY emp_id) AS next_emp_salary
FROM employee e; 


SELECT 
	e.*,
	lead(salary, 2, 7958) over(PARTITION BY dept_name ORDER BY emp_id) AS next_emp_salary
FROM employee e; 


-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.

/* 
 * why error - the SQL engine treats both the lag(...) and the CASE as parallel expressions, not sequential ones. 
 * That’s why the alias isn’t visible there. 
 */
SELECT 
	e.*,
	lag(salary) over(ORDER BY emp_id) AS previous_emp_salary,
	CASE 
		WHEN salary > previous_emp_salary THEN RESULT = "Higher salary than previous employee" 	
		WHEN salary < previous_emp_salary THEN RESULT = "Lower salary than previous employee"
		ELSE "Equal salary as previous employee"
	END
FROM employee e;


-- so use subquery


SELECT x.*
FROM 
	(
	SELECT 
		e.*,
		lag(salary) over(ORDER BY emp_id) AS previous_emp_salary
	FROM employee e	
	) x
	

-- Final Solution	
SELECT 
	x.*,
	CASE 
		WHEN x.previous_emp_salary IS NULL THEN 'There is no previous employee'
		WHEN x.salary > x.previous_emp_salary THEN 'Higher salary than previous employee'
		WHEN x.salary < x.previous_emp_salary THEN 'Lower salary than previous employee'
		WHEN x.salary = x.previous_emp_salary THEN 'Equal salary as previous employee' 
	END AS "Result"
FROM 
	(
	SELECT 
		e.*,
		lag(salary) over(ORDER BY emp_id) AS previous_emp_salary
	FROM employee e	
	) x
	
	
-- Alternate Solution

SELECT 
	e.*,
	CASE
		WHEN lag(salary) over(ORDER BY emp_id) IS NULL THEN 'There is no previous employee'
		WHEN e.salary > lag(salary) over(ORDER BY emp_id) THEN 'Higher salary than previous employee'
		WHEN e.salary < lag(salary) over(ORDER BY emp_id) THEN 'Lower salary than previous employee'
		WHEN e.salary = lag(salary) over(ORDER BY emp_id) THEN 'Equal salary as previous employee' 
	END AS "Result"
FROM employee e;


-- same query using partition by 
SELECT 
	e.*,
	CASE
		WHEN lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) IS NULL THEN 'There is no previous employee'
		WHEN e.salary > lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) THEN 'Higher salary than previous employee'
		WHEN e.salary < lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) THEN 'Lower salary than previous employee'
		WHEN e.salary = lag(salary) over(PARTITION BY dept_name ORDER BY emp_id) THEN 'Equal salary as previous employee' 
	END AS "Result"
FROM employee e;
