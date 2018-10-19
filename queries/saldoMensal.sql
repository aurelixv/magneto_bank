-- Passar o mês e o cartão por parâmetro
-- QUERY: qual é o saldo de um determinado cliente no mês tal?

SELECT SUM(value)
FROM transactions
WHERE card_id = 1039 AND EXTRACT(MONTH FROM transaction_date) = 'PARAM';