import uuid as uuid
from decimal import Decimal

from django.core.validators import MinValueValidator
from django.db import models

from users.models import Base


class CancellationPolicy(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    event = models.ForeignKey('events.Event', on_delete=models.CASCADE, null=True)
    item_master = models.ForeignKey('items.ItemMaster', on_delete=models.CASCADE)
    event_item = models.ForeignKey('events.EventItem', on_delete=models.CASCADE, null=True)
    period_from = models.DateTimeField()
    period_to = models.DateTimeField()
    # percentage to be applied for cancelled items
    cancellation_per = models.DecimalField(max_digits=5, decimal_places=2, default=0.00,
                                           validators=[MinValueValidator(Decimal('0.00'))])
