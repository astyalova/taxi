-- Посчитать сколько заказов внутри каждого направления в каждом статусе, сгруппировать по датам за последние 10 дней
-- сгруппировать направлениям, статусам и датам

SELECT dir::text AS dir_text, status, order_date, COUNT(*) as total
FROM Taxi.Orders
WHERE order_date >= CURRENT_DATE - INTERVAL '10 days'
GROUP BY dir::text, status, order_date;