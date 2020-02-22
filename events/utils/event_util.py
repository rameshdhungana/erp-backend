import secrets

from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist

from events.models import (Event, EventItem,
                           EventRegistrationType, TransportationPickupLocation)


def generate_choose_accommodation_type_link(event, main_attendee):
    return '{}/events/registration/accommodation-type/{}/{}'.format(getattr(settings, 'FRONTEND_URL'), event.uuid,
                                                                    main_attendee.uuid)


def generate_event_order_login_link(event):
    return '{}/events/order/login/{}'.format(getattr(settings, 'FRONTEND_URL'), event.uuid)


def get_public_event_registration_type_object(event):
    event_registration_type, created = EventRegistrationType.objects.get_or_create(is_public=True, event=event)
    return event_registration_type


# to get event object when uuid is passed to this function
def get_event_object(event_uuid):
    try:
        event = Event.objects.get(uuid=event_uuid)
        return event
    except ObjectDoesNotExist as e:
        raise Exception(e)


# to get eventItem object when uuid is passed to function
def get_event_item_object(event_item_uuid):
    try:
        event_item = EventItem.objects.get(uuid=event_item_uuid)
        return event_item
    except ObjectDoesNotExist as e:
        raise Exception(e)


def get_event_item_object_by_id(event_item_id):
    try:
        event_item = EventItem.objects.get(id=event_item_id)
        return event_item
    except ObjectDoesNotExist as e:
        raise Exception(e)


def generate_confirmation_code():
    return secrets.token_hex(4)[:8]


"""
logic of display items in order-edit section with combination of cart_items and ordered_items

1. find out all the ordered_items uuid list for given attendee in given order
2. find out all the cart_items_list for given attendee in given order
3. create unique set of above two list
4. for each event_item uuid in above set :
        if event_item in cart_list and event_item in ordered_item_list:
            # give priority to cart_item if found on both , since latest update is on cart_list
            main_list.append(item_from_cart_list)
        else:
            # not found on both together , update value from whichever found
            if event_item in cart_list:
                main_list.appen(item_from_cart_list)
            else:
                main_list.append(item_from_ordered_item_list)

finally , 
main_list.filter(transaction_type=SALE)
#only show the items with sale type, but not cancel type to patch value in frontend          

Note: code implementation is below
"""
