import uuid

from django.db import models

from users.models import Base

RECEIPT_SERVICE = 'Receipt'
REFUND_SERVICE = 'Refund'
COUPON_SERVICE = 'Coupon'
APPLICABLE_TAX_SERVICE = 'Applicable Tax'
SERVICE_CHARGE_SERVICE = 'Service Charge'
# balance service used for balance topup and internal balance used(self transfer)
BALANCE_SERVICE = 'Balance'
DEFAULT_ITEM_MASTER_SERVICES = (
    (RECEIPT_SERVICE, RECEIPT_SERVICE),
    (REFUND_SERVICE, REFUND_SERVICE),
    (COUPON_SERVICE, COUPON_SERVICE),
    (SERVICE_CHARGE_SERVICE, SERVICE_CHARGE_SERVICE),
    (APPLICABLE_TAX_SERVICE, APPLICABLE_TAX_SERVICE),
    (BALANCE_SERVICE, BALANCE_SERVICE),
)


class ItemService(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=255, unique=True)

    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name
