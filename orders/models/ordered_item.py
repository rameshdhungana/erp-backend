import uuid
from decimal import Decimal

from django.db import models
from datetime import datetime

from users.models import Base

SALE = 'Sale'  # when item added to cart is OrderItem table
CANCEL = 'Cancel'  # when item is cancelled
RECEIPT = 'Receipt'  # when we receive payments( we associate to default item master for receipt section)
REFUND = 'Refund'  # when we have to refund the amount , we create item with
COUPON = 'Coupon'
BALANCE = 'Balance'

SELF_TRANSFER = 'Self Transfer'
TAX_OR_SERVICE_CHARGE = 'Item-Tax-Or-Service-Charge'
CANCELLATION_CHARGE = 'Cancellation-Charge'  # is applied when then cancellation policy is applied to item when item
#  ordered is cancelled in order edit

ORDER_ITEM_TRANSACTION_TYPE_CHOICES = (
    (SALE, SALE),
    (CANCEL, CANCEL),
    (RECEIPT, RECEIPT),
    (REFUND, REFUND),
    (COUPON, COUPON),
    (BALANCE, BALANCE),
    (SELF_TRANSFER, SELF_TRANSFER),
    (TAX_OR_SERVICE_CHARGE, TAX_OR_SERVICE_CHARGE),
    (CANCELLATION_CHARGE, CANCELLATION_CHARGE),
)


class OrderedItem(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    order_number = models.IntegerField()  # value is obtained from its main Order model associated to it
    order_cfy = models.CharField(max_length=32)  # value is obtained from its main Order model associated to it
    user = models.ForeignKey('users.User', on_delete=models.CASCADE)
    event = models.ForeignKey('events.Event', on_delete=models.SET_NULL, null=True)
    event_registration_type = models.ForeignKey('events.EventRegistrationType', on_delete=models.SET_NULL, null=True)
    event_attendee = models.ForeignKey('events.EventAttendee', on_delete=models.SET_NULL, null=True)
    item_master = models.ForeignKey('items.ItemMaster', related_name='total_orders', on_delete=models.CASCADE)
    event_item = models.ForeignKey('events.EventItem', on_delete=models.SET_NULL, null=True)
    # actual_item_master: eg needed for coffee , refreshment items
    actual_item_master = models.ForeignKey('items.ItemMaster', on_delete=models.CASCADE, null=True,
                                           related_name='actual_item_master')
    parent_order = models.ForeignKey('self', on_delete=models.CASCADE,
                                     null=True)  # is used for shared items. eg accommodation
    #  canceled_item_reference is used to store the reference of ordered_item 'self' , if any item is cancelled
    # , we store the reference of orderedItem against which it is cancelled. While filtering , we apply the query to
    # exclude all ordered_items that are in canceled_item_reference > which means SALE and CANCEL type of
    #  same item are filtered out , and adding same item next time will be single one to its type as active one.
    canceled_ordered_item = models.ForeignKey('self', on_delete=models.SET_NULL, null=True,
                                              related_name='cancellation_reference')
    #  this field to store the extra information such as arrival date time , departure date time and pickup locations
    #  for transportation items , contains no value for other items
    transportation_info = models.ForeignKey('events.TransportationInfo', on_delete=models.SET_NULL, null=True)

    transaction_type = models.CharField(max_length=255, choices=ORDER_ITEM_TRANSACTION_TYPE_CHOICES)
    transaction_reference_id = models.CharField(blank=True,
                                                max_length=255)  # is used to enter the digital payments transaction id
    privileged = models.BooleanField(default=False)
    # TODO: action on previleged
    quantity = models.IntegerField(default=1)  # will be negative for the discount or credit item
    rate = models.DecimalField(max_digits=19, decimal_places=2)  # early_bird_rate or late_bird_rate
    amount = models.DecimalField(max_digits=19,
                                 decimal_places=2)  # amount = rate * quantity
    discount = models.DecimalField(max_digits=19, decimal_places=2,
                                   default=0.00)  # should not be greater than amount ( if yes make it equal to amount)
    amount_net = models.DecimalField(max_digits=19, decimal_places=2)  # amount_net = amount -discount
    item_sc = models.DecimalField(max_digits=19, decimal_places=2,
                                  default=0.00)  # amount_from_item_master * quantity
    # obtained form item_master  (call get_item_service_charge_amount
    # from item_master)
    amount_taxable = models.DecimalField(max_digits=19, decimal_places=2)  # amount_from_item_master * quantity
    # amount_taxable =  amount_net + item_sc
    item_tax = models.DecimalField(max_digits=19, decimal_places=2, default=0.00)  # obtained form item_master
    amount_final = models.DecimalField(max_digits=19, decimal_places=2)  # amount_final  = amount_taxable + item_tax
    is_coupon_item = models.BooleanField(default=False)
    coupon = models.ForeignKey('coupons.Coupon', null=True, on_delete=models.SET_NULL)
    # notes for cancellation TODO:
    notes = models.TextField()

    class Meta:
        ordering = ('-created_at',)
        get_latest_by = 'created_at'

    def save(self, *args, **kwargs):
        super(OrderedItem, self).save(*args, **kwargs)

    def __repr__(self):
        return self.item_master.name

    def __str__(self):
        return self.item_master.name
