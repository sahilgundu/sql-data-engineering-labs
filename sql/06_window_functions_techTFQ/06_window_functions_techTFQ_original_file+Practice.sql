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
--COMMIT;
--



/* **************
   Window Function 
   ************** */

select * from employee;
-- 24 rows


-- Using Aggregate function as Window Function
-- Without window function, SQL will reduce the no of records.

SELECT MAX(salary) AS max_salary
FROM employee;


SELECT 
		dept_name, 
		MAX(salary) AS max_salary
FROM employee
GROUP BY dept_name; 


SELECT 
		e.*,
		MAX(salary) OVER () AS max_salary
FROM employee e;

/*There is no column name mantioned inside over(). So window function over() checks against all 24 values present in the 
 * table (or column salary) and creates new window with same value as 11000.  
 * Here, we are using aggragate function but it becomes window function after the use of over().
 * There is only one window present here.
 * By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.
*/


SELECT 
		e.*,
		MAX(salary) OVER (PARTITION BY dept_name) AS max_salary_partition		
FROM employee e;

-- for each value in dept_name, one window is created and row_number() function is performed on that window separately.
-- So we have such 4 windows in above query - Admin, Finance, HR, IT


-- ordering within each partition, by emp_id
SELECT 
		e.*,
		row_number() over(PARTITION BY dept_name ORDER BY emp_id) AS rn_partition
FROM employee e;


-- row_number(), rank() and dense_rank()
SELECT 
		e.*,
		row_number() over() AS rn
FROM employee e;


-- Fetch the first 2 employees from each department to join the company.
SELECT x.*
FROM(
		SELECT 
			e.*,
			row_number() over(PARTITION BY dept_name ORDER BY e.emp_id) AS rn
		FROM employee e 
	)x
WHERE x.rn <3;


-- Fetch the top 3 employees in each department earning the max salary.
-- using row_number()
SELECT x.*
FROM (SELECT 
			e.*,
			row_number() over(PARTITION BY dept_name ORDER BY salary DESC) AS rn
	  FROM employee e
	 ) x 
WHERE x.rn <= 3;
 

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
