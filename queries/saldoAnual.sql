SELECT SUM(value)
FROM transactions
WHERE card_id = 1039 AND EXTRACT(YEAR FROM transaction_date) = 2017;