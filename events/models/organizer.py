import uuid

from django.db import models

from users.models import Base


class Organizer(Base):
    uuid = models.UUIDField(default=uuid.uuid4, editable=False, db_index=True)
    name = models.CharField(max_length=255)
    location = models.CharField(max_length=255)
    description = models.TextField(null=True, blank=True)
    logo = models.ManyToManyField('Images')

    def __repr__(self):
        return self.name
