-- * Посчитать топ самых длинных цепочек для каждого пассажира, будем считать, что цепочка, это череда заказов
-- пользователя, где каждая новая геозона А == геозоне Б из прошлого заказа данного пользователя по дате создания, 
-- и нет других заказов между этими двумя, вывести топ 10, результат должен выглядеть 
-- как id пассажира -> [список заказов, длинну цепочки]

WITH RECURSIVE chains AS (
    SELECT client_id, ARRAY[order_id] AS chain, (dir).zone_b::text AS last_zone_b, order_date 
    FROM Taxi.Orders 
    UNION ALL
    SELECT c.client_id, c.chain || o.order_id, (o.dir).zone_b::text, o.order_date 
    FROM chains c 
    JOIN Taxi.Orders o ON o.client_id = c.client_id AND o.order_date > c.order_date AND (o.dir).zone_a::text = c.last_zone_b
)

SELECT client_id, chain, array_length(chain, 1) AS chain_length
FROM chains
ORDER BY chain_length DESC
LIMIT 10;
