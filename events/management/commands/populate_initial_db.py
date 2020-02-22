from django.contrib.auth.models import Group
from django.core.management import BaseCommand
from django.db import transaction

from events.models import Configuration
from items.models import (ItemService, ItemCategory, UnitOfMeasurement, ItemProcessMaster,

                          PROCESS_MASTER_CHOICES,
                          UNIT_CHOICES, UNITS,
                          DEFAULT_ITEM_MASTER_SERVICES, RECEIPT_SERVICE, REFUND_SERVICE,
                          DEFAULT_ITEM_MASTER_CATEGORIES, RECEIPT_CATEGORY, REFUND_CATEGORY,
                          DEFAULT_ITEM_MASTERS_NAME, REFUND_ITEM,
                          GENERAL_PROCESS_MASTER, ItemMaster, COUPON_SERVICE, COUPON_CATEGORY, DISCOUNT_COUPON_ITEM,
                          CREDIT_COUPON_ITEM, DEBIT_COUPON_ITEM, CREDIT_CARD_PAYMENT_ITEM, CASH_PAYMENT_ITEM,
                          BANK_PAYMENT_ITEM, SERVICE_CHARGE_CATEGORY, APPLICABLE_TAX_CATEGORY, BALANCE_CATEGORY,
                          APPLICABLE_TAX_ITEM, CANCELED_TAX_ITEM,
                          CANCELED_SERVICE_CHARGE_ITEM, ADDED_SERVICE_CHARGE_ITEM, BALANCE_TOPUP, BALANCE_USED,
                          SENIOR_CITIZEN_DISCOUNT_COUPON_ITEM, SERVICE_CHARGE_SERVICE, APPLICABLE_TAX_SERVICE,
                          BALANCE_SERVICE)


class Command(BaseCommand):
    help = 'populate the initial db'

    @staticmethod
    def create_item_process_master():
        data = [{'name': dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)}]
        for each in data:
            process_master, created = ItemProcessMaster.objects.get_or_create(name=each['name'])
            print('Default process Master are created')

    @staticmethod
    def create_configurations():
        data = [
            {'key': 'contact_number_first', 'value': ' (07) 3077 9668 '},
            {'key': 'contact_number_second', 'value': ''},
            {'key': 'contact_email', 'value': 'amaroo@gmail.com'},
            {'key': 'facebook_link', 'value': 'https://www.facebook.com/'},
            {'key': 'instagram_link', 'value': 'https://www.instagram.com/'},
            {'key': 'nipuna_website_link', 'value': 'http://www.nipunaprabidhiksewa.com/'},
            {'key': 'youtube_link', 'value': 'https://www.youtube.com/'},
            {'key': 'linkedin_link', 'value': 'https://www.linkedin.com/'},
            {'key': 'copyright_content', 'value': '{}'.format(
                "<small>Ivory's Rock Conventions and Events, 310 Mount Flinders Rd, Peak Crossing QLD 4306 '</small>")},
            {'key': 'powered_by', 'value': 'Nipuna Prabidhik sewa'},
            {'key': 'footer_description',
             'value': '{}'.format('<small>"Peace will be mankind’s greatest achievement” <br>Prem Rawat</small>')}

        ]

        for each in data:
            config, created = Configuration.objects.update_or_create(key=each['key'], defaults=each)

        print('Default Configurations are created')

    @staticmethod
    def create_default_groups():
        groups = [
            {'name': 'Attendee',
             'name': 'Finance',
             'name': 'HR'
             }
        ]
        for grp in groups:
            Group.objects.get_or_create(name=grp['name'])
            print('Attendee Group is created')

    @staticmethod
    def create_unit_of_measurement():
        data = [
            {'name': dict(UNIT_CHOICES).get(UNITS)}
        ]

        for each in data:
            uom, created = UnitOfMeasurement.objects.get_or_create(name=each['name'])

            print('Default Units of measurements created')

    @staticmethod
    def create_default_item_service():
        data = [
            {'name': dict(DEFAULT_ITEM_MASTER_SERVICES).get(RECEIPT_SERVICE)},
            {'name': dict(DEFAULT_ITEM_MASTER_SERVICES).get(REFUND_SERVICE)},
            {'name': dict(DEFAULT_ITEM_MASTER_SERVICES).get(COUPON_SERVICE)},
            {'name': dict(DEFAULT_ITEM_MASTER_SERVICES).get(APPLICABLE_TAX_SERVICE)},
            {'name': dict(DEFAULT_ITEM_MASTER_SERVICES).get(SERVICE_CHARGE_SERVICE)},
            {'name': dict(DEFAULT_ITEM_MASTER_SERVICES).get(BALANCE_SERVICE)}
        ]

        for each in data:
            item_service, created = ItemService.objects.get_or_create(name=each['name'])
        print('Default item services are  created')

    @staticmethod
    def create_default_item_category():
        data = [
            {'name': dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(RECEIPT_CATEGORY)},
            {'name': dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(REFUND_CATEGORY)},
            {'name': dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(COUPON_CATEGORY)},
            {'name': dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(SERVICE_CHARGE_CATEGORY)},
            {'name': dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(APPLICABLE_TAX_CATEGORY)},
            {'name': dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(BALANCE_CATEGORY)}
        ]

        for each in data:
            item_service, created = ItemCategory.objects.get_or_create(name=each['name'])

        print('Default item categories are  created')

    @staticmethod
    def create_default_item_master():

        item_master_data = [
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(BANK_PAYMENT_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(RECEIPT_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(RECEIPT_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(CASH_PAYMENT_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(RECEIPT_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(RECEIPT_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(CREDIT_CARD_PAYMENT_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(RECEIPT_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(RECEIPT_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(REFUND_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(REFUND_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(REFUND_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(DISCOUNT_COUPON_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(COUPON_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(COUPON_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'is_coupon_item': True,
             'item_is_discount': True,

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(CREDIT_COUPON_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(COUPON_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(COUPON_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'is_coupon_item': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(DEBIT_COUPON_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(COUPON_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(COUPON_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'is_coupon_item': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(SENIOR_CITIZEN_DISCOUNT_COUPON_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(COUPON_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(COUPON_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'is_coupon_item': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(ADDED_SERVICE_CHARGE_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(SERVICE_CHARGE_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(SERVICE_CHARGE_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'item_is_service_charge': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(CANCELED_SERVICE_CHARGE_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(SERVICE_CHARGE_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(SERVICE_CHARGE_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'item_is_service_charge': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(APPLICABLE_TAX_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(APPLICABLE_TAX_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(APPLICABLE_TAX_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'item_is_tax': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(CANCELED_TAX_ITEM),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(APPLICABLE_TAX_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(APPLICABLE_TAX_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'item_is_tax': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(BALANCE_TOPUP),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(BALANCE_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(BALANCE_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'item_is_balance_topup': True

             },
            {'name': dict(DEFAULT_ITEM_MASTERS_NAME).get(BALANCE_USED),
             'service': ItemService.objects.get(name=dict(DEFAULT_ITEM_MASTER_SERVICES).get(BALANCE_SERVICE)),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),
             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=dict(DEFAULT_ITEM_MASTER_CATEGORIES).get(BALANCE_CATEGORY)),
             'item_rate': '0.00',
             'description': 'Default Created Item Masters',
             'item_in_stock': 1,
             'item_is_balance_used': True

             }

        ]

        for data in item_master_data:
            item_master, created = ItemMaster.objects.get_or_create(name=data['name'], defaults=data)
        print('Default item masters are created')

    @transaction.atomic
    def handle(self, *args, **options):
        self.create_configurations()
        self.create_default_groups()
        self.create_default_item_category()
        self.create_default_item_service()
        self.create_item_process_master()
        self.create_unit_of_measurement()
        self.create_default_item_master()
