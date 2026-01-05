import asyncio
import asyncpg
from kafka_producer import publish_status_change

POSTGRES_DSN = "postgres://mem:mem@postgres:5432/orders_db"

async def listen_status_changes():
    conn = await asyncpg.connect(dsn=POSTGRES_DSN)
    await conn.add_listener("order_status_change", handle_notification)
    while True:
        await asyncio.sleep(60)

async def remove_from_processing(order_id: str):
    async with asyncpg.create_pool(POSTGRES_DSN) as pool:
        async with pool.acquire() as conn:
            await conn.execute(
                "DELETE FROM Taxi.driver_processing_orders WHERE order_id = $1",
                order_id
            )

def handle_notification(connection, pid, channel, payload):
    order_id, new_status = payload.split(",")
    print(f"Order {order_id} changed to {new_status}")
    asyncio.create_task(publish_status_change(order_id, new_status))
    if new_status in ("complete", "cancel"):
        asyncio.create_task(remove_from_processing(order_id))
