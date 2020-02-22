from django.core.management import BaseCommand

from events.models import EventType, EventCategory, Organizer, EventItem, Event, REGISTRATION_TYPE_STATUS, \
    EventRegistrationType, DEFAULT_EVENT_ITEM_GROUPS, REGISTRATION, ACCOMMODATION, TRANSPORTATION, EventItemGroup
from items.models import (ItemService, ItemCategory, UnitOfMeasurement, ItemProcessMaster,

                          PROCESS_MASTER_CHOICES,
                          UNIT_CHOICES, UNITS,
                          GENERAL_PROCESS_MASTER, ItemMaster, DEFAULT_ITEM_MASTER_CATEGORIES)

EVENT_TEST_SERVICE = 'Event-Test-Service'
EVENT_TEST_CATEGORY = 'Event-Test-Category'


class Command(BaseCommand):
    help = 'populate the initial db'

    @staticmethod
    def create_test_itemmaster_service():
        data = [
            {'name': EVENT_TEST_SERVICE}

        ]
        for each in data:
            item_category, created = ItemService.objects.get_or_create(name=each['name'])
        print('Test item service are  created')

    @staticmethod
    def create_test_itemmaster_category():
        data = [
            {'name': EVENT_TEST_CATEGORY}
        ]

        for each in data:
            item_service, created = ItemCategory.objects.get_or_create(name=each['name'])

        print('Default event test item categories are  created')

    @staticmethod
    def create_test_event_type():
        data = [
            {'name': 'Test Type',

             'description': 'test description'
             }

        ]
        for each in data:
            type, created = EventType.objects.get_or_create(name=each['name'])
        print('Test event type are  created')

    @staticmethod
    def create_test_event_category():
        data = [
            {'name': 'Amaroo',
             'description': 'Test Event Category'}
        ]
        for each in data:
            category, created = EventCategory.objects.get_or_create(name=each['name'])
        print('Test event category are  created')

    @staticmethod
    def create_test_event_organizer():
        data = [
            {'name': 'Amaroo Test',
             'description': 'test organizer',
             'location': 'Ivory'}
        ]
        for each in data:
            organizer, created = Organizer.objects.get_or_create(name=each['name'])
        print('Test event item organizer are  created')

    @staticmethod
    def create_test_event():
        test_event_data = [
            {
                "title": "Positive Peace WorkShop",
                "description": "",
                "start_date": "2019-05-26T06:00:00Z",
                "end_date": "2012-06-01T06:00:00Z",
                "early_bird_date": "2019-04-26T06:00:00Z",
                "is_single_day_event": False,
                "start_time": "06:00:00",
                "end_time": "18:00:00",
                "venue_location": "Ivory",
                "label": "“Peace is Possible”",
                "summary": "<p>You are invited to a Positive Peace Workshop in Queensland, "
                           "hosted by The Institute of Economics and Peace (IEP) together with Ivory’s "
                           "Rock Foundation (IRF). It will be held on the weekend of 23rd &amp; 24th "
                           "August 2019 (dates to be confirmed) at Ivory’s Rock.</p>",
                "allow_group_registration": True,
                "max_group_limit": 1000,
                "status": "Open",
                "show_total_capacity": True,
                "show_remaining_seats": True,
                "is_published": True,
                "show_start_time": True,
                "show_end_time": True,
                "timezone": "Australia/Lord_Howe",
                "type": EventType.objects.get(name='Test Type'),
                "category": EventCategory.objects.get(name='Amaroo'),
                "organizer": Organizer.objects.get(name='Amaroo Test')

            }
        ]
        for each in test_event_data:
            event, created = Event.objects.get_or_create(**each)
        print('Event is    created')

    @staticmethod
    def create_default_event_item_groups():
        from events.utils import (get_event_object_by_id,
                                  get_public_event_registration_type_object)
        event = get_event_object_by_id(1)
        event_registration_type = get_public_event_registration_type_object(event)
        data = [
            {'name': dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION),
             'event': event,
             'is_multi_select': False,
             'event_registration_type': event_registration_type
             },
            {'name': dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION),
             'event': event,
             'is_multi_select': False,
             'event_registration_type': event_registration_type
             },
            {'name': dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION), 'event': event,
             'is_multi_select': False,
             'event_registration_type': event_registration_type
             },

        ]

        for each in data:
            event_item_group, created = EventItemGroup.objects.update_or_create(name=each['name'], defaults=each)

        print('Default event item groups  are  created')

    @staticmethod
    def create_item_master():
        item_master_data = [

            #  registration items
            {'name': 'Conference Fee (5 days)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '560',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'senior_citizen_discount_per': '10.00',

             },

            #      end of registration items

            #      start of accommodation items
            {'name': 'SC - Pioneer Tent Single (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '1570',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC - Pioneer Tent Twin. For two people (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '1760',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC – Motorhome Space Single. One Person (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '1350',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC – Motorhome Space. Two People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '2450',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC – Motorhome Space. Three People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '3550',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC – Yellow/ Green Bunkhouse Single (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '2400',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC – Yellow/ Green Bunkhouse Twin. Two people (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '3600',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC - Swagman BYO tent single. One person (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '300',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC - Swagman BYO tent. Two People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '600',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC - Swagman BYO tent. Three People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '900',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'Swagman BYO tent. Four People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '1200',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'SC – Orange Cabin single w/ Ensuite (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '3100',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'JAC- Deluxe Tent Single (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '2980',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'JAC - Deluxe Tent Double. Two People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '3300',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'JAC- Deluxe Tent Twin. Two People (7 nights)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '3300',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            #      end of accommodation items

            #      start of transportation
            {'name': 'Line 1: Brisbane Airport– Amaroo – Brisbane Airport (2 trips)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '140',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'Line 2: Brisbane Airport to Amaroo – (one way, Day 8th Sep or Day 9th Sep)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '80',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'Line 3: Amaroo to Brisbane Airport– (one way, Day 15th Sep).',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '80',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'Line 4: Brisbane Sheraton Hotel – Amaroo – Brisbane Sheraton Hotel (10 trips)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '350',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'Line 5: Ipswich Pick up points – Amaroo reception– Ipswich (10 trips)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '290',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            {'name': 'Line 6: Onsite Pavilion - Amphitheatre – Onsite Pavilion. (10 trips)',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '60',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,
             'item_sc_per': '10.00',
             'item_tax_per': '10.00'

             },
            #     end of transportation

            #      start of day pass items
            {'name': 'Day pass -first day )',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '120',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,

             },
            {'name': 'Day pass -second day )',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '120',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,

             },
            {'name': 'Day pass -third day )',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '120',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,

             },
            {'name': 'Day pass -fourth day )',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '120',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,

             },
            {'name': 'Day pass -fifth day )',
             'service': ItemService.objects.get(name=EVENT_TEST_SERVICE),
             'process': ItemProcessMaster.objects.get(name=dict(PROCESS_MASTER_CHOICES).get(GENERAL_PROCESS_MASTER)),

             'uom': UnitOfMeasurement.objects.get(name=dict(UNIT_CHOICES).get(UNITS)),
             'category': ItemCategory.objects.get(
                 name=EVENT_TEST_CATEGORY),
             'item_rate': '120',
             'description': 'Created Item Masters',
             'item_in_stock': 1000,

             },

            #     end of day pass items

        ]

        for data in item_master_data:
            print(data['name'])

            item_master, created = ItemMaster.objects.update_or_create(
                name=data['name'],
                defaults=data)
        print('Default item masters are created')

    @staticmethod
    def create_test_event_items():
        from items.utils import get_item_master_object_by_id
        from events.utils import (get_event_item_group_by_id, get_event_object_by_id,
                                  get_public_event_registration_type_object)
        event = get_event_object_by_id(1)
        event_registration_type = get_public_event_registration_type_object(event)
        event_item_data = [

            #  onsite registration items start
            {'item_master': get_item_master_object_by_id(15),
             'group': get_event_item_group_by_id(1),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'Both',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'senior_citizen_discount_applicable': True
             },
            #  offsite registration items end

            #  accommodation items starts
            {'item_master': get_item_master_object_by_id(16),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(17),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 2,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(18),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(19),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 2,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(20),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 3,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(21),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(22),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 2,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(23),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(24),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 2,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(25),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 3,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(26),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 4,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(27),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(28),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             },
            {'item_master': get_item_master_object_by_id(29),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 2,
             'is_day_pass_item': False,
             },

            {'item_master': get_item_master_object_by_id(30),
             'group': get_event_item_group_by_id(2),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 2,
             'is_day_pass_item': False,
             },
            #  end of acoomodation type items

            #  start of transporation type event items
            {'item_master': get_item_master_object_by_id(31),
             'group': get_event_item_group_by_id(3),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'ask_for_arrival_datetime': True,
             'ask_for_departure_datetime': True,
             'ask_for_pickup_location': False
             },

            {'item_master': get_item_master_object_by_id(32),
             'group': get_event_item_group_by_id(3),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'ask_for_arrival_datetime': True,
             'ask_for_departure_datetime': False,
             'ask_for_pickup_location': True
             },

            {'item_master': get_item_master_object_by_id(33),
             'group': get_event_item_group_by_id(3),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'ask_for_arrival_datetime': True,
             'ask_for_departure_datetime': True,
             'ask_for_pickup_location': True
             },
            {'item_master': get_item_master_object_by_id(34),
             'group': get_event_item_group_by_id(3),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'ask_for_arrival_datetime': False,
             'ask_for_departure_datetime': True,
             'ask_for_pickup_location': True
             },
            {'item_master': get_item_master_object_by_id(35),
             'group': get_event_item_group_by_id(3),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'ask_for_arrival_datetime': True,
             'ask_for_departure_datetime': True,
             'ask_for_pickup_location': True
             },
            {'item_master': get_item_master_object_by_id(36),
             'group': get_event_item_group_by_id(3),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OnSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': False,
             'ask_for_arrival_datetime': True,
             'ask_for_departure_datetime': True,
             'ask_for_pickup_location': True
             },
            #  end of transporation type event items

            # start of offsite resgistation items

            {'item_master': get_item_master_object_by_id(37),
             'group': get_event_item_group_by_id(1),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OffSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': True,
             },
            {'item_master': get_item_master_object_by_id(38),
             'group': get_event_item_group_by_id(1),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OffSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': True,
             },
            {'item_master': get_item_master_object_by_id(39),
             'group': get_event_item_group_by_id(1),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OffSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': True,
             },
            {'item_master': get_item_master_object_by_id(40),
             'group': get_event_item_group_by_id(1),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OffSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': True,
             },
            {'item_master': get_item_master_object_by_id(41),
             'group': get_event_item_group_by_id(1),
             'event': event,
             'event_registration_type': event_registration_type,
             'discount_before_early_bird': '10.00',
             'discount_after_early_bird': '0.00',

             'group_type': 'OffSite',
             'item_capacity': 1000,
             'item_sharing_count': 1,
             'is_day_pass_item': True,
             }

            #     end of offsite registration items
        ]

        for data in event_item_data:
            event_item, created = EventItem.objects.update_or_create(
                item_master=data['item_master'], event=event,
                defaults=data)
        print('test event items  are created')

    def handle(self, *args, **options):
        # item section
        self.create_test_itemmaster_service()
        self.create_test_itemmaster_category()
        self.create_item_master()

        # event section
        self.create_test_event_type()
        self.create_test_event_organizer()
        self.create_test_event_category()
        self.create_test_event()
        self.create_default_event_item_groups()
        self.create_test_event_items()
