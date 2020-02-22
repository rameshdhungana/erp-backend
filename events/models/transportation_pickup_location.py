import uuid

from django.db import models

from users.models import Base


class TransportationPickupLocation(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    event = models.ForeignKey('events.Event', on_delete=models.CASCADE)
    location = models.CharField(max_length=255, unique=True)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True)
    description = models.TextField(blank=True)

    def save(self, *args, **kwargs):
        super(TransportationPickupLocation, self).save(*args, **kwargs)

    def __repr__(self):
        return self.location

    def __str__(self):
        return self.location
