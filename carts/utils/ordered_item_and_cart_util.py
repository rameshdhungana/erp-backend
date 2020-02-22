#  to get the event_item if it exits in given order for given attendee
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q

from carts.utils import (get_selected_item_dict_from_ordered_item,
                         get_cart_item_dict_from_ordered_items_for_cancellation,
                         create_event_item_cart)
from events.models import DEFAULT_EVENT_ITEM_GROUPS, REGISTRATION, ACCOMMODATION, TRANSPORTATION
from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE, CANCEL
from orders.serializers import OrderedItemAndCartItemCombineSerializer, OrderOptimizedSerializer, OrderedItemSerializer
from orders.utils import get_all_active_ordered_items_of_main_user, get_refundable_balance_from_latest_order


def get_event_item_if_already_in_ordered_items_for_given_attendee(order_queryset, attendee, event_item,
                                                                  exclude_param=None):
    ordered_item = get_all_active_ordered_items_of_main_user(order_queryset).filter(
        event_attendee=attendee,
        event_item=event_item,
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE)
    )
    if exclude_param:
        ordered_item = ordered_item.exclude(exclude_param)

    #  returns event_item or None
    return ordered_item.latest() if ordered_item else ordered_item


def get_ordered_item_and_cart_item_common_dict(ordered_or_event_cart_item, is_cart_item=False, is_ordered_item=False):
    return {
        'event_item': ordered_or_event_cart_item.event_item,
        'user': ordered_or_event_cart_item.user,
        'event_attendee': ordered_or_event_cart_item.event_attendee,
        'item_master': ordered_or_event_cart_item.item_master,
        'transaction_type': ordered_or_event_cart_item.transaction_type,
        'transportation_info': ordered_or_event_cart_item.transportation_info,
        'quantity': ordered_or_event_cart_item.quantity,
        'rate': ordered_or_event_cart_item.rate,
        'amount': ordered_or_event_cart_item.amount,
        'discount': ordered_or_event_cart_item.discount,
        'amount_net': ordered_or_event_cart_item.amount_net,
        'is_cart_item': is_cart_item,
        'is_ordered_item': is_ordered_item
    }


def get_combined_final_data_from_ordered_items_and_cart_items(ordered_items, event_cart_items, all_attendees,
                                                              only_sale_carts
                                                              ):
    final_data = []
    # only_sale_carts in True on first_time edit-order-data and False on edited-order-summary page
    # this contains the id of items that have canceled_ordered_item values against the ordered_item
    # and need to be excluded to show active ordered_status inclusive to cart_items
    to_exclude_ordered_item_list = event_cart_items.filter(
        canceled_ordered_item__isnull=False).values_list('canceled_ordered_item__id')
    ordered_items = ordered_items.exclude(id__in=to_exclude_ordered_item_list)

    #  we iterate over all attendees registered for event by main_attendee so that item for each attendee
    #  for given event_item is retrieved
    for attendee in all_attendees:
        ordered_items_id_list = ordered_items.filter(event_attendee=attendee).values_list('event_item__id',
                                                                                          flat=True)
        cart_items__id_list = event_cart_items.filter(event_attendee=attendee).values_list('event_item__id',
                                                                                           flat=True)
        combined_unique_id_list = list(set(list(ordered_items_id_list) + list(cart_items__id_list)))
        for event_item_id in combined_unique_id_list:

            if event_item_id in ordered_items_id_list and event_item_id in cart_items__id_list:
                #  if exits in both we retrieve from cart_item giving it priority
                filter_query = Q(event_item__id=event_item_id,
                                 event_attendee=attendee,
                                 transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                     SALE))
                get_and_append_cart_item_to_final_data(event_cart_items, filter_query, final_data)

                #  if CANCEL type is also to be included, we also check for cancel type and update the final value
                if not only_sale_carts:
                    filter_query = Q(event_item__id=event_item_id,
                                     event_attendee=attendee,
                                     transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                         CANCEL))
                    get_and_append_cart_item_to_final_data(event_cart_items, filter_query, final_data)


            else:
                # not found on both together , update value from whichever found
                if event_item_id in cart_items__id_list:
                    filter_query = Q(event_item__id=event_item_id,
                                     event_attendee=attendee,
                                     transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                         SALE))
                    get_and_append_cart_item_to_final_data(event_cart_items, filter_query, final_data)

                    #  if CANCEL type is also to be include, we also check for cancel type and update the final value
                    if not only_sale_carts:
                        filter_query = Q(event_item__id=event_item_id,
                                         event_attendee=attendee,
                                         transaction_type=dict(
                                             ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                             CANCEL))
                        get_and_append_cart_item_to_final_data(event_cart_items, filter_query, final_data)



                else:
                    try:
                        ordered_item = ordered_items.get(event_item__id=event_item_id,
                                                         event_attendee=attendee, canceled_ordered_item__isnull=True)
                        final_data.append(
                            get_ordered_item_and_cart_item_common_dict(ordered_item, is_ordered_item=True))

                    except ObjectDoesNotExist:
                        pass

    return OrderedItemAndCartItemCombineSerializer((data for data in final_data), many=True).data


def create_canceled_cart_item_from_ordered_item(ordered_item, main_attendee=None, event=None, is_canceled_item=False):
    selected_items = [get_selected_item_dict_from_ordered_item(ordered_item, is_canceled_item=is_canceled_item)]
    attendee_cart_data = get_cart_item_dict_from_ordered_items_for_cancellation(ordered_item, selected_items,
                                                                                main_attendee, event)
    # now create cart item
    create_event_item_cart(attendee_cart_data)


def get_and_append_cart_item_to_final_data(event_cart_items, filter_query, final_data):
    try:
        cart_item = event_cart_items.get(filter_query
                                         )
        final_data.append(get_ordered_item_and_cart_item_common_dict(cart_item, is_cart_item=True
                                                                     ))
    except ObjectDoesNotExist:
        pass
    return final_data


def get_event_ordered_items_and_cart_item_combined_category_wise(main_attendee, event, order_queryset, all_attendees):
    from carts.utils import get_cart_items_queryset_for_each_category
    order_data = OrderOptimizedSerializer(order_queryset.latest()).data

    #  here ordered_item_queryset is all items that belong to these orders queryset, this includes
    #  order_items of all attendees and with not null value in `canceled_ordered_item`
    ordered_items_queryset = get_all_active_ordered_items_of_main_user(order_queryset)
    registration_ordered_items = OrderedItemSerializer(ordered_items_queryset.filter(
        transaction_type=SALE, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION)).order_by(
        'created_at'
    ),
        many=True).data

    accommodation_cart_items = get_cart_items_queryset_for_each_category(main_attendee.user,
                                                                         Q(event_item__group__name=dict(
                                                                             DEFAULT_EVENT_ITEM_GROUPS).get(
                                                                             ACCOMMODATION)), event)

    accommodation_ordered_items = ordered_items_queryset.filter(
        transaction_type=SALE, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION))

    accommodation_items = get_combined_final_data_from_ordered_items_and_cart_items(accommodation_ordered_items,
                                                                                    accommodation_cart_items,
                                                                                    all_attendees,
                                                                                    only_sale_carts=True)

    transportation_cart_items = get_cart_items_queryset_for_each_category(main_attendee.user,
                                                                          Q(event_item__group__name=dict(
                                                                              DEFAULT_EVENT_ITEM_GROUPS).get(
                                                                              TRANSPORTATION)), event)

    transportation_ordered_items = ordered_items_queryset.filter(
        transaction_type=SALE, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION))
    transportation_items = get_combined_final_data_from_ordered_items_and_cart_items(transportation_ordered_items,
                                                                                     transportation_cart_items,
                                                                                     all_attendees,
                                                                                     only_sale_carts=True)

    # coupon_items = OrderedItemSerializer(
    #     ordered_items_queryset.filter(is_coupon_item=True), many=True).data
    # payment_items = OrderedItemSerializer(
    #     ordered_items_queryset.filter(
    #         transaction_type=RECEIPT), many=True).data
    # refund_items = OrderedItemSerializer(
    #     ordered_items_queryset.filter(transaction_type=REFUND), many=True).data

    response_data = {
        'order': order_data,
        'registration_items': registration_ordered_items,
        'accommodation_items': accommodation_items,
        'transportation_items': transportation_items,
        'group_type': main_attendee.group_type,
        'net_balance': get_refundable_balance_from_latest_order(order_queryset.latest())

        # 'coupon_items': coupon_items,
        # 'payment_items': payment_items,
        # 'refund_items': refund_items,
    }

    return response_data
