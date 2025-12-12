--Написать insert запрос, который параметризированно принимает все данныее для создания таблицы
-- сгенерить рандомные заказы в таблицу, новые

INSERT INTO Taxi.Clients (client_name, client_number, rating) VALUES
    ('Иван', '+79161234567', 4.8),
    ('Алекей', '+79162345678', 4.9),
    ('Алексей', '+79163456789', 4.7),
    ('Артём', '+79164567890', 4.6),
    ('Анастасия', '+79165678901', 5.0),
    ('Артём', '+79167890123', 4.4),
    ('Артём', '+79160123456', 4.4)
ON CONFLICT DO NOTHING;

INSERT INTO Taxi.Drivers (driver_name, driver_number, rating) VALUES
    ('Александр', '+79161122334', 4.1),
    ('Алексей', '+79162233445', 4.9),
    ('Максим', '+79163344556', 4.7),
    ('Артём', '+79164455667', 4.6),
    ('Артём', '+79160011223', 4.9)
ON CONFLICT DO NOTHING;

INSERT INTO Taxi.Pricing (base_price, commission_rate) VALUES
    (500.00, 0.2),
    (750.00, 0.25),
    (1200.00, 0.3),
    (1500.00, 0.35)
ON CONFLICT DO NOTHING;

INSERT INTO Taxi.Orders (
    client_id,
    driver_id,
    client_price,
    pricing_id,
    distance_km,
    pickup_time,
    dir,
    from_a,
    to_b,
    order_date,
    status
) VALUES 
(
    1, 
    1,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 1),
    1,
    12.5,
    '10:30',
    ROW(
        ARRAY['(55.7512, 37.6184)'::point, '(55.7601, 37.6200)'::point],
        ARRAY['(55.7700, 37.6300)'::point, '(55.7755, 37.6400)'::point]
    )::geo,
    '(55.7522, 37.6155)'::point,
    '(55.7800, 37.6600)'::point,
    CURRENT_DATE,
    'pending'
),

(
    3,
    2,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 2),
    2,
    18.0,
    '14:15',
    ROW(
        ARRAY[
            '(55.7000, 37.5000)'::point,
            '(55.7100, 37.5200)'::point,
            '(55.7200, 37.5400)'::point
        ],
        ARRAY[
            '(55.7300, 37.5500)'::point,
            '(55.7400, 37.5600)'::point
        ]
    )::geo,
    '(55.7050, 37.5100)'::point,
    '(55.7450, 37.5650)'::point,
    CURRENT_DATE - 1,
    'driving'
),

(
    5,
    4,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 3),
    3,
    25.4,
    '19:45',
    ROW(
        ARRAY[
            '(55.8000, 37.6000)'::point,
            '(55.8100, 37.6200)'::point
        ],
        ARRAY[
            '(55.8200, 37.6400)'::point,
            '(55.8300, 37.6600)'::point,
            '(55.8400, 37.6800)'::point
        ]
    )::geo,
    '(55.8050, 37.6150)'::point,
    '(55.8450, 37.6900)'::point,
    CURRENT_DATE - 2,
    'complete'
),

(
    2,
    NULL,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 4),
    4,
    7.8,
    '08:20',
    ROW(
        ARRAY[
            '(55.6500, 37.4500)'::point,
            '(55.6600, 37.4600)'::point
        ],
        ARRAY[
            '(55.6700, 37.4700)'::point,
            '(55.6800, 37.4800)'::point,
            '(55.6900, 37.4900)'::point
        ]
    )::geo,
    '(55.6550, 37.4550)'::point,
    '(55.6950, 37.4950)'::point,
    CURRENT_DATE,
    'pending'
),

(
    6,
    NULL,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 1),
    1,
    4.4,
    '16:05',
    ROW(
        ARRAY[
            '(55.9000, 37.7000)'::point
        ],
        ARRAY[
            '(55.9100, 37.7100)'::point
        ]
    )::geo,
    '(55.9050, 37.7050)'::point,
    '(55.9150, 37.7150)'::point,
    CURRENT_DATE,
    'waiting'
),

(
    4,
    NULL,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 2),
    2,
    15.7,
    '21:10',
    ROW(
        ARRAY[
            '(55.6000, 37.4000)'::point,
            '(55.6100, 37.4150)'::point
        ],
        ARRAY[
            '(55.6200, 37.4300)'::point
        ]
    )::geo,
    '(55.6050, 37.4080)'::point,
    '(55.6250, 37.4350)'::point,
    CURRENT_DATE - 3,
    'cancel'
),
(
    1, 
    3,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 2),
    2,
    10.2,
    '12:45',
    ROW(
        ARRAY['(55.7800, 37.6600)'::point, '(55.7850, 37.6700)'::point],
        ARRAY['(55.7900, 37.6800)'::point, '(55.7950, 37.6900)'::point]
    )::geo,
    '(55.7800, 37.6600)'::point,
    '(55.7950, 37.6900)'::point,
    CURRENT_DATE,
    'pending'
),
(
    1,
    2,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 3),
    3,
    8.5,
    '15:20',
    ROW(
        ARRAY['(55.7950, 37.6900)'::point],
        ARRAY['(55.8000, 37.7000)'::point]
    )::geo,
    '(55.7950, 37.6900)'::point,
    '(55.8000, 37.7000)'::point,
    CURRENT_DATE,
    'complete'
),
(
    2,
    5,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 1),
    1,
    12.0,
    '09:50',
    ROW(
        ARRAY['(55.7450, 37.5650)'::point],
        ARRAY['(55.7500, 37.5700)'::point]
    )::geo,
    '(55.7450, 37.5650)'::point,
    '(55.7500, 37.5700)'::point,
    CURRENT_DATE - 1,
    'pending'
),
(
    2,
    1,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 2),
    2,
    5.3,
    '13:10',
    ROW(
        ARRAY['(55.7500, 37.5700)'::point],
        ARRAY['(55.7550, 37.5750)'::point]
    )::geo,
    '(55.7500, 37.5700)'::point,
    '(55.7550, 37.5750)'::point,
    CURRENT_DATE,
    'driving'
),
(
    3,
    4,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 3),
    3,
    14.8,
    '18:30',
    ROW(
        ARRAY['(55.8050, 37.6150)'::point, '(55.8100, 37.6250)'::point],
        ARRAY['(55.8150, 37.6350)'::point]
    )::geo,
    '(55.8050, 37.6150)'::point,
    '(55.8150, 37.6350)'::point,
    CURRENT_DATE - 2,
    'complete'
),
(
    3,
    NULL,
    (SELECT base_price + base_price * commission_rate FROM Taxi.Pricing WHERE pricing_id = 1),
    1,
    6.7,
    '20:15',
    ROW(
        ARRAY['(55.8150, 37.6350)'::point],
        ARRAY['(55.8200, 37.6400)'::point]
    )::geo,
    '(55.8150, 37.6350)'::point,
    '(55.8200, 37.6400)'::point,
    CURRENT_DATE - 1,
    'pending'
);
-- \x 