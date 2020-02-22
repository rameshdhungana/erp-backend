from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, CANCEL


def get_selected_item_dict_from_ordered_item(ordered_item, is_canceled_item=False):
    return {
        'event_item': ordered_item.event_item,
        'item_master': ordered_item.item_master,
        # to indicate that cart items are created using ordered_item's value
        'entry_from_ordered_item': True,
        'rate': ordered_item.rate.__neg__() if is_canceled_item else ordered_item.rate,
        'quantity': ordered_item.quantity,
        'amount': ordered_item.amount,
        'discount': ordered_item.discount.__neg__() if is_canceled_item else ordered_item.discount,
        'amount_net': ordered_item.amount_net,
        'item_sc': ordered_item.item_sc.__neg__() if is_canceled_item else ordered_item.item_sc,
        'amount_taxable': ordered_item.amount_taxable,
        'item_tax': ordered_item.item_tax.__neg__() if is_canceled_item else ordered_item.item_tax,
        'amount_final': ordered_item.amount_final,

    }


def get_cart_item_dict_from_ordered_items_for_cancellation(ordered_item, selected_items,
                                                           main_attendee=None, event=None):
    from events.utils import get_public_event_registration_type_object

    return {'user': ordered_item.user,
            'event_attendee': ordered_item.event_attendee,
            'ordered_by_user': main_attendee.user,
            'ordered_by_attendee': main_attendee,
            'event': ordered_item.event_attendee.event,
            'transaction_type': dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL),
            'event_registration_type': get_public_event_registration_type_object(event),
            # self ordered item is cancelled  , hence canceled_ordered_item is ordered_item
            'canceled_ordered_item': ordered_item,
            'selected_items': selected_items
            }


#  this is dict for another user , including main_user and other guest users registered by him/her
def get_cart_item_dict_for_user(main_user, user, selected_items, transaction_type, main_attendee=None,
                                attendee=None, event=None,
                                canceled_ordered_item=None):
    from events.utils import (get_public_event_registration_type_object)
    return {'user': user,
            'event_attendee': attendee,
            'ordered_by_user': main_user,
            'ordered_by_attendee': main_attendee,
            'event': event,
            'transaction_type': transaction_type,
            'event_registration_type': get_public_event_registration_type_object(event),

            'canceled_ordered_item': canceled_ordered_item,
            'selected_items': selected_items,
            }


def get_basic_cart_dict_from_event_item(event_item, is_canceled_item=False):
    return {'event_item': event_item,
            'item_master': event_item.item_master,
            'rate': event_item.get_current_rate().__neg__() if is_canceled_item else event_item.get_current_rate()
            }


def get_basic_cart_item_dict_for_main_user(main_user, selected_items, transaction_type, main_attendee=None,
                                           event=None,
                                           canceled_ordered_item=None):
    from events.utils import get_public_event_registration_type_object

    return {
        'user': main_user,
        'event_attendee': main_attendee,
        'ordered_by_user': main_user,
        'ordered_by_attendee': main_attendee,
        'event': event,
        'event_registration_type': get_public_event_registration_type_object(event),
        'transaction_type': transaction_type,
        'canceled_ordered_item': canceled_ordered_item,
        'selected_items': selected_items

    }


def get_selected_item_dict_for_cancellation_charge_cart_items(ordered_item):
    return {
        'event_item': ordered_item.event_item,
        'item_master': ordered_item.item_master,
        # to indicate that cart items are created using ordered_item's value
        'entry_from_ordered_item': True,
        'rate': ordered_item.rate.__neg__(),
        'quantity': ordered_item.quantity,
        'amount': ordered_item.amount,
        'discount': ordered_item.discount.__neg__(),
        'amount_net': ordered_item.amount_net,
        'item_sc': ordered_item.item_sc.__neg__(),
        'amount_taxable': ordered_item.amount_taxable,
        'item_tax': ordered_item.item_tax.__neg__(),
        'amount_final': ordered_item.amount_final,

    }
