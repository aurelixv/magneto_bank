DROP VIEW IF EXISTS card1;

CREATE VIEW card1 AS (
	SELECT ca.id, ca.client_id
	FROM clients cl, cards ca
	WHERE cl.id = 686 AND cl.id = ca.client_id
	GROUP BY ca.id, ca.client_id
	ORDER BY MIN(ca.id)
	LIMIT 1
);

SELECT count(*) AS transactions_card1, ca1.id AS card_id, ca1.client_id, 
	cl.name AS client_name
FROM clients AS cl, transactions AS tr, card1 AS ca1
WHERE cl.id = 686 AND cl.id = ca1.client_id AND ca1.id = tr.card_id
GROUP BY ca1.id, ca1.client_id, cl.name;