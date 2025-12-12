-- Посчитать топ водителей по кол-ву поездок (Вывести топ 10)

SELECT driver_id, COUNT(*) as total
FROM Taxi.Orders
WHERE status = 'complete'
GROUP BY driver_id
ORDER BY total desc
LIMIT 10;