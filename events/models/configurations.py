import uuid as uuid

from django.db import models

from users.models import Base


class Configuration(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    key = models.CharField(max_length=255, unique=True)
    value = models.TextField()

    def __repr__(self):
        return self.key
