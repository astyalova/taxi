--Написать insert запрос, который параметризированно принимает все данныее для создания таблицы
-- сгенерить рандомные заказы в таблицу, новые

CREATE OR REPLACE FUNCTION Taxi.generate_geozone(p_count INT)
RETURNS VOID AS $$
INSERT INTO Taxi.Geozone (
    zone_id,
    coordinates
)
SELECT
    gs,
    ARRAY[
        point(37.0 + random(), 55.0 + random()),
        point(37.0 + random(), 55.0 + random()),
        point(37.0 + random(), 55.0 + random())
    ]

FROM generate_series(1, p_count) as gs;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION Taxi.generate_direction(p_count INT)

RETURNS VOID AS $$
INSERT INTO Taxi.Direction (
    from_zone_id,
    to_zone_id
)
SELECT
    z1.zone_id,
    z2.zone_id
FROM generate_series(1, p_count)
CROSS JOIN LATERAL (
    SELECT zone_id FROM Taxi.Geozone ORDER BY random() LIMIT 1
) z1
CROSS JOIN LATERAL (
    SELECT zone_id FROM Taxi.Geozone ORDER BY random() LIMIT 1
) z2
WHERE z1.zone_id <> z2.zone_id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION Taxi.generate_clients(p_count INT)
RETURNS VOID AS $$
INSERT INTO Taxi.Clients (
    client_name,
    client_number,
    rating
)
SELECT
    'Client_' || gs,
    '+7999' || (1000000 + floor(random() * 9000000))::text,
    round((3 + random() * 2)::numeric, 1)
FROM generate_series(1, p_count) AS gs;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION Taxi.generate_drivers(p_count INT)
RETURNS VOID AS $$
INSERT INTO Taxi.Drivers (
    driver_name,
    driver_number,
    rating
)
SELECT
    'Driver_' || gs,
    '+7888' || (1000000 + floor(random() * 9000000))::text,
    round((3 + random() * 2)::numeric, 1)
FROM generate_series(1, p_count) AS gs;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION Taxi.generate_pricing(p_count INT)
RETURNS VOID AS $$
INSERT INTO Taxi.Pricing (
    base_price,
    commission_rate
)
SELECT
    round((100 + random() * 400)::numeric, 2),
    round((0.1 + random() * 0.4)::numeric, 2)
FROM generate_series(1, p_count)
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION Taxi.generate_orders(p_count INT)
RETURNS VOID AS $$
INSERT INTO Taxi.Orders (
    client_id,
    driver_id,
    pricing_id,
    client_price,
    driver_priсe,
    distance_km,
    pickup_time,
    direction_id,
    from_a,
    to_b,
    order_date,
    status
)
SELECT
    c.client_id,
    d.driver_id,
    p.pricing_id,
    p.base_price + p.base_price * p.commission_rate, 
    p.base_price,                                 
    round((random() * 30)::numeric, 2),                    
    time '00:00' + (random() * interval '23 hours 59 minutes'),                                
    dir.direction_id,
    point(37.5 + random(), 55.5 + random()),   
    point(37.5 + random(), 55.5 + random()),
    CURRENT_DATE - (floor(random() * 10)::int), 
    (ARRAY['pending','complete','cancel','driving','waiting','transporting'])
      [(floor(random() * 6)::int + 1)]::Taxi.status_type
FROM generate_series(1, p_count)

CROSS JOIN LATERAL (
    SELECT client_id FROM Taxi.Clients ORDER BY random() LIMIT 1
) AS c
CROSS JOIN LATERAL (
    SELECT driver_id FROM Taxi.Drivers ORDER BY random() LIMIT 1
) AS d
CROSS JOIN LATERAL (
    SELECT * FROM Taxi.Pricing ORDER BY random() LIMIT 1
) AS p
CROSS JOIN LATERAL (
    SELECT direction_id FROM Taxi.Direction ORDER BY random() LIMIT 1
) AS dir

$$ LANGUAGE sql;

SELECT Taxi.generate_geozone(10);
SELECT Taxi.generate_direction(10);
SELECT Taxi.generate_clients(10);
SELECT Taxi.generate_drivers(5);
SELECT Taxi.generate_pricing(5);
SELECT Taxi.generate_orders(10);