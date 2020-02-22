import uuid

from django.db import models
from phonenumber_field.modelfields import PhoneNumberField

from events.models import ITEM_GROUP_TYPE_CHOICES
from users.models import Base

ONSITE = 'OnSite'
OFFSITE = 'OffSite'

INITIATED = 'Initiated'
CONFIRMED = 'Confirmed'
CANCELED = 'Cancelled'

EVENT_REGISTRATION_STATUS = (
    (INITIATED, INITIATED),
    (CONFIRMED, CONFIRMED),
    (CANCELED, CANCELED),
)

ACCOMMODATION_GROUP_TYPE_CHOICES = (
    (OFFSITE, OFFSITE),
    (ONSITE, ONSITE),
)


class EventAttendee(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    user = models.ForeignKey('users.User', on_delete=models.CASCADE)
    smart_card_number = models.CharField(max_length=6, blank=True, null=True)
    #  if name_in_smart_card is not blank, it means the smart card number is valid one
    name_in_smart_card = models.CharField(max_length=255, blank=True, null=True)
    alternate_email = models.EmailField(null=True, blank=True)
    alternate_phone_number = models.CharField(null=True, blank=True, max_length=32)
    is_senior_citizen = models.BooleanField(default=False)
    is_pwk = models.BooleanField(default=False)
    event = models.ForeignKey('events.Event', on_delete=models.CASCADE)
    event_registration_type = models.ForeignKey('events.EventRegistrationType', on_delete=models.CASCADE)
    registered_by = models.ForeignKey('self', on_delete=models.SET_NULL, null=True)
    registration_status = models.CharField(max_length=20,
                                           choices=EVENT_REGISTRATION_STATUS)  # to indicate status of
    # registration for attendee
    group_type = models.CharField(max_length=10, blank=True,
                                  choices=ACCOMMODATION_GROUP_TYPE_CHOICES)  # for main_attendee , to specify offsite or onsite registration
    # confirmation_code is used models.TextField(blank=True)to view and edit the order
    confirmation_code = models.CharField(max_length=64, blank=True)
    # changed_to_offsite is used to keep track of if registration was previously onsite and changed to offsite
    # during order edit. its value is True for main_attendee, when he/she changes the group_type,
    changed_to_offsite = models.BooleanField(default=False)
    #  is used to track if that registration is cancelled , to maintain in cart items
    registration_is_cancelled = models.BooleanField(default=False)
    # changed_to_onsite is used to keep track of if registration was previously offsite and changed to onsite
    # during order edit. its value is True for main_attendee, when he/she changes the group_type,
    changed_to_onsite = models.BooleanField(default=False)
    # note for attendee cancellation
    note = models.TextField(blank=True)

    class Meta:
        unique_together = ('event', 'user')
        ordering = ('-id',)

    def __repr__(self):
        return '{} {} {}'.format(self.user.first_name, self.user.last_name, self.user.phone_number)

    def __str__(self):
        return '{} {} {}'.format(self.user.first_name, self.user.last_name, self.user.phone_number)

    def number_of_guests(self):
        return self.registered_by
