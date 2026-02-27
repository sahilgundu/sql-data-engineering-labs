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

















