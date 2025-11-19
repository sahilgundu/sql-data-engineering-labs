-- Universal SQL template (Postgres/BigQuery friendly

/*
 Indentation = 4 spaces, UPPERCASE keywords, snake_case identifiers, AS for column & derived-table aliases, 
 qualify columns with table aliases once joins appear.
*/

/* ============== UNIVERSAL SQL TEMPLATE ============== */
/* Rules:
   - 4-space indent
   - UPPERCASE keywords, snake_case identifiers
   - Column aliases:    use AS
   - Derived tables/CTEs: use AS for alias
   - One select item per line, trailing commas
   - In WHERE/HAVING, put each predicate on its own line with AND
*/



WITH cte_name AS (
    SELECT
        t.col1                           AS col1_alias,
        t.col2,
        SUM(t.metric)                    AS metric_sum
    FROM schema.table_name               AS t
    WHERE
        t.created_at >= DATE '2025-01-01'
        AND t.is_active = TRUE
    GROUP BY
        t.col1,
        t.col2
)
SELECT
    a.col1_alias,
    b.some_col,
    COALESCE(a.metric_sum, 0)            AS total_metric,
    COUNT(*)                              AS row_count
FROM cte_name                             AS a
JOIN schema.other_table                   AS b
    ON b.key_id = a.col1_alias
LEFT JOIN (
    SELECT
        x.key_id,
        MAX(x.event_ts)                  AS last_event_ts
    FROM schema.event_table              AS x
    GROUP BY
        x.key_id
) AS last_evt
    ON last_evt.key_id = b.key_id
WHERE
    b.status = 'ACTIVE'
    AND a.total_metric >= 0
GROUP BY
    a.col1_alias,
    b.some_col,
    a.total_metric
HAVING
    COUNT(*) >= 1
ORDER BY
    a.col1_alias ASC,
    b.some_col  DESC
LIMIT 100;



/*
  Minimal variants (same style)
  Simple aggregate
 */

SELECT
    s.store_id,
    SUM(s.cost) AS total_sales
FROM sales AS s
GROUP BY
    s.store_id
ORDER BY
    s.store_id;



/* Join without CTE */

SELECT
    o.order_id,
    c.customer_name,
    SUM(oi.amount) AS order_total
FROM orders      AS o
JOIN order_items AS oi ON oi.order_id   = o.order_id
JOIN customers   AS c  ON c.customer_id = o.customer_id
WHERE
    o.order_date >= DATE '2025-01-01'
GROUP BY
    o.order_id,
    c.customer_name
ORDER BY
    o.order_id;
