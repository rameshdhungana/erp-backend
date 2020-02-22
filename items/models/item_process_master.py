import uuid

from django.db import models

from users.models import Base

GENERAL_PROCESS_MASTER = 'GEN'
KITCHEN_PROCESS_MASTER = 'KIT'

PROCESS_MASTER_CHOICES = (
    (GENERAL_PROCESS_MASTER, GENERAL_PROCESS_MASTER),
    (KITCHEN_PROCESS_MASTER, KITCHEN_PROCESS_MASTER)
)


class ItemProcessMaster(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=32, choices=PROCESS_MASTER_CHOICES, default='GENERAL', unique=True,
                            db_index=True)

    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name
