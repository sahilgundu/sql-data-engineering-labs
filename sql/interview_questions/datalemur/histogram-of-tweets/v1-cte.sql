-- Problem: Histogram of Tweets (Twitter, Easy)
-- Statement: For 2022, bucket users by tweet count; output tweet_bucket and number of users per bucket
-- Key idea: aggregate twice - count tweets per user (CTE), then count users per tweet count
-- Status: Accepted (needed local rebuild first)

set search_path to datalemur;


SELECT * FROM tweets;

SELECT count(*) FROM tweets;


select 
	t.user_id,
	count(*)  AS tweet_bucket
from tweets t
where extract (YEAR from t.tweet_date) = 2022
group by user_id;


--FINAL OUTPUT:-

WITH new_table_1 AS (
					SELECT 
						t.user_id,
						count(*)  AS tweet_bucket
					FROM tweets t
					WHERE extract (YEAR from t.tweet_date) = 2022
					GROUP BY t.user_id	
)
SELECT 
	new_table_1.tweet_bucket ,
	count(*) AS user_num
FROM new_table_1
GROUP BY new_table_1.tweet_bucket
ORDER BY new_table_1.tweet_bucket ;

