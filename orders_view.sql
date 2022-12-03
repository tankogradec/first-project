DROP VIEW IF EXISTS analysis.orders; 

CREATE VIEW analysis.orders AS
SELECT o.*, status_id AS status
FROM production.orders AS o
INNER JOIN
(SELECT order_id, status_id
FROM 
	(SELECT *, MAX(dttm) OVER (PARTITION BY order_id) AS last_dttm
	FROM analysis.orderstatuslog) AS s
WHERE dttm = last_dttm) AS s
USING(order_id);