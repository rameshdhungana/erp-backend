from django.db import models
from django.utils import timezone

from users.managers import BaseManager


class Base(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    deleted_at = models.DateTimeField(null=True, blank=True, editable=False)
    created_by = models.IntegerField(null=True)
    updated_by = models.IntegerField(null=True)
    deleted_by = models.IntegerField(null=True)

    objects = BaseManager()
    all_objects = BaseManager(alive_only=False)

    class Meta:
        abstract = True

    def delete(self):
        self.deleted_at = timezone.now()
        self.save()

    def hard_delete(self):
        super(Base, self).delete()
