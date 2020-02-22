from datetime import datetime
from decimal import Decimal
import uuid
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models

from users.models import Base

# starts >> this section is used to provide name for default item_master_to_be_created on initial populate db
BANK_PAYMENT_ITEM = 'Bank-Payment'
CASH_PAYMENT_ITEM = 'Cash-Payment'
CREDIT_CARD_PAYMENT_ITEM = 'Credit-Card-Payment'
REFUND_ITEM = 'Refund'
DISCOUNT_COUPON_ITEM = 'Discount-Coupon'
CREDIT_COUPON_ITEM = 'Credit-Coupon'
DEBIT_COUPON_ITEM = 'Debit-Coupon'
SENIOR_CITIZEN_DISCOUNT_COUPON_ITEM = 'Senior-Citizen-Discount'
ADDED_SERVICE_CHARGE_ITEM = 'Total-Applicable-Service-Charge'
CANCELED_SERVICE_CHARGE_ITEM = 'Total-Canceled-Service-Charge'
APPLICABLE_TAX_ITEM = 'Total-Applicable-Tax'
CANCELED_TAX_ITEM = 'Total-Canceled-Tax'
BALANCE_TOPUP = 'Balance-TopUp'
BALANCE_USED = 'Balance-Used'

DEFAULT_ITEM_MASTERS_NAME = (
    (BANK_PAYMENT_ITEM, BANK_PAYMENT_ITEM),
    (CASH_PAYMENT_ITEM, CASH_PAYMENT_ITEM),
    (CREDIT_CARD_PAYMENT_ITEM, CREDIT_CARD_PAYMENT_ITEM),
    (REFUND_ITEM, REFUND_ITEM),
    (DISCOUNT_COUPON_ITEM, DISCOUNT_COUPON_ITEM),
    (CREDIT_COUPON_ITEM, CREDIT_COUPON_ITEM),
    (DEBIT_COUPON_ITEM, DEBIT_COUPON_ITEM),
    (SENIOR_CITIZEN_DISCOUNT_COUPON_ITEM, SENIOR_CITIZEN_DISCOUNT_COUPON_ITEM),
    (ADDED_SERVICE_CHARGE_ITEM, ADDED_SERVICE_CHARGE_ITEM),
    (CANCELED_SERVICE_CHARGE_ITEM, CANCELED_SERVICE_CHARGE_ITEM),
    (APPLICABLE_TAX_ITEM, APPLICABLE_TAX_ITEM),
    (CANCELED_TAX_ITEM, CANCELED_TAX_ITEM),
    (BALANCE_TOPUP, BALANCE_TOPUP),
    (BALANCE_USED, BALANCE_USED),
)


#  ends
# (uuid,name,service_id,process_id,uom_id,category_id,options,item_rate,item_mrp,item_in_stock,description)

class ItemMaster(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=255, unique=True)
    service = models.ForeignKey('items.ItemService', on_delete=models.CASCADE)
    process = models.ForeignKey('items.ItemProcessMaster',
                                on_delete=models.CASCADE)  # default 1 signifies its first instance id for general type
    uom = models.ForeignKey('items.UnitOfMeasurement', on_delete=models.CASCADE)
    category = models.ForeignKey('items.ItemCategory', on_delete=models.CASCADE)
    options = models.CharField(max_length=255, blank=True)  # extra attributes for item eg. hot pizza, hot sour pizza
    item_for_booking = models.BooleanField(default=False)  # item is bookable or not
    item_for_sale = models.BooleanField(default=True)
    item_for_purchase = models.BooleanField(default=False)
    item_for_stock = models.BooleanField(
        default=True)  # to signify if item is on stock or not ,depends on value of item_in_stock integer-field
    item_for_rent = models.BooleanField(default=False)
    item_for_package = models.BooleanField(default=False)
    item_has_substitute = models.BooleanField(default=False)
    item_is_veg = models.BooleanField(default=False)
    item_is_non_veg = models.BooleanField(default=False)
    item_is_liquor = models.BooleanField(default=False)
    # to indicate that item is balance_topup
    item_is_balance_topup = models.BooleanField(default=False)
    # to indicate that item is balance is used for self transfer
    item_is_balance_used = models.BooleanField(default=False)

    item_is_reward = models.BooleanField(default=False)
    item_is_discount = models.BooleanField(default=False)
    item_is_service_charge = models.BooleanField(default=False)
    item_is_tax = models.BooleanField(default=False)
    senior_citizen_discount_per = models.DecimalField(max_digits=5, decimal_places=2,
                                                      default=0.00, validators=[MinValueValidator(Decimal('0.00')),
                                                                                MaxValueValidator(Decimal('100.00'))])
    # senior_citizen_discount_per signifies the percentage which will be used to reduce discount amount from item rate
    # eg. if eventItem has senior_citizen_discount_applicable = True, discount will be applied in conference fee
    ask_for_delivery = models.BooleanField(default=False)
    item_rate = models.DecimalField(max_digits=19, decimal_places=2)
    item_sc_per = models.DecimalField(max_digits=5, decimal_places=2, default=0.00,
                                      validators=[MinValueValidator(Decimal('0.00')),
                                                  MaxValueValidator(Decimal('100.00'))])
    item_tax_per = models.DecimalField(max_digits=5, decimal_places=2, default=0.00,
                                       validators=[MinValueValidator(Decimal('0.00')),
                                                   MaxValueValidator(Decimal('100.00'))])
    item_mrp = models.DecimalField(max_digits=19, decimal_places=2)  # item_rate + item_sc + item_tax
    is_public = models.BooleanField(default=True)  # only staff can buy or available to public
    status = models.BooleanField(
        default=True)  # signifies whether item is active or inactive to show on items list anywhere
    is_coupon_item = models.BooleanField(default=False)
    item_in_stock = models.PositiveIntegerField()
    item_rate_deposits = models.DecimalField(max_digits=19, decimal_places=2, default=0.00)  # only for rent-able items
    has_addon_items = models.BooleanField(default=False)  # for item addons
    description = models.TextField()

    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name

    def get_item_tax_amount(self):
        return Decimal(self.item_tax_per) * Decimal(self.item_rate)

    def get_item_service_charge_amount(self):
        return Decimal(self.item_sc_per) * Decimal(self.item_rate)

    def get_item_service_charge_percentage(self):
        return self.item_sc_per

    def get_item_tax_percentage(self):
        return self.item_tax_per

    @staticmethod
    def current_year():
        return datetime.today().year

    def save(self, *args, **kwargs):
        # Newly created object, so set calculate mrp price for item using item_sc,
        # item_rate, item_tax fields

        self.item_mrp = Decimal(self.item_rate) + (Decimal(self.item_sc_per) / 100) * Decimal(
            self.item_rate) + (Decimal(self.item_tax_per) / 100) * Decimal(
            self.item_rate)

        # if item_in_stock integer is 0 , it means item is not available ,
        # hence item_for_stock should be set False
        if self.item_in_stock == 0:
            self.item_for_stock = False

        super(ItemMaster, self).save(*args, **kwargs)

# validator syntax
# validators=[MinValueValidator(Decimal('0.00')),
#                                                   MaxValueValidator(Decimal('100.00'))]
