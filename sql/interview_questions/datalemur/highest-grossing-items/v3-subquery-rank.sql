
-- v3: same as v2, rank() instead of row_number()
-- Grain: one row per (category, product), top 2 per category, 2022 only

SELECT 
	new_table_2.category,
	new_table_2.product,
	new_table_2.total_spend_per_category_per_product AS total_spend
	
FROM (
		SELECT 
			*,
			rank() over(PARTITION BY new_table_1.category ORDER BY total_spend_per_category_per_product desc) AS rn_partition
	
		FROM (
				SELECT 
					ps.category,
					ps.product,
					sum(ps.spend) AS total_spend_per_category_per_product
				FROM product_spend ps 
				WHERE extract(YEAR FROM ps.transaction_date) = 2022
				GROUP BY ps.category , ps.product 
			) AS new_table_1
) AS new_table_2
WHERE new_table_2.rn_partition < 3
ORDER BY new_table_2.category, new_table_2.total_spend_per_category_per_product desc;



