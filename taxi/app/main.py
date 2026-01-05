import asyncpg
import os
from model import OrderCreate
from typing import Optional
from utils import ORDER_STATUSES

_pool: Optional[asyncpg.pool.Pool] = None

async def init_db():
    global _pool
    if _pool is None:
        _pool = await asyncpg.create_pool(os.getenv("DB_DSN"))

async def create_order(order: OrderCreate):
    async with _pool.acquire() as conn:
        await conn.execute(
            """
            INSERT INTO Taxi.Orders (
                client_id, driver_id, pricing_id, client_price,
                driver_priсe, distance_km, direction_id, from_a, to_b
            ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
            """,
            order.client_id, order.driver_id, order.pricing_id,
            order.client_price, order.driver_price, order.distance_km,
            order.direction_id, order.from_a, order.to_b,
        )

async def change_status(new_status: str):
    async with _pool.acquire() as conn:
        row = await conn.fetchrow(
            """
            SELECT order_id FROM Taxi.Orders
            ORDER BY random()
            LIMIT 1
            """
        )

        if row is None:
            return None

        order_id = row["order_id"]
        current_status = row["status"]

        try:
            next_index = ORDER_STATUSES.index(current_status) + 1
            next_status = ORDER_STATUSES[next_index]
        except IndexError:
            next_status = "complete"

        await conn.execute (
            """
            UPDATE Taxi.Orders
            SET status = $1
            WHERE order_id = $2
            """,
            new_status, order_id
        )
    return order_id, new_status

POSTGRES_DSN = os.getenv("DB_DSN", "postgres://mem:mem@postgres:5432/orders_db")

async def check_orders():
    pool = await asyncpg.create_pool(POSTGRES_DSN)
    async with pool.acquire() as conn:
        rows = await conn.fetch(
            """
            SELECT order_id, driver_id, start_time, estimated_end_time
            FROM Taxi.driver_processing_orders
            WHERE estimated_end_time < NOW()
            """
        )
        for row in rows:
            order_id = row["order_id"]
            driver_id = row["driver_id"]
            start_time = row["start_time"]
            estimated_end_time = row["estimated_end_time"]
            print(f"[WARNING] Order {order_id} by driver {driver_id} exceeded estimated end time. "
                  f"Start: {start_time}, Estimated end: {estimated_end_time}")

if __name__ == "__main__":
    asyncio.run(main())