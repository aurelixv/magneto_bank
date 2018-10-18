-- quantas transações o cliente X realizou com o cartão 1?
/*DROP VIEW IF EXISTS card1;

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
GROUP BY ca1.id, ca1.client_id, cl.name;*/

-- Ou inserir o número do cartão e o id do cliente.
-- QUERY: quantas transações o cliente X realizou com cartão Y?

SELECT count(*) AS num_transactions, ca.id AS card_id, ca.client_id, 
	cl.name AS client_name
FROM clients AS cl, transactions AS tr, cards AS ca
WHERE cl.id = 'PARAM' AND ca.card_number = 'PARAM' AND cl.id = ca.client_id AND ca. AND ca.id = tr.card_id
GROUP BY ca.id, ca.client_id, cl.name;