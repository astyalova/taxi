import asyncio
from datetime import datetime
import asyncpg
import os
from db import init_db, check_orders

async def run_scheduler():
    await init_db()
    while True:
        await check_orders()
        await asyncio.sleep(60)

if __name__ == "__main__":
    asyncio.run(run_scheduler())
