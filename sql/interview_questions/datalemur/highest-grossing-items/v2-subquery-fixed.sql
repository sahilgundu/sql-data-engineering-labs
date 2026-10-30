
SELECT *
FROM product_spend;

-- Grain: one row per (category, product), 2022 only

SELECT 
	ps.category,
	ps.product,
	sum(ps.spend) AS total_spend_per_category_per_product
FROM product_spend ps 
WHERE extract(YEAR FROM ps.transaction_date) = 2022
GROUP BY ps.category , ps.product 
ORDER BY ps.category, total_spend_per_category_per_product DESC; 


-- Grain: one row per (category, product), 2022 only (input grain: one row per transaction)
-- Execution order:  (>> = code मध्ये आहे,  .. = absent)

-- >> 1. FROM product_spend ps             -> product_spend च्या 15 rows load, alias ps
-- >> 2. WHERE extract(year ...) = 2022    -> row-by-row filter; 2021 ची 1 आणि 2023 च्या 2 rows बाहेर -> 11 rows
-- >> 3. GROUP BY ps.category, ps.product  -> 11 rows (category, product) groups मध्ये collapse -> 7 groups; grain बदलतो
            -- .. 4. HAVING         -> absent; सगळे 7 groups output पर्यंत पोहोचतात
            -- .. 5. WINDOW (OVER)  -> absent; ranking नाही, top 2 अजून निवडले नाहीत
-- >> 6. SELECT category, product, sum()   -> प्रत्येक group साठी sum(spend) compute, alias total_spend_per_category_per_product
            -- .. 7. DISTINCT       -> absent; GROUP BY मुळे आधीच प्रत्येक (category, product) unique
-- >> 8. ORDER BY ps.category, total DESC  -> category A-Z, आत total मोठ्याकडून लहानाकडे; SELECT नंतर, म्हणून alias वापरता येतो
            -- .. 9. LIMIT          -> absent; सगळ्या 7 rows output मध्ये

-- Note: WHERE मध्ये alias वापरता येत नाही (SELECT नंतर चालतो); ORDER BY मध्ये येतो (SELECT नंतर चालतो)
-- Note: extract(year from col) column वर function लावतो -> index वापरला जात नाही; मोठ्या tables वर
--       transaction_date >= '2022-01-01' and transaction_date < '2023-01-01' वापर
-- Note: subquery म्हणून वापरताना ORDER BY काढ; inner ORDER BY outer साठी क्रम guarantee करत नाही
-- Row count: input 15 -> WHERE नंतर 11 -> GROUP BY नंतर 7 (output < input, grain बदलला)



-- Grain: one row per (category, product), 2022 only + rank within category

SELECT 
	*,
	row_number() over(PARTITION BY new_table_1.category ORDER BY total_spend_per_category_per_product desc) AS rn_partition
	
FROM (
		SELECT 
			ps.category,
			ps.product,
			sum(ps.spend) AS total_spend_per_category_per_product
		FROM product_spend ps 
		WHERE extract(YEAR FROM ps.transaction_date) = 2022
		GROUP BY ps.category, ps.product 
		ORDER BY ps.category, total_spend_per_category_per_product DESC
) AS new_table_1



-- Grain: one row per (category, product), top 2 per category, 2022 only
--FINAL Query ----

SELECT 
	new_table_2.category,
	new_table_2.product,
	new_table_2.total_spend_per_category_per_product AS total_spend
	
FROM (
		SELECT 
			*,
			row_number() over(PARTITION BY new_table_1.category ORDER BY total_spend_per_category_per_product desc) AS rn_partition
	
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


-- Grain: one row per (category, product), top 2 per category, 2022 only (input: one row per transaction)
-- Execution order:  (>> = code मध्ये आहे,  .. = absent)

-- >> 1. L1 FROM product_spend ps            -> 15 transaction rows load, alias ps
-- >> 2. L1 WHERE extract(year) = 2022       -> row-by-row filter; 2021 ची 1, 2023 च्या 2 rows बाहेर -> 11 rows
-- >> 3. L1 GROUP BY category, product       -> 11 rows -> 7 groups; grain transaction वरून product वर
            -- .. 4. L1 HAVING     -> absent; सगळे 7 groups पुढे
            -- .. 5. L1 WINDOW     -> absent; L1 मध्ये ranking नाही
-- >> 6. L1 SELECT category, product, sum()  -> प्रत्येक group चा total compute -> new_table_1 (7 rows)
            -- .. 7. L1 DISTINCT   -> absent; GROUP BY मुळे आधीच unique
            -- .. 8. L1 ORDER BY   -> absent; subquery मध्ये गरज नाही, window स्वतः sort करतो
            -- .. 9. L1 LIMIT      -> absent; सगळ्या 7 rows L2 ला
-- >> 10. L2 FROM new_table_1                -> 7 rows; L1 चा result इथे साधा table
            -- .. 11. L2 WHERE     -> absent; सगळ्या 7 rows window पर्यंत
            -- .. 12. L2 GROUP BY  -> absent; grain तोच (category, product)
            -- .. 13. L2 HAVING    -> absent; GROUP BY नाही
-- >> 14. L2 row_number() OVER (...)         -> category-wise partition, total DESC ने sort, 1,2,3.. number
-- >> 15. L2 SELECT *, rn_partition          -> 7 rows + rn_partition column -> new_table_2
            -- .. 16. L2 DISTINCT  -> absent; rows आधीच unique
            -- .. 17. L2 ORDER BY  -> absent; ranking चा क्रम OVER आत ठरला
            -- .. 18. L2 LIMIT     -> absent; सगळ्या 7 rows L3 ला
-- >> 19. L3 FROM new_table_2                -> 7 rows; rn_partition आता साधा column
-- >> 20. L3 WHERE rn_partition < 3          -> प्रत्येक category चे rn 1, 2 ठेवले -> 4 rows
            -- .. 21. L3 GROUP BY  -> absent; grain तोच
            -- .. 22. L3 HAVING    -> absent; GROUP BY नाही
            -- .. 23. L3 WINDOW    -> absent; ranking L2 मध्ये झालं
-- >> 24. L3 SELECT 3 columns                -> category, product, total -> alias total_spend; rn_partition drop
            -- .. 25. L3 DISTINCT  -> absent; rows आधीच unique
-- >> 26. L3 ORDER BY category, total DESC   -> output क्रम guaranteed: category A-Z, आत total मोठा आधी
            -- .. 27. L3 LIMIT     -> absent; सगळ्या 4 rows output

-- Note: L1 = new_table_1 (innermost), L2 = new_table_2, L3 = outer; आतला level पूर्ण चालतो, मग बाहेरचा
-- Note: rn_partition L2 च्या WHERE मध्ये वापरता येत नाही (WHERE step 11, window step 14) -> म्हणून L3 लागतो
-- Note: OVER आतला ORDER BY ranking ठरवतो; L3 चा ORDER BY फक्त output चा क्रम ठरवतो
-- Note: row_number() ties मध्ये एकच row arbitrarily निवडतो; ties हवे असतील तर rank()/dense_rank() (v3)
-- Row count: 15 -> 11 (L1 WHERE) -> 7 (L1 GROUP BY) -> 7 (L2 window) -> 4 (L3 WHERE)








