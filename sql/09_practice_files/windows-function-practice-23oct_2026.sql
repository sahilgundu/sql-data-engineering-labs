SELECT * FROM customer.employee e ;

SELECT max(salary)
FROM employee e ;

SELECT max(salary) over()
FROM employee e ;


SELECT 
	emp_id,
	dept_name,
	row_number() OVER(PARTITION BY dept_name ORDER BY emp_id)
FROM customer.employee
ORDER BY dept_name DESC;


-- Fetch the first 2 employees from each department to join the company.
-- Using subquery 

SELECT new_table.*
FROM (
		SELECT 
			e.*,
			row_number() over(PARTITION BY e.dept_name ORDER BY emp_id) AS RN_Column
		FROM employee e
		) AS new_table
WHERE new_table.RN_Column <3
		

-- Fetch the top 3 employees in each department earning the max salary.
SELECT new_table.*
FROM (
		SELECT 
			e.*,
			row_number() over(PARTITION BY e.dept_name ORDER BY salary desc) AS rn_column	
		FROM employee e 
	) AS new_table
WHERE new_table.rn_column <4

SELECT new_table.*
FROM (
		SELECT 
			e.*,
			rank() over(PARTITION BY e.dept_name ORDER BY e.salary desc) AS rank_column
		FROM employee e 
		) AS new_table
WHERE new_table.rank_column <4














