# this function add service charge and tax items in cart for both sale and cancel items
from decimal import Decimal
from django.db.models import Q

from carts.models import ItemCart
from items.models import (DEFAULT_ITEM_MASTERS_NAME, APPLICABLE_TAX_ITEM, CANCELED_SERVICE_CHARGE_ITEM,
                          ADDED_SERVICE_CHARGE_ITEM, CANCELED_TAX_ITEM)
from items.utils import get_item_master_object_by_name
from orders.models import (ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE, CANCEL, TAX_OR_SERVICE_CHARGE)


def get_or_create_applicable_tax_cart_item_or_service_charge_cart_item(user,
                                                                       selected_taxable_cart_items,

                                                                       cart_item_type_list,main_user, main_attendee=None,
                                                                       event=None):
    from carts.utils import hard_delete_item_cart
    from events.utils import (get_public_event_registration_type_object)

    service_charge_and_tax_items = []
    total_service_charge = 0.00
    total_applicable_tax = 0.00
    total_canceled_tax = 0.00
    total_canceled_service_charge = 0.00

    added_items = selected_taxable_cart_items.filter(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE))
    canceled_items = selected_taxable_cart_items.filter(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL))
    if added_items:
        for cart_item in added_items:
            total_service_charge = Decimal(total_service_charge) + Decimal(cart_item.item_sc)
            total_applicable_tax = Decimal(total_applicable_tax) + Decimal(cart_item.item_tax)

    if canceled_items:
        for cart_item in canceled_items:
            total_canceled_service_charge = Decimal(total_canceled_service_charge) + Decimal(cart_item.item_sc)
            total_canceled_tax = Decimal(total_canceled_tax) + Decimal(cart_item.item_tax)

    selected_items = []

    if dict(DEFAULT_ITEM_MASTERS_NAME).get(ADDED_SERVICE_CHARGE_ITEM) in cart_item_type_list:
        item_master = get_item_master_object_by_name(dict(DEFAULT_ITEM_MASTERS_NAME).get(ADDED_SERVICE_CHARGE_ITEM))
        if total_service_charge != 0:
            selected_items.append({
                'item_master': item_master,
                'rate': total_service_charge

            })
        else:
            hard_delete_item_cart(Q(item_master=item_master, event=event, ordered_by_user=user))
    if dict(DEFAULT_ITEM_MASTERS_NAME).get(APPLICABLE_TAX_ITEM) in cart_item_type_list:
        item_master = get_item_master_object_by_name(dict(DEFAULT_ITEM_MASTERS_NAME).get(APPLICABLE_TAX_ITEM))
        if total_applicable_tax != 0:
            selected_items.append({
                'item_master': item_master,
                'rate': total_applicable_tax

            })
        else:
            hard_delete_item_cart(Q(item_master=item_master, event=event, ordered_by_user=user))
    if dict(DEFAULT_ITEM_MASTERS_NAME).get(CANCELED_SERVICE_CHARGE_ITEM) in cart_item_type_list:
        item_master = get_item_master_object_by_name(dict(DEFAULT_ITEM_MASTERS_NAME).get(CANCELED_SERVICE_CHARGE_ITEM))
        if total_canceled_service_charge != 0:
            selected_items.append({
                'item_master': item_master,
                'rate': total_canceled_service_charge

            })
        else:
            hard_delete_item_cart(Q(item_master=item_master, event=event, ordered_by_user=user))
    if dict(DEFAULT_ITEM_MASTERS_NAME).get(CANCELED_TAX_ITEM) in cart_item_type_list:
        item_master = get_item_master_object_by_name(dict(DEFAULT_ITEM_MASTERS_NAME).get(CANCELED_TAX_ITEM))
        if total_canceled_tax != 0:
            selected_items.append({
                'item_master': item_master,
                'rate': total_canceled_tax

            })
        else:
            hard_delete_item_cart(Q(item_master=item_master, event=event, ordered_by_user=user))

    main_attendee_cart_data = {
        'user': user,
        'event_attendee': main_attendee,
        'ordered_by_user': main_user,
        'ordered_by_attendee': main_attendee,
        'event': event,
        'event_registration_type': get_public_event_registration_type_object(event),
        'transaction_type': dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(TAX_OR_SERVICE_CHARGE),
        'selected_items': selected_items,

    }
    selected_items = main_attendee_cart_data.pop('selected_items')
    for item in selected_items:
        main_attendee_cart_data.update({'event_item': item.get('event_item', None),
                                        'item_master': item['item_master'],
                                        'rate': item['rate'],
                                        'transportation_info': item.get('transportation_info', None)

                                        })

        #  here we ge update or create to avoid addition of exactly same item for event by an attendee
        event_item_cart, created = ItemCart.objects.update_or_create(
            item_master=main_attendee_cart_data['item_master'], event=event, ordered_by_user=user,
            defaults=main_attendee_cart_data)
        service_charge_and_tax_items.append(event_item_cart)
    # final add them all to get net tax and service charge amount

    net_service_charge_and_tax_amount = Decimal(total_service_charge) + Decimal(total_applicable_tax) + Decimal(
        total_canceled_service_charge) + Decimal(total_canceled_tax)
    return service_charge_and_tax_items, net_service_charge_and_tax_amount
