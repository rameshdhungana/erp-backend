from django.conf import settings
from django.db import transaction
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

from events.utils import get_event_object_by_uuid, get_event_attendee_object_by_uuid
from items.models import DEFAULT_ITEM_MASTERS_NAME, REFUND_ITEM, BALANCE_USED
from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, REFUND
from orders.utils import (create_ordered_item_object, add_ordered_item_to_order,
                          get_refund_ordered_item_dict, get_balance_ordered_item_dict)
from orders.utils.order_util import (get_basic_order_dict, create_order_object, get_latest_order_of_main_user,
                                     update_balance_of_order,
                                     get_refundable_balance_from_latest_order)


@api_view(['post'])
@transaction.atomic
def redeem_balance(request):
    event = get_event_object_by_uuid(request.data['event_uuid'])
    main_attendee = get_event_attendee_object_by_uuid(request.data['main_attendee_uuid'])
    latest_order = get_latest_order_of_main_user(main_attendee.user, event)
    amount_to_refund = abs(get_refundable_balance_from_latest_order(latest_order))
    #  here we apply the refund payment API of the payment-gateway
    #  create payment object in transaction table , if response  is valid,
    #  we create order balance transfer ordered item ( reduce the actual balance field)
    #  and also create refund ordered item

    # TODO : logic here to call REFUND API and get transaction detail
    transaction_detail = {
        'transaction_reference_id': 'test',
        'amount_to_refund': amount_to_refund, 'payment_method': dict(DEFAULT_ITEM_MASTERS_NAME).get(REFUND_ITEM)
    }

    order_data = get_basic_order_dict(main_attendee.user, main_attendee, event)

    order = create_order_object(order_data)

    refund_ordered_item_data = get_refund_ordered_item_dict(order, main_attendee.user, transaction_detail,

                                                            dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(REFUND),
                                                            main_attendee)
    # now we create ordered_item object for given cart_item
    ordered_item = create_ordered_item_object(refund_ordered_item_data)

    # now we add ordered_item to order object
    order = add_ordered_item_to_order(order, ordered_item)

    # now we create balance-used ordered item and attach it to order

    balance_ordered_item = get_balance_ordered_item_dict(order,
                                                         main_attendee.user,
                                                         dict(DEFAULT_ITEM_MASTERS_NAME).get(BALANCE_USED),
                                                         # since balance is to be subtracted , we need
                                                         #  to apply negation
                                                         amount_to_refund.__neg__(), main_attendee)
    # now we create ordered_item object for given cart_item
    ordered_item = create_ordered_item_object(balance_ordered_item)

    # now we add ordered_item to order object
    order = add_ordered_item_to_order(order, ordered_item)

    # finally we update the balance field of the order, since we need to subtract the balance , to_add_balance has to
    # negative
    update_balance_of_order(order, latest_order, amount_to_refund.__neg__())

    return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                     'message': 'Your balance has been redeem successfully!'}, status=status.HTTP_200_OK)
