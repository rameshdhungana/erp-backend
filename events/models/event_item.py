import uuid
from datetime import datetime
from decimal import Decimal

from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from pytz import utc

from users.models import Base

ONSITE = 'OnSite'
OFFSITE = 'OffSite'
BOTH = 'Both'

ITEM_GROUP_TYPE_CHOICES = (
    (OFFSITE, OFFSITE),
    (ONSITE, ONSITE),
    (BOTH, BOTH),
)


class EventItem(Base):
    uuid = models.UUIDField(default=uuid.uuid4, db_index=True)
    item_master = models.ForeignKey('items.ItemMaster', on_delete=models.CASCADE)
    group = models.ForeignKey('events.EventItemGroup', on_delete=models.CASCADE)
    event = models.ForeignKey('events.Event', on_delete=models.CASCADE)
    event_registration_type = models.ForeignKey('events.EventRegistrationType', on_delete=models.CASCADE)
    group_type = models.CharField(max_length=10, choices=ITEM_GROUP_TYPE_CHOICES)
    item_capacity = models.PositiveIntegerField(validators=[MinValueValidator(int(1))])
    items_booked = models.PositiveIntegerField(default=0)
    item_sharing_count = models.PositiveIntegerField(validators=[MinValueValidator(int(1))])
    discount_before_early_bird = models.DecimalField(max_digits=5, decimal_places=2,
                                                     validators=[MinValueValidator(Decimal('0.00')),
                                                                 MaxValueValidator(Decimal('100.00'))])  # percentage
    discount_after_early_bird = models.DecimalField(max_digits=5, decimal_places=2,
                                                    validators=[MinValueValidator(Decimal('0.00')),
                                                                MaxValueValidator(Decimal('100.00'))])  # percentage
    is_day_pass_item = models.BooleanField()
    senior_citizen_discount_applicable = models.BooleanField(default=False)
    # start of fields applicable only for transportation items
    ask_for_arrival_datetime = models.BooleanField(default=False)
    ask_for_departure_datetime = models.BooleanField(default=False)
    ask_for_pickup_location = models.BooleanField(default=False)
    transportation_pickup_locations = models.ManyToManyField('events.TransportationPickupLocation', blank=True)
    # this is only for accommodation items
    accommodation_rooms = models.ManyToManyField('events.AccommodationRoom', blank=True)

    #  end of fields appliacable for only transportation items

    def __str__(self):
        return '{}'.format(self.item_master.name)

    def __repr__(self):
        return '{}'.format(self.item_master.name)

    class Meta:
        unique_together = ('item_master', 'event_registration_type', 'event', 'group_type')
        ordering = ('-created_at',)

    def get_early_bird_rate(self):
        return Decimal(self.item_master.item_rate) - (self.discount_before_early_bird / 100 * Decimal(
            self.item_master.item_rate))

    def get_late_bird_rate(self):
        return Decimal(self.item_master.item_rate) - (self.discount_after_early_bird / 100 * Decimal(
            self.item_master.item_rate))

    def get_current_rate(self):
        current_datetime = datetime.utcnow()
        if current_datetime.replace(tzinfo=utc) < self.event.early_bird_date.replace(tzinfo=utc):
            return self.get_early_bird_rate()
        else:
            return self.get_late_bird_rate()

# following statement to get the value of event items in csv from already existing database
# \copy (SELECT item_master_id,group_id,event_id,event_registration_type_id,group_type,item_capacity,
# items_booked,item_sharing_count,discount_before_early_bird,discount_after_early_bird,is_day_pass_item
# FROM events_eventitem) to 'eventitem_backup.csv' with csv;
