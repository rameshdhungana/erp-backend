# import uuid
#
# from django.contrib.auth import get_user_model
# from django.contrib.postgres.fields import ArrayField
# from django.db import models
# from django_countries.fields import CountryField
# from phonenumber_field.modelfields import PhoneNumberField
#
# from users.models import Base
#
# User = get_user_model()
#
#
# class EventRegistrationType(Base):
#     uuid = models.UUIDField(default=uuid.uuid4, editable=False)
#     name = models.CharField(max_length=255)
#     slug = models.SlugField()
#     total_capacity = models.IntegerField()
#     event = models.ForeignKey(Event, on_delete=models.CASCADE)
#     published = models.BooleanField()
#     max_tickets_per_order = models.IntegerField()
#     required_otp = models.BooleanField()
#
#
# class EventItemGroup(models.Model):
#     GROUP_TYPE_CHOICES = (
#         ('OffSite', 'OffSite'),
#         ('OnSite', 'OnSite')
#     )
#     name = models.CharField(max_length=255)
#     registration_type = models.ForeignKey(EventRegistrationType, on_delete=models.CASCADE)
#     slug = models.SlugField()
#     description = models.TextField()
#     multiselect = models.BooleanField()
#     group_ordering = models.IntegerField()
#     group_type = models.CharField(max_length=255, choices=GROUP_TYPE_CHOICES)
#     event = models.ForeignKey(Event, on_delete=models.CASCADE)
#     icon_type = models.CharField(max_length=255)
#
#
# class EventItem(models.Model):
#     name = models.CharField(max_length=255)
#     group = models.ForeignKey(EventItemGroup, on_delete=models.CASCADE)
#     event = models.ForeignKey(Event, on_delete=models.CASCADE)
#     registration_type = models.ForeignKey(EventRegistrationType, on_delete=models.CASCADE)
#     item_capacity = models.IntegerField()
#     items_booked = models.IntegerField()
#     item_sharing_count = models.IntegerField()
#     rate_before_early_bird = models.DecimalField(max_digits=19, decimal_places=2)
#     rate_after_early_bird = models.DecimalField(max_digits=19, decimal_places=2)
#
#
# class DeliveryLocation(models.Model):
#     uuid = models.UUIDField(default=uuid.uuid4, editable=False)
#     location_id = models.CharField(max_length=255)
#     location_name = models.CharField(max_length=255)
#     required_address = models.BooleanField()
#
#
# class EventRegistration(models.Model):
#     uuid = models.UUIDField(uuid.uuid4, editable=False)
#
#
# class ItemCategory(models.Model):
#     uuid = models.UUIDField(uuid.uuid4, editable=False)
#
#
# class Service(models.Model):
#     uuid = models.UUIDField(uuid.uuid4, editable=False)
#
#
# class ProcessMaster(models.Model):
#     uuid = models.UUIDField(uuid.uuid4, editable=False)
#
#
# class UnitOfMeasurement(models.Model):
#     uuid = models.UUIDField(uuid.uuid4, editable=False)
#
#
# class ItemMaster(models.Model):
#     uuid = models.UUIDField(default=uuid.uuid4, editable=False)
#     item_id = models.IntegerField()
#     service = models.ForeignKey(Service, on_delete=models.CASCADE)
#     item_name = models.CharField(max_length=255, unique=True)
#     item_options = ArrayField(models.CharField(max_length=255))
#     item_for_booking = models.BooleanField()
#     item_for_sale = models.BooleanField()
#     item_for_purchase = models.BooleanField()
#     item_for_stock = models.BooleanField()
#     item_for_rent = models.BooleanField()
#     item_for_package = models.BooleanField()
#     item_has_substitute = models.BooleanField()
#     item_is_veg = models.BooleanField()
#     item_is_non_veg = models.BooleanField()
#     item_is_liquor = models.BooleanField()
#
#     item_is_reward = models.BooleanField()
#     item_is_discount = models.BooleanField()
#     item_is_servicecharge = models.BooleanField()
#     item_is_tax = models.BooleanField()
#     item_processes = models.ForeignKey(ProcessMaster, on_delete=models.CASCADE)
#     ask_for_delivery = models.BooleanField()
#     uom = models.ForeignKey(UnitOfMeasurement, on_delete=models.CASCADE)
#     item_cat = models.ForeignKey(ItemCategory, on_delete=models.CASCADE)
#     item_sc = models.DecimalField(max_digits=19, decimal_places=10)
#     item_tax = models.DecimalField(max_digits=19, decimal_places=10)
#     item_mrp = models.DecimalField(max_digits=19, decimal_places=10)
#     is_public = models.BooleanField()
#     status = models.BooleanField()
#     item_in_stock = models.IntegerField()
#     item_rate_deposits = models.DecimalField(max_digits=19, decimal_places=10)
#     has_addon_items = models.BooleanField()
#
#
# class OrderedItem(models.Model):
#     TRANSACTION_TYPE_CHOICES = (
#         ('sale', 'sale'),
#         ('cancel', 'cancel'),
#         ('receipt', 'receipt'),
#         ('payments', 'payments'),
#     )
#     uuid = models.UUIDField(uuid.uuid4, editable=False)
#     order_id = models.IntegerField()
#     order_cfy = models.DateField()
#     user_id = models.ForeignKey(User, on_delete=models.CASCADE)
#     item_id = models.ForeignKey(ItemMaster, related_name='total_orders', on_delete=models.CASCADE)
#     actual_item_id = models.ForeignKey(ItemMaster, on_delete=models.CASCADE)
#     parent_order_uuid = models.ForeignKey('self', on_delete=models.CASCADE)
#     transaction_type = models.CharField(max_length=255, choices=TRANSACTION_TYPE_CHOICES)
#     privileged = models.BooleanField()
#     quantity = models.IntegerField()
#     rate = models.DecimalField(max_digits=19, decimal_places=10)
#     amount = models.DecimalField(max_digits=19, decimal_places=10)
#     discount = models.DecimalField(max_digits=19, decimal_places=10)
#     reward = models.DecimalField(max_digits=19, decimal_places=10)
#     amount_net = models.DecimalField(max_digits=19, decimal_places=10)
#     item_sc = models.DecimalField(max_digits=19, decimal_places=10)
#     amount_taxable = models.DecimalField(max_digits=19, decimal_places=10)
#     item_tax = models.DecimalField(max_digits=19, decimal_places=10)
#     amount_final = models.DecimalField(max_digits=19, decimal_places=10)
#
#
# class Order(models.Model):
#     ORDER_STATUS_CHOICES = (
#         (0, 'Pending'),
#         (1, 'Approved')
#     )
#     uuid = models.UUIDField(default=uuid.uuid4, editable=False)
#     order_id = models.IntegerField()
#     order_cfy = models.DateField()
#     user_id = models.ForeignKey(User, related_name='orders', on_delete=models.CASCADE)
#     # TODO: Need to implement transaction type choices
#     transaction_type = models.CharField(max_length=255)
#     transaction_reference = models.ForeignKey(EventRegistration, related_name='transaction_reference',
#                                               on_delete=models.CASCADE)
#     amount_in_cash = models.DecimalField(max_digits=19, decimal_places=10)
#     amount_rewards = models.DecimalField(max_digits=19, decimal_places=10)
#     device_id = models.CharField(max_length=255)
#     operator_id = models.ForeignKey(User, related_name='order_operations', on_delete=models.CASCADE)
#     web_initiated = models.BooleanField()
#     app_initiated = models.BooleanField()
#     one_time_password = models.CharField(max_length=255)
#     notes = models.CharField(max_length=255)
#     delivery_id = models.ForeignKey(DeliveryLocation, on_delete=models.CASCADE)
#     delivery_access = models.CharField(max_length=255)
#     order_status = models.CharField(max_length=255)
#     order_items = models.ManyToManyField(OrderedItem)
#     event_registration = models.ForeignKey(EventRegistration, related_name='event_registration',
#                                            on_delete=models.CASCADE)
#
#
# class ItemAddOn(models.Model):
#     uuid = models.UUIDField(default=uuid.uuid4, editable=False)
#     item = models.ForeignKey(ItemMaster, on_delete=models.CASCADE, related_name='items')
#     add_on_item = models.ForeignKey(ItemMaster, on_delete=models.CASCADE, related_name='add_on_items')
#
#
# class ItemSubstitue(models.Model):
#     uuid = models.UUIDField(default=uuid.uuid4, editable=False)
#     item = models.ForeignKey(ItemMaster, on_delete=models.CASCADE)
