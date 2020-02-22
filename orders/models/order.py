import uuid
from datetime import datetime

from django.db import models

from users.models import Base

PENDING = 'Pending'
APPROVED = 'Approved'
ORDER_STATUS_CHOICES = (
    (PENDING, PENDING),
    (APPROVED, APPROVED)
)
E_REGISTRATION = 'e-registration'

ORDER_TRANSACTION_TYPE_CHOICES = (
    (E_REGISTRATION, 'e-registration'),

)


class Order(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    order_number = models.IntegerField(default=0)
    order_cfy = models.CharField(max_length=32)
    user = models.ForeignKey('users.User', related_name='orders', on_delete=models.CASCADE)
    event = models.ForeignKey('events.Event', related_name='event_orders',
                              on_delete=models.SET_NULL, null=True)
    event_registration_type = models.ForeignKey('events.EventRegistrationType',
                                                on_delete=models.SET_NULL, null=True)
    event_attendee = models.ForeignKey('events.EventAttendee', related_name='event_registration',
                                       on_delete=models.SET_NULL, null=True)
    order_items = models.ManyToManyField('orders.OrderedItem')
    previous_order = models.OneToOneField('orders.Order', on_delete=models.SET_NULL, null=True)
    transaction_type = models.CharField(max_length=255, choices=ORDER_TRANSACTION_TYPE_CHOICES)
    balance = models.DecimalField(max_digits=19, decimal_places=2, default=0.00)  # total amount paid in order
    balance_credit = models.DecimalField(max_digits=19, decimal_places=2, default=0.00)  # total amount paid in order
    device_id = models.CharField(max_length=255, blank=True)
    operator = models.ForeignKey('users.User', related_name='order_operations', on_delete=models.SET_NULL, null=True)
    web_initiated = models.BooleanField(default=False)
    app_initiated = models.BooleanField(default=False)
    one_time_password = models.CharField(max_length=255, blank=True)
    notes = models.TextField(max_length=2000, blank=True)
    # delivery_id = models.ForeignKey(DeliveryLocation, on_delete=models.CASCADE)
    delivery_access = models.CharField(max_length=255, blank=True)
    order_status = models.CharField(max_length=20, choices=ORDER_STATUS_CHOICES, default=PENDING)

    class Meta:
        # TODO : check for ordering and get_latest_by working properly
        # ordering = ('-created_at',)
        get_latest_by = 'created_at'

    @staticmethod
    def current_year():
        return datetime.today().year

    def save(self, *args, **kwargs):
        order_cfy_and_order_number_tracker = OrderCfyAndOrderNumberTracker.objects.order_by('-created_at').first()
        # first we check if there is ordercfyandordernumbertracker object, if yes we get latest_ordernumber and latest_
        # order_number
        if order_cfy_and_order_number_tracker:
            latest_order_number = order_cfy_and_order_number_tracker.latest_order_number
            latest_order_cfy = order_cfy_and_order_number_tracker.latest_order_cfy

            #  if order order_number is not updated till now, we compare the current year code with latest_order_cfy
            # if they are not same, it means fisal year has started hence we need to start order_number from the 1
            if not self.order_number:
                #  occurs once in every fiscal year
                if latest_order_cfy != str(self.current_year()):
                    self.order_number = 1
                    # since new fiscal year has started , we need to create another order_cfy_and_order_number_tracker
                    #  object with latest_order_cfy as new fiscal year date
                    OrderCfyAndOrderNumberTracker.objects.get_or_create(
                        latest_order_cfy=self.current_year())


                else:
                    self.order_number = latest_order_number + 1
                    # we also update the latest_order_number of the order_cfy_and_order_number_tracker object
                    order_cfy_and_order_number_tracker.latest_order_number = (
                            order_cfy_and_order_number_tracker.latest_order_number + 1)
                    order_cfy_and_order_number_tracker.save()
        else:
            # this occurs only once only when first order is created
            # ordercfyandordenumbertrackere object does not exits till date we, create object
            order_cfy_and_order_number_tracker = OrderCfyAndOrderNumberTracker.objects.get_or_create(
                latest_order_cfy=self.current_year())

            if not self.order_number:
                self.order_number = 1

        if not self.order_cfy:
            self.order_cfy = self.current_year()

        #  here we write the logic to calculate the rate related fields

        super(Order, self).save(*args, **kwargs)


class OrderCfyAndOrderNumberTracker(Base):
    latest_order_number = models.IntegerField(default=1)
    latest_order_cfy = models.CharField(max_length=32)
