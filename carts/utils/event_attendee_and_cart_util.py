from events.utils import get_event_item_object, get_public_event_registration_type_object
from items.utils import get_item_master_object
from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE


def get_event_item_related_data(item_data_list):
    response_data = []
    for item in item_data_list:
        event_item = get_event_item_object(item['uuid'])
        data = {'event_item': event_item,
                'item_master': get_item_master_object(item['item_master']['uuid']),
                'rate': event_item.get_current_rate()
                }
        response_data.append(data)
    return response_data


def get_attendee_cart_related_dict(request, user, attendee, main_attendee, event):
    selected_items = get_event_item_related_data(request.data['selected_registration_items'])

    attendee_cart_data = {
        'user': user,
        'event_attendee': attendee,
        'ordered_by_user': main_attendee.user,
        'ordered_by_attendee': main_attendee,
        'event': event,
        'event_registration_type': get_public_event_registration_type_object(event),
        'transaction_type': dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE),
        'selected_items': selected_items,

    }

    return attendee_cart_data
