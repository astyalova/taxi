import random
from decimal import Decimal
from model import OrderCreate

ORDER_STATUSES = ["pending", "driving", "waiting", "transporting", "complete", "cancel"]

def random_order() -> OrderCreate:
    return OrderCreate(
        client_id=random.randint(1, 10),
        driver_id=None,
        pricing_id=1,
        client_price=Decimal("500"),
        driver_price=Decimal("350"),
        distance_km=Decimal("7.5"),
        direction_id=random.randint(1, 5),
        from_a=(55.75 + random.random()/100, 37.61 + random.random()/100),
        to_b=(55.76 + random.random()/100, 37.65 + random.random()/100)
    )
