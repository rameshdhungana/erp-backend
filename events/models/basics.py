from django.db import models
from django_countries.fields import CountryField
from phonenumber_field.modelfields import PhoneNumberField

from users.models import Base


class Images(Base):
    title = models.CharField(max_length=255, blank=True)
    image = models.ImageField()


class PhoneNumber(Base):
    is_visible = models.BooleanField(default=True)
    phone_number = PhoneNumberField()
    country = CountryField()
    organizer = models.ForeignKey('Organizer', on_delete=models.CASCADE)
    event = models.ForeignKey('Event', on_delete=models.CASCADE)
    label = models.TextField()
