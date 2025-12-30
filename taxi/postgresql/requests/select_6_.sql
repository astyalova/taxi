-- * Посчитать топ самых длинных цепочек для каждого пассажира, будем считать, что цепочка, это череда заказов
-- пользователя, где каждая новая геозона А == геозоне Б из прошлого заказа данного пользователя по дате создания, 
-- и нет других заказов между этими двумя, вывести топ 10, результат должен выглядеть 
-- как id пассажира -> [список заказов, длинну цепочки]

WITH RECURSIVE chains AS (
    SELECT client_id, ARRAY[order_id] AS chain, d.to_zone_id AS last_zone_b, o.order_date 
    FROM Taxi.Orders o
    JOIN Taxi.Direction d ON o.direction_id = d.direction_id
    WHERE NOT EXISTS (
        SELECT 1 FROM Taxi.Orders prev
        JOIN Taxi.Direction d2 ON prev.direction_id = d2.direction_id
        WHERE prev.client_id = o.client_id AND prev.order_date < o.order_date AND d2.to_zone_id = d.from_zone_id
            AND NOT EXISTS (
                SELECT 1 FROM Taxi.Orders mid
                WHERE mid.client_id = o.client_id AND mid.order_date > prev.order_date AND mid.order_date < o.order_date
            )
        )
    UNION ALL
    SELECT c.client_id, c.chain || o.order_id, d.to_zone_id, o.order_date 
    FROM chains c 
    JOIN Taxi.Orders o ON o.client_id = c.client_id AND o.order_date > c.order_date 
    JOIN Taxi.Direction d ON o.direction_id = d.direction_id
    WHERE d.from_zone_id = c.last_zone_b
    AND NOT EXISTS (
        SELECT 1 FROM Taxi.Orders o2
        WHERE o2.client_id = c.client_id AND o2.order_date > c.order_date AND o2.order_date < o.order_date
    )
)

SELECT client_id, chain, array_length(chain, 1) AS chain_length
FROM chains c
WHERE NOT EXISTS (
    SELECT 1 FROM chains c2
    WHERE c2.client_id = c.client_id AND c2.chain[1] = c.chain[1] AND array_length(c2.chain,1) > array_length(c.chain,1)
)
ORDER BY chain_length DESC
LIMIT 10;
