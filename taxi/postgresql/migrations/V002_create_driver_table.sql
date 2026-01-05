CREATE TABLE IF NOT EXISTS Taxi.driver_processing_orders (
    order_id UUID PRIMARY KEY REFERENCES Taxi.Orders(order_id),
    driver_id INT NOT NULL REFERENCES Taxi.Drivers(driver_id),
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estimated_end_time TIMESTAMP
);