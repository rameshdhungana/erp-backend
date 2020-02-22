from carts.serializers import ItemCartSerializer
from coupons.utils import (get_all_coupon_items_from_ordered_items, get_all_coupon_items_from_cart_items,
                           get_combined_coupon_items_serialized_data)
from orders.models import RECEIPT, REFUND, ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE
from orders.serializers import OrderOptimizedSerializer, OrderedItemSerializer
from orders.utils import (get_all_active_ordered_items_of_main_user)


def get_active_items_of_order_and_changed_items_of_cart(event, main_attendee, order_queryset):
    #  import done here to avoid circular dependency import error
    from events.utils import get_guest_attendees
    from carts.utils import (perform_operations_on_cart_items_for_cart_summary,
                             get_combined_final_data_from_ordered_items_and_cart_items)

    latest_order = order_queryset.latest()
    ordered_items_base_queryset = get_all_active_ordered_items_of_main_user(order_queryset)
    result = perform_operations_on_cart_items_for_cart_summary(main_attendee.user, latest_order, main_attendee,
                                                               event)
    all_cart_items = result['all_cart_items']

    main_attendee_ordered_items_queryset = ordered_items_base_queryset.filter(user=main_attendee.user)
    main_attendee_order_items = main_attendee_ordered_items_queryset.filter(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE))

    #  now we update confirmation codes for each attendees
    all_guest_attendees = get_guest_attendees(main_attendee, event)
    guest_attendees_order_items = ordered_items_base_queryset.filter(event_attendee__in=all_guest_attendees)

    guest_attendee_items = []
    for guest_attendee in all_guest_attendees:
        guest_attendee_items.append(
            get_combined_final_data_from_ordered_items_and_cart_items(guest_attendees_order_items,
                                                                      all_cart_items,
                                                                      # we pass it as list to make it
                                                                      # iterable
                                                                      [guest_attendee],
                                                                      only_sale_carts=False))

    coupon_ordered_items = get_all_coupon_items_from_ordered_items(ordered_items_base_queryset)
    coupon_cart_items = get_all_coupon_items_from_cart_items(all_cart_items)

    return {
        'order': OrderOptimizedSerializer(latest_order).data,
        'guest_attendees_order_items': guest_attendee_items,
        'main_attendee_order_items': get_combined_final_data_from_ordered_items_and_cart_items(
            main_attendee_order_items,
            all_cart_items,
            # we pass it as list to make it
            # iterable
            [main_attendee],
            only_sale_carts=False),
        'coupon_items': get_combined_coupon_items_serialized_data(coupon_ordered_items,
                                                                  coupon_cart_items),
        'payment_items': OrderedItemSerializer(
            main_attendee_ordered_items_queryset.filter(
                transaction_type=RECEIPT), many=True).data,
        'refund_items': OrderedItemSerializer(
            main_attendee_ordered_items_queryset.filter(transaction_type=REFUND), many=True).data,

        'service_charge_and_tax_items': ItemCartSerializer(
            (data for data in result['service_charge_and_tax_items']),
            many=True).data,
        'cancellation_charge_cart_items': ItemCartSerializer(
            (data for data in result['cancellation_charge_cart_items']),
            many=True).data,

        'amount_net_for_changed_cart_items': result['amount_net_for_changed_cart_items'],
        'net_service_charge_and_tax_amount': result['net_service_charge_and_tax_amount'],
        'total_cancellation_charge_amount': result['total_cancellation_charge_amount'],
        'net_balance_from_latest_order': result['net_balance_from_latest_order'],
        'current_total_credit_amount_used': result['current_total_credit_amount_used'],
        'current_total_discount_coupon_used': result['current_total_discount_coupon_used'],
        'final_amount_to_pay': result['final_amount_to_pay'],
        'balance_credit': result['balance_credit'],
        'refundable_balance': result['refundable_balance'],
    }
