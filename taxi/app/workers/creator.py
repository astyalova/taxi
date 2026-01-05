import asyncio
from db import init_db, create_order
from utils import random_order

async def run():
    await init_db()
    while True:
        order = random_order()
        await create_order(order)
        print(f"Created order {order}")
        await asyncio.sleep(10)

if __name__ == "__main__":
    asyncio.run(run())