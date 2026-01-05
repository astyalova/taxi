CREATE OR REPLACE FUNCTION notify_order_update() RETURNS trigger AS $$
BEGIN
    NOTIFY order_status_change, NEW.order_id::text || ', ' || NEW.status;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER orders_status_notify
AFTER UPDATE OF status ON Taxi.Orders
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION notify_order_update();
