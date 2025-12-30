CREATE SCHEMA IF NOT EXISTS Taxi;

CREATE TYPE Taxi.status_type AS ENUM (
    'pending', 'driving', 'waiting', 'transporting', 'complete', 'cancel'
);

CREATE TABLE IF NOT EXISTS Taxi.Geozone (
    zone_id INT PRIMARY KEY,
    coordinates POINT[]
);

CREATE TABLE IF NOT EXISTS Taxi.Direction (
    direction_id SERIAL PRIMARY KEY,
    from_zone_id INT NOT NULL REFERENCES Taxi.geozone(zone_id),
    to_zone_id   INT NOT NULL REFERENCES Taxi.geozone(zone_id)
);


CREATE TABLE IF NOT EXISTS Taxi.Clients (
    client_id SERIAL PRIMARY KEY,
    client_name TEXT NOT NULL,
    client_number TEXT NOT NULL,
    rating DECIMAL DEFAULT 5.0
);

CREATE TABLE IF NOT EXISTS Taxi.Drivers (
    driver_id SERIAL PRIMARY KEY,
    driver_name TEXT NOT NULL,
    driver_number TEXT NOT NULL,
    rating DECIMAL DEFAULT 5.0
);

CREATE TABLE IF NOT EXISTS Taxi.Pricing (
    pricing_id SERIAL PRIMARY KEY,
    base_price DECIMAL NOT NULL,
    commission_rate DECIMAL NOT NULL DEFAULT 0.3
);

CREATE TABLE IF NOT EXISTS Taxi.Orders (
    order_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id INT NOT NULL REFERENCES Taxi.Clients(client_id),
    driver_id INT REFERENCES Taxi.Drivers(driver_id),
    pricing_id INT NOT NULL REFERENCES Taxi.Pricing(pricing_id),
    client_price DECIMAL NOT NULL,
    driver_priсe DECIMAL NOT NULL,
    distance_km DECIMAL NOT NULL, 
    pickup_time TIME,
    direction_id INT NOT NULL REFERENCES Taxi.Direction(direction_id),
    from_a point,
    to_b point, 
    order_date DATE DEFAULT CURRENT_DATE,
    status Taxi.status_type NOT NULL DEFAULT 'pending'
);

CREATE INDEX idx_orders_client_id ON Taxi.Orders(client_id);

CREATE INDEX idx_orders_driver_id ON Taxi.Orders(driver_id);

CREATE INDEX idx_orders_status ON Taxi.Orders(status);
