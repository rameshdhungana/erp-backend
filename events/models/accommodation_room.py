import uuid

from django.db import models

from users.models import Base


class AccommodationRoom(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    room_number = models.CharField(max_length=255)
    event_attendee = models.ForeignKey('events.EventAttendee', on_delete=models.SET_NULL, null=True)
    description = models.TextField(blank=True, null=True)

    def __repr__(self):
        return self.room_number

    def __str__(self):
        return self.room_number

    class Meta:
        unique_together = ('room_number', 'event_attendee')
