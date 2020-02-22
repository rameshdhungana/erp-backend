import uuid

from django.contrib.auth.models import AbstractUser
from django.db import models
from django_countries.fields import CountryField

# Create your models here.

MALE = 'Male'
FEMALE = 'Female'
OTHER = 'Other'
NOT_SPECIFIED = 'Not-Specified'
GENDER_CHOICES = (
    (MALE, MALE),
    (FEMALE, FEMALE),
    (OTHER, OTHER),
    (NOT_SPECIFIED, NOT_SPECIFIED),

)
FINANCE = 'Finance'
HUMAN_RESOURCE_MANAGER = 'HR'

DEFAULT_GROUP_NAMES = (
    (FINANCE, FINANCE),
    (HUMAN_RESOURCE_MANAGER, HUMAN_RESOURCE_MANAGER)

)


class User(AbstractUser):
    uuid = models.UUIDField(unique=True, default=uuid.uuid4, editable=False, db_index=True)
    phone_number = models.CharField(unique=True, max_length=20)
    city = models.CharField(max_length=255, blank=True)
    country = CountryField(blank=False, null=False)
    profile_picture = models.ImageField(upload_to='users/profile-pictures', null=True, blank=True)
    gender = models.CharField(choices=GENDER_CHOICES, max_length=15)

    # object = BaseManager()
    # all_objects = BaseManager(alive_only=False)
    REQUIRED_FIELDS = ['phone_number', 'email']

    def __str__(self):
        return '{} {}  {}'.format(self.first_name, self.last_name, self.phone_number)
