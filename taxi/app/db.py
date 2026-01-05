import asyncpg
import os

_pool = None

async def init_db():
    global _pool
    _pool = await asyncpg.create_pool(os.getenv("DB_DSN"))
