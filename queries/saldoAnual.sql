-- Passar o ano e o cartão por parâmetro
-- QUERY: qual é o saldo de um determinado cliente no ano tal?

SELECT SUM(value)
FROM transactions
WHERE card_id = 1039 AND EXTRACT(YEAR FROM transaction_date) = 'PARAM';