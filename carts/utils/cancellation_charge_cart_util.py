from decimal import Decimal

from carts.utils import (get_basic_cart_item_dict_for_main_user,
                         create_event_item_cart)
from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, CANCELLATION_CHARGE, CancellationPolicy


# this function is used before the discount is applied to get amount total of given items
def calculate_total_amount_net_for_cancellation_charge_cart_items(cancellation_charge_cart_items):
    total_amount = 0.00
    for cart_item in cancellation_charge_cart_items:
        # cart_item.amount
        #  we add the amount only if the apply_cancellation_policy is to be applied for cart items
        if cart_item.apply_cancellation_policy:
            total_amount = Decimal(total_amount) + Decimal(cart_item.amount_net)
    return total_amount


def get_all_cancellation_charge_cart_items_of_main_user(main_user, event):
    from carts.utils import get_all_cart_items_of_main_user

    return get_all_cart_items_of_main_user(main_user, event).filter(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCELLATION_CHARGE))


def get_cancellation_charge_percentage(cart_item):
    if cart_item.event_item:
        cancellation_policy = CancellationPolicy.objects.filter(
            event_item=cart_item.event_item,
            period_from__lte=cart_item.created_at,
            period_to__gte=cart_item.created_at).order_by(
            '-created_at').first()
    else:
        cancellation_policy = CancellationPolicy.objects.filter(
            item_master=cart_item.item_master,
            period_from__lte=cart_item.created_at,
            period_to__gte=cart_item.created_at).order_by(
            '-created_at').first()
    return cancellation_policy.cancellation_per if cancellation_policy else 0.00


def create_cancellation_charge_cart_items(cancelled_cart_items, main_user, main_attendee=None, event=None):
    # first we delete all the cancellation cart items from the database , and
    # for each cancelled cart items , we need to create a cancellation charge cart items with transaction type as
    # CANCELLATION_CHARGE

    # delete all cancellation charge cart items
    get_all_cancellation_charge_cart_items_of_main_user(main_user, event).hard_delete()

    for cart_item in cancelled_cart_items:
        # add to cart
        #  since, the rate of the cart item for cancelled type is already in negative but we need
        # rate of cancellation charge cart items as positive , need to negate the value and
        #  calculate its rate with cancellation  percentage

        rate = Decimal(cart_item.amount_final.__neg__()) * Decimal(
            get_cancellation_charge_percentage(cart_item)) / Decimal(100.00)
        #  we create cancellation charge items in carts if the rate here is greater than 0 , otherwise there is no
        # meaning creating them
        if rate > 0:
            selected_items = [{
                'item_master': cart_item.item_master,
                # amount_final is used here not amount_net for cancellation charge rate calculation
                'rate': Decimal(rate),
                'quantity': 1,

            }]
            main_attendee_cart_data = get_basic_cart_item_dict_for_main_user(main_user, selected_items,
                                                                             dict(
                                                                                 ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                                                                 CANCELLATION_CHARGE), main_attendee,
                                                                             event)
            main_attendee_cart_data.update({'selected_items': selected_items,
                                            #  here we make set apply_cancellation_policy as True
                                            'apply_cancellation_policy': True,

                                            })
            # now call function to create cart objects
            added_to_cart = create_event_item_cart(main_attendee_cart_data)
