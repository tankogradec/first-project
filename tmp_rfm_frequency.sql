INSERT INTO analysis.tmp_rfm_frequency 
(user_id, frequency)	
SELECT user_id, 
		(CASE WHEN id < max_id/5 THEN 5
			WHEN id >= max_id/5 AND id < max_id*2/5 THEN 4
			WHEN id >= max_id*2/5 AND id < max_id*3/5 THEN 3
			WHEN id >= max_id*3/5 AND id < max_id*4/5 THEN 2
			WHEN id >= max_id*4/5 THEN 1
			END) AS frequency
FROM
	(SELECT user_id, id, MAX(id) OVER (PARTITION BY flag) AS max_id
	FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY COUNT(order_id) DESC) AS id,
				user_id, COUNT(order_id) AS order_id, 1 AS flag
		FROM analysis.orders
		WHERE status = (SELECT id FROM analysis.orderstatuses WHERE key = 'Closed')
		GROUP BY user_id
		ORDER BY order_id ASC) AS t) AS t;