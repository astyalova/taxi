-- Посчитать топ пользователей по кол-ву поездок (Вывести топ 10)
SELECT client_id, COUNT(*) as total
FROM Taxi.Orders
WHERE status = 'complete'
GROUP BY client_id
ORDER BY total desc
LIMIT 10;