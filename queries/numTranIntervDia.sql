-- PARÂMETROS: id do cliente, id ou número do cartão, data inicial e final
-- Query: num intervalo de X dias, quantas transações foram realizadas por cliente Y?


SELECT count(*) AS num_tran
FROM clients AS cl, transactions AS tr, cards AS cd
WHERE cl.id = 'PARAM' AND cd.id = 'PARAM' 
        AND cl.id = cd.client_id -- verifica se o cliente realmente tem aquele cartao
        AND cd.id = tr.card_id 
        AND tr.transaction_date BETWEEN 'PARAM' AND 'PARAM';