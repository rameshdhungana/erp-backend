import uuid as uuid
from decimal import Decimal

from django.db import models

from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES
from users.models import Base


class ItemCart(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    user = models.ForeignKey('users.User', on_delete=models.CASCADE)
    event_attendee = models.ForeignKey('events.EventAttendee', on_delete=models.CASCADE)
    # this ordered_by field actually indicates who ordered the registration and pay for it
    # its value will be self object for main_attendee and main_attendee for guest_attendee
    ordered_by_attendee = models.ForeignKey('events.EventAttendee', on_delete=models.CASCADE,
                                            related_name='attendee_carts')
    ordered_by_user = models.ForeignKey('users.User', on_delete=models.CASCADE, related_name='user_carts')

    item_master = models.ForeignKey('items.ItemMaster', on_delete=models.CASCADE)
    #  event_item  will be null for special items ( discount, coupons, payments)
    event_item = models.ForeignKey('events.EventItem', on_delete=models.CASCADE, null=True)
    #  canceled_item_reference is used to store the reference of ordered_item 'self' , if any item is cancelled
    # , we store the reference of orderedItem against which it is cancelled. While filtering , we apply the query to
    # exclude all ordered_items that are in canceled_item_reference > which means SALE and CANCEL type of
    #  same item are filtered out , and adding same item next time will be single one to its type as active one.
    canceled_ordered_item = models.ForeignKey('orders.OrderedItem', on_delete=models.SET_NULL, null=True)
    event = models.ForeignKey('events.Event', on_delete=models.SET_NULL, null=True)
    event_registration_type = models.ForeignKey('events.EventRegistrationType', on_delete=models.SET_NULL, null=True)
    #  transaction_type indicates whether the item is SALE, CANCEL or other choices
    transaction_type = models.CharField(max_length=255, choices=ORDER_ITEM_TRANSACTION_TYPE_CHOICES)
    #  this field to store the extra information such as arrival date time , departure date time and pickup locations
    #  for transportation items , contains no value for other items
    transportation_info = models.ForeignKey('events.TransportationInfo', on_delete=models.SET_NULL, null=True)

    quantity = models.PositiveIntegerField(default=1)
    rate = models.DecimalField(max_digits=19, decimal_places=2)

    amount = models.DecimalField(max_digits=19, decimal_places=2)  # amount_final  = rate * quantity
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

    # this boolean field indicate whether cart items'  values such as  discount, amount_net,tax, service ,amount_final
    # etc  updated from ordered_item or calculated while saving using rate and quantity
    # this is used to avoid recalculation while cart items are updated from ordered_item
    entry_from_ordered_item = models.BooleanField(default=False)

    # apply_cancellation_policy is used to determine whether cancellation policy has to be applied to this item in cart
    #  or not, this will be set True only if the cancellation charge cart items are created, and can be reverted back
    # by the staff at cart item summary
    apply_cancellation_policy = models.BooleanField(default=False)

    class Meta:
        get_latest_by = 'created_at'

    def perform_calculation(self):
        self.amount = Decimal(Decimal(self.rate) * self.quantity)
        # discount should not be greater than amount , if yes , make it equal to amount,
        #  Note : for discount, amount becomes negative hence condition must be applied only when amount is positive
        if Decimal(self.discount) > Decimal(self.amount) > 0:
            self.discount = Decimal(self.amount)
        # now we update amount_net ( amount_net will be used for calculation of total amount for cart items
        self.amount_net = Decimal(self.amount) - Decimal(self.discount)

        self.item_sc = Decimal(self.item_master.get_item_service_charge_percentage()) / Decimal(100.00) * Decimal(
            self.amount_net)
        self.amount_taxable = Decimal(self.amount_net + self.item_sc)
        self.item_tax = Decimal(self.item_master.get_item_tax_percentage()) / Decimal(100.00) * Decimal(
            self.amount_taxable)
        self.amount_final = Decimal(self.item_tax) + Decimal(self.amount_taxable)

    def save(self, *args, **kwargs):
        # if the items are event items , then we calculate amount form current price of items
        #  but for special item masters ( discount, coupon, receipt items  , we make event_item null and amount is
        #  achieved from coupon value or amount from payments done
        if not self.entry_from_ordered_item:
            self.perform_calculation()

        super(ItemCart, self).save(*args, **kwargs)

    def __repr__(self):
        return self.item_master.name

    def __str__(self):
        return self.item_master.name
