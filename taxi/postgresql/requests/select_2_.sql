-- Посчитать сколько заказов без водителя внутри каждого направления, сгруппировать по датам за последние 10 дней
-- сгруппировать сначала по направлениям, потом по датам

SELECT dir::text AS dir_text, order_date, COUNT(*) AS totl
FROM Taxi.Orders
WHERE driver_id IS NULL AND order_date >= CURRENT_DATE - INTERVAL '10 days'
GROUP BY dir::text, order_date;
