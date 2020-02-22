from decimal import Decimal

from events.models.event_attendee import EVENT_REGISTRATION_STATUS, CANCELED
from items.utils import get_item_master_object_by_name
from orders.models import (OrderedItem, ORDER_ITEM_TRANSACTION_TYPE_CHOICES, RECEIPT, BALANCE, SALE, CANCEL)


def get_all_active_ordered_items_of_user(order_queryset, user):
    return OrderedItem.objects.filter(order__in=order_queryset,
                                      transaction_type=dict(
                                          ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                          SALE), user=user)


def get_all_active_ordered_items_of_main_user(order_queryset):
    base_ordered_items = OrderedItem.objects.filter(order__in=order_queryset).exclude(
        event_attendee__registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED))
    to_exclude_ordered_items_id_list = base_ordered_items.filter(canceled_ordered_item__isnull=False).values_list(
        'canceled_ordered_item__id')
    return base_ordered_items.filter(canceled_ordered_item__isnull=True).exclude(
        id__in=to_exclude_ordered_items_id_list)


def get_all_cancelled_ordered_items_of_main_user(order_queryset):
    return OrderedItem.objects.filter(order__in=order_queryset).filter(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL))


# this function creates an order item object with provided data
def create_ordered_item_object(ordered_item_data):
    ordered_item = OrderedItem.objects.create(**ordered_item_data)
    return ordered_item


# to add ordered_item to order
def add_ordered_item_to_order(order, ordered_item):
    # now we add ordered_item object  to its order
    order.order_items.add(ordered_item)

    order.save()
    return order


# returns amount related values in form of dict required for internal purpose ordered items such as
#  payments ordered_item , balance_ordered_item

def get_amount_related_dict_for_internal_purpose_ordered_item(rate, quantity):
    discount = Decimal(0.00)
    amount = Decimal(rate) * Decimal(quantity)
    amount_net = Decimal(amount) - Decimal(discount)

    item_sc = Decimal(0.00)
    amount_taxable = Decimal(amount_net + item_sc)
    item_tax = Decimal(0.00)

    amount_final = Decimal(item_tax) + Decimal(amount_taxable)
    return {
        'discount': Decimal(0.00),
        'amount': rate * 1,
        'amount_net': amount_net,
        'item_sc': item_sc,
        'amount_taxable': amount_taxable,
        'item_tax': item_tax,
        'amount_final': amount_final,
    }


def get_refund_ordered_item_dict(order, user, transaction_detail, transaction_type, main_attendee=None):
    basic_dict = {
        'order_number': order.order_number,
        'order_cfy': order.order_cfy,
        'user': user,
        'event_attendee': main_attendee,
        'item_master': get_item_master_object_by_name(transaction_detail['payment_method']),
        'transaction_type': transaction_type,
        'transaction_reference_id': transaction_detail['transaction_reference_id'],
        'quantity': 1,
        # quantity is made negative so that receipt amount is subtracted while making addition operation
        # and balance of order becomes 0.00
        'rate': transaction_detail['amount_to_refund'],

    }
    basic_dict.update(get_amount_related_dict_for_internal_purpose_ordered_item(
        transaction_detail['amount_to_refund'], 1))
    return basic_dict


# returns all fields in dictionary required for creating payments related ordered_item

def get_payment_ordered_item_dict(order, user, transaction_detail, transaction_type, main_attendee=None):
    basic_dict = {
        'order_number': order.order_number,
        'order_cfy': order.order_cfy,
        'user': user,
        'event_attendee': main_attendee,
        'item_master': get_item_master_object_by_name(transaction_detail['payment_method']),
        'transaction_type': transaction_type,
        'transaction_reference_id': transaction_detail['transaction_reference_id'],
        'quantity': 1,
        # quantity is made negative so that receipt amount is subtracted while making addition operation
        # and balance of order becomes 0.00
        'rate': transaction_detail['final_amount_to_be_paid'].__neg__(),

    }
    basic_dict.update(get_amount_related_dict_for_internal_purpose_ordered_item(
        transaction_detail['final_amount_to_be_paid'].__neg__(), 1))
    return basic_dict


# returns all basic ordered_item fields dict for balance_type ( topup and balance-transfer)
def get_balance_ordered_item_dict(order, user, item_master_name, balance, main_attendee=None):
    basic_dict = {
        'order_number': order.order_number,
        'order_cfy': order.order_cfy,
        'user': user,
        'event_attendee': main_attendee,
        'item_master': get_item_master_object_by_name(item_master_name),
        'transaction_type': dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(BALANCE),
        'quantity': 1,
        # rate is made negative since it is equivalent to receiving amount
        'rate': balance
    }

    basic_dict.update(get_amount_related_dict_for_internal_purpose_ordered_item(
        balance, 1))
    return basic_dict


# returns all the required fields (dict) for ordered_item from given cart item
def get_ordered_item_dict_from_cart_item(order, cart_item, coupon_amount_used=None):
    return {
        'order_number': order.order_number,
        'order_cfy': order.order_cfy,
        'user': cart_item.user,
        'event_registration_type': cart_item.event_registration_type,
        'event': cart_item.event,
        'event_attendee': cart_item.event_attendee,
        'item_master': cart_item.item_master,
        'event_item': cart_item.event_item,
        'canceled_ordered_item': cart_item.canceled_ordered_item,
        'transaction_type': cart_item.transaction_type,
        'transaction_reference_id': '',
        'quantity': cart_item.quantity,
        'rate': coupon_amount_used if coupon_amount_used else cart_item.rate,
        'discount': cart_item.discount,
        'amount': coupon_amount_used if coupon_amount_used else cart_item.amount,
        'amount_net': coupon_amount_used if coupon_amount_used else cart_item.amount_net,
        'item_sc': cart_item.item_sc,
        'amount_taxable': coupon_amount_used if coupon_amount_used else cart_item.amount_taxable,
        'item_tax': cart_item.item_tax,
        'amount_final': coupon_amount_used if coupon_amount_used else cart_item.amount_final,
        'is_coupon_item': cart_item.is_coupon_item,
        'coupon': cart_item.coupon,
        'transportation_info': cart_item.transportation_info

    }


def check_if_ordered_items_contains_item_with_given_query_param(query_param):
    return OrderedItem.objects.filter(query_param)
