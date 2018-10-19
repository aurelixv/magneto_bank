-- PARÂMETROS: id do cliente, id da transação
-- Query: em qual a data o cliente X fez a transação Y?

SELECT tr.transaction_date
FROM clients AS cl, transactions AS tr
WHERE cl.id = 'PARAM' AND tr.id = 'PARAM'
        AND tr.card_id = cl.card_id; -- verifica se o cliente X fez a transação Y