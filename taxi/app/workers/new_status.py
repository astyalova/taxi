import asyncio
from db import init_db, change_status
from kafka_producer import publish_status_change

async def run():
    await init_db()
    while True:
        order_id, new_status = await change_status("cancel")
        if order_id:
            print(f"Updated order {order_id} to complete")
            await publish_status_change(order_id, new_status)
        else:
            print("No orders to update")
        await asyncio.sleep(10)

if __name__ == "__main__":
    asyncio.run(run())