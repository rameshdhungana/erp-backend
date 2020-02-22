import uuid

from django.db import models

from users.models import Base


#  this field to store the extra information such as arrival date time , departure date time and pickup locations
#  for transportation items , is associated to orderedItem through manytomany relationship
class TransportationInfo(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    arrival_datetime = models.DateTimeField(null=True)
    departure_datetime = models.DateTimeField(null=True)
    pickup_location = models.ForeignKey('events.TransportationPickupLocation', on_delete=models.SET_NULL, null=True)

    def __repr__(self):
        return '{}'.format(self.pickup_location)

    def __str__(self):
        return '{}'.format(self.pickup_location)
