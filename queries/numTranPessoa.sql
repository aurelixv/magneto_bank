SELECT count(*)
FROM clients AS cl, cards AS ca, transactions AS tr
WHERE cl.name = 'Nick Hane Wolf' AND cl.id = ca.client_id AND ca.id = tr.card_id;
