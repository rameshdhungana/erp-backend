import uuid

from django.db import models

from users.models import Base

REGISTRATION_TYPE_STATUS = (
    ('Open', 'Open'),
    ('Closed', 'Closed'),
    ('Paused', 'Paused'),
    ('Testing', 'Testing'),
)


class EventRegistrationType(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=255, blank=False)
    total_capacity = models.IntegerField(default=0)
    event = models.ForeignKey('events.Event', on_delete=models.CASCADE)
    is_published = models.BooleanField(default=False)
    status = models.CharField(choices=REGISTRATION_TYPE_STATUS, default='Testing', max_length=20)
    required_otp = models.BooleanField(default=False)
    is_public = models.BooleanField(default=False)

    class Meta:
        unique_together = ('name', 'event')

    def __repr__(self):
        return '{} -{}'.format(self.name, self.event.title)

    def __str__(self):
        return '{} -{}'.format(self.name, self.event.title)
