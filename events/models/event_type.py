import uuid

from django.db import models

from users.models import Base


class EventType(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(null=True, blank=True)

    def __repr__(self):
        return self.name
