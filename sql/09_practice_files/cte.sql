--Fetch employee who earn more than average salary of all employee.

SELECT e.* 
FROM emp e
WHERE e.salary > 
				(
				 SELECT avg(salary)
				 FROM emp
				);


WITH avg_salary(avg_sal) as
							(
								SELECT avg(salary)
								FROM emp
							)
SELECT *
FROM emp e
CROSS JOIN avg_salary av
WHERE e.salary > av.avg_sal;


WITH avg_salary(avg_sal) AS 
							(
								SELECT avg(salary)
								FROM emp
							)
SELECT *
FROM emp e, avg_salary av
WHERE e.salary > av.avg_sal;



