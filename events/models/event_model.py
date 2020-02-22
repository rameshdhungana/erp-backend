import uuid as uuid

from django.db import models

from cluberpbackend.python_time_zone_choices import PYTHON_TIME_ZONE_CHOICES
from cluberpbackend.raw_time_zone import countries
from users.models import Base

EVENT_STATUS_CHOICES = (
    ('Open', 'Open'),
    ('Closed', 'Closed'),
    ('Paused', 'Paused'),
    ('Testing', 'Testing'),
)


class Event(Base):
    title = models.CharField(max_length=255)
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    description = models.TextField()
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    early_bird_date = models.DateTimeField()
    is_single_day_event = models.BooleanField()
    # for single day event , we need  start_time and end_time fields but both start_date and end_date will be same
    start_time = models.TimeField(null=True, blank=True)
    end_time = models.TimeField(null=True, blank=True)
    venue_location = models.CharField(max_length=255)
    label = models.CharField(max_length=255)
    type = models.ForeignKey('EventType', on_delete=models.CASCADE)
    category = models.ForeignKey('EventCategory', on_delete=models.CASCADE)
    organizer = models.ForeignKey('Organizer', on_delete=models.CASCADE)
    title_images = models.ManyToManyField('Images', related_name='event_title')
    description_images = models.ManyToManyField('Images', related_name='event_description')
    summary = models.TextField()
    allow_group_registration = models.BooleanField(default=True)
    max_group_limit = models.IntegerField(default=1)
    status = models.CharField(max_length=255, choices=EVENT_STATUS_CHOICES, default='Testing')
    show_total_capacity = models.BooleanField(default=False)
    show_remaining_seats = models.BooleanField(default=False)
    is_published = models.BooleanField(default=False)
    show_start_time = models.BooleanField(default=False)
    show_end_time = models.BooleanField(default=False)
    timezone = models.CharField(max_length=128, choices=PYTHON_TIME_ZONE_CHOICES)
    # this if True indicates that event registration would  be only Offsite , hence , no guest attendees,
    # accommodation and transportation items would be selected by attendee
    only_offsite_registration = models.BooleanField(default=False)


    def __repr__(self):
        return self.title

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        if self.is_single_day_event:
            self.end_date = self.end_date
        super(Event, self).save(*args, **kwargs)
