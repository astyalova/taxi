-- Написать update, который принимает id заказа + новый статус, через параметры и обновляет статус заказа

PREPARE update_order_status(uuid, Taxi.status_type) AS
UPDATE Taxi.Orders
SET status = $2
WHERE order_id = $1;


EXECUTE update_order_status(
    '133114d5-ed97-4659-8731-34d6e0bd7faa'::uuid, 
    'driving'::Taxi.status_type
);