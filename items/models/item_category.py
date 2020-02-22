import uuid

from django.db import models

from users.models import Base

RECEIPT_CATEGORY = 'Receipt'
REFUND_CATEGORY = 'Refund'
COUPON_CATEGORY = 'Coupon'
APPLICABLE_TAX_CATEGORY = 'Applicable Tax'
SERVICE_CHARGE_CATEGORY = 'Service Charge'
# used for internal balance transfer and balance topup purpose
BALANCE_CATEGORY = 'Balance'
DEFAULT_ITEM_MASTER_CATEGORIES = (
    (RECEIPT_CATEGORY, RECEIPT_CATEGORY),
    (REFUND_CATEGORY, REFUND_CATEGORY),
    (COUPON_CATEGORY, COUPON_CATEGORY),
    (APPLICABLE_TAX_CATEGORY, APPLICABLE_TAX_CATEGORY),
    (SERVICE_CHARGE_CATEGORY, SERVICE_CHARGE_CATEGORY),
    (BALANCE_CATEGORY, BALANCE_CATEGORY),
)


class ItemCategory(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=255)

    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name
