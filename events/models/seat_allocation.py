import uuid

from django.db import models

from users.models import Base


# used for seat allocation of event_attendee
class SeatAllocation(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    event_attendee = models.ForeignKey('events.EventAttendee', on_delete=models.CASCADE)
    seat_number = models.IntegerField()

    def __repr__(self):
        return '{}-{}'.format(self.event_attendee, self.seat_number)

    def __str__(self):
        return '{}-{}'.format(self.event_attendee, self.seat_number)
