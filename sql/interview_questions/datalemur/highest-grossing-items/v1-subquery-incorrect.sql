-- 2 highest rows - means its not group BY
-- its window function for sure. 
-- find total spend per product first 
-- use above qeury in another query and use rank, take rank<3

----------------------------------------------------------------------------------------------------

select * from product_spend;
-- select count(*) from product_spend;

 
-- SELECT 
--   ps.*,
--   row_number() over(partition by category) as rn_partition
-- FROM product_spend ps;


-- SELECT 
--   -- ps.*,
--   category,
--   sum(spend) as total_spend_per_category
-- FROM product_spend ps
-- group by category;


-- SELECT 
--   -- ps.*,
--   ps.category,
--   ps.product,
--   sum(ps.spend) as total_spend_per_product_in_category
-- FROM product_spend ps
-- group by category, product;

---------------------------------------------------------------------------------------------------------
-- FINAL Query:

-- Status: INCORRECT (kept for revision)
-- Error 1: missing FROM-clause entry for table "new_table_1"
--   Cause: outer SELECT used new_table_1; outer scope sees only new_table_2
-- Error 2 (silent): row_number() without ORDER BY -> random top 2, no error raised
-- Fixed in: v2-subquery-fixed.sql



select 
  new_table_2.category,
  new_table_2.product,
  new_table_2.total_spend_per_product_in_category as total_spend
FROM (
          SELECT 
                new_table_1.*,
              	row_number() over(partition by new_table_1.category ORDER BY new_table_1.total_spend_per_product_in_category desc) as rn_partition
          FROM (
                    SELECT
                          ps.category,
                          ps.product,
                          sum(ps.spend) as total_spend_per_product_in_category
                    FROM product_spend ps
                    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
                    group by ps.category, ps.product                    
                  ) as new_table_1
     ) as new_table_2
where new_table_2.rn_partition < 3
ORDER BY new_table_2.category, new_table_2.total_spend_per_product_in_category DESC ;






