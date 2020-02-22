import uuid as uuid

from django.db import models

from users.models import Base

DISCOUNT_COUPON = 'Discount-Coupon'
CREDIT_COUPON = 'Credit-Coupon'
DEBIT_COUPON = 'Debit-Coupon'
SENIOR_CITIZEN_DISCOUNT_COUPON = 'Senior-Citizen-Discount'
COUPON_TYPE_CHOICES = (
    (DISCOUNT_COUPON, DISCOUNT_COUPON),
    (CREDIT_COUPON, CREDIT_COUPON),
    (DEBIT_COUPON, DEBIT_COUPON),
    (SENIOR_CITIZEN_DISCOUNT_COUPON, SENIOR_CITIZEN_DISCOUNT_COUPON)
)


class Coupon(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    coupon_code = models.CharField(max_length=64, unique=True)
    amount_limit = models.DecimalField(max_digits=19, decimal_places=2)
    amount_used = models.DecimalField(max_digits=19, decimal_places=2, default=0.00)
    type = models.CharField(max_length=32, choices=COUPON_TYPE_CHOICES)
    item_master = models.ForeignKey('items.ItemMaster', null=True, on_delete=models.SET_NULL)
    user = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True)
    # created_by is the field that stores the user_id of operator who created this coupon
    created_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True,
                                   related_name='created_by_operator')
    # updated_by is the field that stores the user_id of operator who changed status of this coupon
    updated_by = models.ForeignKey('users.User', on_delete=models.SET_NULL, null=True,
                                   related_name='updated_by_operator')
    status = models.BooleanField(default=True)
    notes = models.TextField(blank=True)

    def save(self, *args, **kwargs):
        if self.amount_used > self.amount_limit:
            self.amount_used = self.amount_limit
        super(Coupon, self).save(*args, **kwargs)
