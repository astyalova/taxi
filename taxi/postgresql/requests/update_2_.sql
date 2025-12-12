-- Написать update, который принимает id заказа + нового водителя, через параметры и обновляет водителя заказа

PREPARE update_order_driver(uuid, int) AS
UPDATE Taxi.Orders
SET driver_id = $2
WHERE order_id = $1;


EXECUTE update_order_driver(
    '8fd922e3-9d43-4d87-b3da-ac0773f19097'::uuid, 
    4
);