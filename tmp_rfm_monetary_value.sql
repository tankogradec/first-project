INSERT INTO analysis.tmp_rfm_monetary_value
(user_id, monetary_value)
SELECT user_id, 
		(CASE WHEN id < max_id/5 THEN 5
			WHEN id >= max_id/5 AND id < max_id*2/5 THEN 4
			WHEN id >= max_id*2/5 AND id < max_id*3/5 THEN 3
			WHEN id >= max_id*3/5 AND id < max_id*4/5 THEN 2
			WHEN id >= max_id*4/5 THEN 1
			END) AS monetary_value
FROM
	(SELECT user_id, id, MAX(id) OVER (PARTITION BY flag) AS max_id
	FROM
		(SELECT ROW_NUMBER() OVER (ORDER BY SUM(payment) DESC) AS id,
				user_id, SUM(payment) AS payment, 1 AS flag
		FROM analysis.orders
		WHERE status = (SELECT id FROM analysis.orderstatuses WHERE key = 'Closed')
		GROUP BY user_id
		ORDER BY payment ASC) AS t) AS t;