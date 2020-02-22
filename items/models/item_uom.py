import uuid

from django.db import models

from users.models import Base

UNITS = 'units'
UNIT_CHOICES = (
    (UNITS, UNITS),

)


class UnitOfMeasurement(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=64, unique=True, choices=UNIT_CHOICES)

    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name
