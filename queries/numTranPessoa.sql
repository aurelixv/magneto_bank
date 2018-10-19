-- Passar o nome do cliente por parâmetro
-- QUERY: quantas transações um determinado cliente realizou?

SELECT count(*)
FROM clients AS cl, cards AS ca, transactions AS tr
WHERE cl.name = 'PARAM' AND cl.id = ca.client_id AND ca.id = tr.card_id;
