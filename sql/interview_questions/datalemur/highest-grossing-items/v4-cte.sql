SELECT *
FROM product_spend ps ;

-- v4: CTE + rank()
-- Step 1: CTE 1 = one row per (category, product), 2022 only

WITH new_table_1 AS (
				SELECT 
					ps.category,
					ps.product,
					sum(ps.spend) AS total_spend_per_category_per_product
				FROM product_spend ps 
				WHERE extract(YEAR FROM ps.transaction_date) = 2022
				GROUP BY ps.category , ps.product 
)
SELECT *
FROM new_table_1
ORDER BY new_table_1.category, new_table_1.total_spend_per_category_per_product DESC;


WITH new_table_1 AS (
				SELECT 
					ps.category,
					ps.product,
					sum(ps.spend) AS total_spend_per_category_per_product
				FROM product_spend ps 
				WHERE extract(YEAR FROM ps.transaction_date) = 2022
				GROUP BY ps.category , ps.product 
),

new_table_2 AS (
				SELECT 
						new_table_1.*,
						rank() over(
									PARTITION BY new_table_1.category 
									ORDER BY total_spend_per_category_per_product DESC
									) AS rn_partition
				FROM new_table_1
)
SELECT 
	new_table_2.category,
	new_table_2.product,
	new_table_2.total_spend_per_category_per_product AS total_spend
FROM new_table_2
WHERE new_table_2.rn_partition < 3
ORDER BY new_table_2.category, new_table_2.total_spend_per_category_per_product desc;









