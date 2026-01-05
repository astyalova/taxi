from pydantic import BaseModel
from uuid import UUID
from decimal import Decimal
from typing import Optional

class OrderCreate(BaseModel):
    client_id: int
    driver_id: Optional[int]
    pricing_id: int
    client_price: Decimal
    driver_priсe: Decimal
    distance_km: Decimal
    direction_id: int
    from_a: tuple[float, float]
    to_b: tuple[float, float]