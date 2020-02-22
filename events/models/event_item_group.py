import uuid

from django.db import models

from users.models import Base

REGISTRATION = 'Registration'
ACCOMMODATION = 'Accommodation'
TRANSPORTATION = 'Transportation'

DEFAULT_EVENT_ITEM_GROUPS = (
    (REGISTRATION, REGISTRATION),
    (ACCOMMODATION, ACCOMMODATION),
    (TRANSPORTATION, TRANSPORTATION)
)


class EventItemGroup(Base):
    uuid = models.UUIDField(default=uuid.uuid4, db_index=True, editable=False)
    name = models.CharField(max_length=255)
    event = models.ForeignKey('events.Event', on_delete=models.CASCADE)
    event_registration_type = models.ForeignKey('events.EventRegistrationType', on_delete=models.CASCADE)
    slug = models.SlugField(db_index=True, editable=False)
    description = models.TextField(blank=True)
    is_multi_select = models.BooleanField()  # to decide whether to choose radio button and check box
    icon_type = models.CharField(max_length=255, blank=True)  # for storing the fa icons class eg. 'fa fa-times'

    class Meta:
        unique_together = ('event', 'name')

    def save(self, *args, **kwargs):
        # generate slug for each newly created object
        if not self.slug:
            self.slug = self.name
        super(EventItemGroup, self).save(*args, **kwargs)

    def __str__(self):
        return self.name
