INSERT INTO analysis.tmp_rfm_recency 
(user_id, recency)
SELECT user_id, 
		(CASE WHEN id < max_id/5 THEN 5
			WHEN id >= max_id/5 AND id < max_id*2/5 THEN 4
			WHEN id >= max_id*2/5 AND id < max_id*3/5 THEN 3
			WHEN id >= max_id*3/5 AND id < max_id*4/5 THEN 2
			WHEN id >= max_id*4/5 THEN 1
			END) AS recency
FROM
	(SELECT user_id, id, MAX(id) OVER (PARTITION BY flag) AS max_id
	FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY MAX(order_ts) DESC) AS id,
				user_id, MAX(order_ts) AS order_ts, 1 AS flag
		FROM analysis.orders
		WHERE status = (SELECT id FROM analysis.orderstatuses WHERE key = 'Closed')
		GROUP BY user_id
		ORDER BY order_ts ASC) AS t) AS t;