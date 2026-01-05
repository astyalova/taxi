import asyncio
from aiokafka import AIOKafkaProducer
import os
import json

KAFKA_BOOTSTRAP = os.getenv("KAFKA_BOOTSTRAP", "kafka:9092")
TOPIC = "orders_status"

producer: AIOKafkaProducer = None

async def init_producer():
    global producer
    if producer is None:
        producer = AIOKafkaProducer(
            bootstrap_servers=KAFKA_BOOTSTRAP,
            value_serializer=lambda v: json.dumps(v).encode("utf-8")
        )
        await producer.start()

async def publish_status_change(order_id: str, new_status: str):
    if producer is None:
        await init_producer()
    await producer.send_and_wait(TOPIC, {"order_id": order_id, "status": new_status})

async def close_producer():
    if producer:
        await producer.stop()
