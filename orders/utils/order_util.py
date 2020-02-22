import smtplib
from decimal import Decimal
from django.db.models import Q

from coupons.utils import (get_total_discount_applied_using_discount_coupon_from_cart_items,
                           update_amount_used_for_given_coupon_object, get_all_coupon_items_from_ordered_items)
from events.models import ITEM_GROUP_TYPE_CHOICES, OFFSITE, ONSITE
from events.models.event_attendee import (EVENT_REGISTRATION_STATUS, INITIATED, CONFIRMED, CANCELED)
from items.models import DEFAULT_ITEM_MASTERS_NAME, BALANCE_USED, BALANCE_TOPUP
from items.tasks import send_email_to_all_attendees_with_order_summary
from orders.models import (ORDER_STATUS_CHOICES, APPROVED, Order, ORDER_TRANSACTION_TYPE_CHOICES, E_REGISTRATION, SALE,
                           ORDER_ITEM_TRANSACTION_TYPE_CHOICES, RECEIPT, TAX_OR_SERVICE_CHARGE, REFUND, CANCEL, BALANCE)
from orders.serializers import (OrderOptimizedSerializer, OrderedItemSerializer, OrderedItemCouponSerializer)
from orders.utils import (get_payment_ordered_item_dict, create_ordered_item_object, add_ordered_item_to_order,
                          get_ordered_item_dict_from_cart_item, get_all_active_ordered_items_of_main_user,
                          get_balance_ordered_item_dict, get_all_cancelled_ordered_items_of_main_user)

from payments.utils.payment import perform_stripe_payment

from coupons.models.coupon import (SENIOR_CITIZEN_DISCOUNT_COUPON, COUPON_TYPE_CHOICES, CREDIT_COUPON, DISCOUNT_COUPON)

from users.utils import check_if_email_is_dummy


def get_refundable_balance_from_latest_order(latest_order):
    if latest_order:
        net_balance = Decimal(latest_order.balance) - Decimal(latest_order.balance_credit)
        return net_balance
    return 0.00


def get_net_positive_balance_from_latest_order(latest_order):
    if latest_order:
        net_balance = Decimal(latest_order.balance) - Decimal(latest_order.balance_credit)
        #  we return the net balance value to be used in multiple cases as available balance of user from previous order
        #  only if net balance is greater than 0
        #  net balance being  negative means he/she has used credit amount and has further more amount to pay
        #  rather than using balance
        if net_balance > 0:
            return net_balance
        return 0.00
    return 0.00


def get_absolute_balance_credit_from_latest_order(latest_order):
    if latest_order:
        balance_credit = Decimal(latest_order.balance_credit)

        if balance_credit > 0:
            return balance_credit
        return 0.00
    return 0.00


def get_balance_credit_from_latest_order(latest_order):
    if latest_order:
        return Decimal(latest_order.balance) - Decimal(latest_order.balance_credit)
    return 0.00


def get_net_positive_balance_credit_from_latest_order(latest_order):
    if latest_order:
        net_credit_balance = Decimal(latest_order.balance_credit) - Decimal(latest_order.balance)
        if net_credit_balance > 0:
            return net_credit_balance
        return 0.00
    return 0.00


# def determine_and_calculate_refundable_or_payment_balance(latest_order):
#     if latest_order:
#         net_balance = Decimal(latest_order.balance) - Decimal(latest_order.balance_credit)
#         if net_balance > 0:
#             # this means he/she has more balance than credit amount used, hence we need to refund him/her back the net amount
#             return {'net_balance': net_balance,
#                     'type': 'refundable_balance'}
#         else:
#             return {'net_balance': net_balance, 'type': 'payments'}
#     return 0.00


# this returns the order object if given main_attendee for given event, here we need to get the latest order object too
def get_latest_order_of_main_user(user, event=None):
    if event:
        filter_param = Q(order_status=dict(ORDER_STATUS_CHOICES).get(APPROVED), user=user,
                         event=event)
        order_queryset = Order.objects.filter(filter_param)

    else:
        filter_param = Q(order_status=dict(ORDER_STATUS_CHOICES).get(APPROVED), user=user)
        order_queryset = Order.objects.filter(filter_param)
    return order_queryset.latest() if order_queryset else None


# this returns the order object if given main_attendee for given event, here we need to get the latest order object too
def get_all_orders_of_main_user(user, event=None):
    if event:
        filter_param = Q(order_status=dict(ORDER_STATUS_CHOICES).get(APPROVED), user=user,
                         event=event)
    else:
        filter_param = Q(order_status=dict(ORDER_STATUS_CHOICES).get(APPROVED), user=user)
    return Order.objects.filter(filter_param)


# to update the previous_order field of current created order (passed order object)
def update_previous_order_field_for_current_order(order, user, event=None):
    order_queryset = get_all_orders_of_main_user(user, event)
    if len(order_queryset) > 1:
        second_latest_order = order_queryset.order_by('-created_at')[1]
        order.previous_order = second_latest_order
        order.save()


# to update the balance field of order
def update_balance_of_order(order, latest_order, to_add_balance):
    previous_balance = latest_order.balance if latest_order else 0
    order.balance = Decimal(to_add_balance) + Decimal(previous_balance)
    order.save()


# to update the balance_credit of order
def update_balance_credit_of_order(order, latest_order, to_add_balance_credit):
    previous_balance_credit = latest_order.balance_credit if latest_order else 0
    order.balance_credit = Decimal(to_add_balance_credit) + Decimal(previous_balance_credit)
    order.save()


# this function creates an order object with order data provided
def create_order_object(order_data):
    order = Order.objects.create(**order_data)
    return order


# returns basic order related dict
def get_basic_order_dict(user, main_attendee=None, event=None):
    return {
        'user': user,
        'event_attendee': main_attendee,

        'transaction_type': dict(ORDER_TRANSACTION_TYPE_CHOICES).get(E_REGISTRATION),
        'event': event,
        'order_status': dict(ORDER_STATUS_CHOICES).get(APPROVED)

    }


def create_ordered_item_and_add_to_order(order, cart_item, coupon_amount_used=None):
    #  import is done here to avoid circular dependency error
    from events.utils import (decrease_event_item_item_capacity_count, update_registration_status_of_attendee,
                              )
    ordered_item_data = get_ordered_item_dict_from_cart_item(order, cart_item, coupon_amount_used)
    # now we create ordered_item object for given cart_item
    ordered_item = create_ordered_item_object(ordered_item_data)

    #  once order item for given event_item  whose transaction type is SALE is
    #  created we need to decrease its item_capacity by 1
    if ordered_item.transaction_type == SALE:
        decrease_event_item_item_capacity_count(cart_item.event_item)

    #  now we add ordered_item to order object and calculate amount_in_final of order object
    order = add_ordered_item_to_order(order, ordered_item)


# function to create order and ordered_items from cart items when user and related information is provided
def perform_order_and_ordered_item_operation(all_cart_items, total_credit_amount_used, user, main_attendee=None,
                                             event=None,
                                             **transaction_detail):
    #  import is done here to avoid circular dependency error
    from events.utils import (update_registration_status_of_attendee,
                              get_guest_attendees)
    from events.utils import get_all_attendees

    order_data = get_basic_order_dict(user, main_attendee, event)

    order = create_order_object(order_data)

    # reference itself to parent_order field

    #  if transaction_detail is not empty we need to create payments received as ordered_item
    #  and associate with order object. transaction_type for ordered_item for e-payments would
    #  RECEIPT and item_master associated to it would be amount initially populated item_master with
    #  name CREDIT_CARD_PAYMENT_ITEM or BANK_PAYMENT_ITEM depending upon the payments method
    if transaction_detail:
        receipt_ordered_item_data = get_payment_ordered_item_dict(order, user, transaction_detail,
                                                                  dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                                                      RECEIPT),
                                                                  main_attendee)
        # now we create ordered_item object for given cart_item
        ordered_item = create_ordered_item_object(receipt_ordered_item_data)

        #  now we add ordered_item to order object
        order = add_ordered_item_to_order(order, ordered_item)
    # now we create ordered_item from all the cart items of the main_attendee
    #  we find out the total_discount that is applied in given cart items with SALE type
    total_discount_amount_used = get_total_discount_applied_using_discount_coupon_from_cart_items(all_cart_items)
    for cart_item in all_cart_items:

        #  we update the coupon object to assign its order to above created order object
        if cart_item.is_coupon_item:
            coupon = cart_item.coupon
            # following section is for credit coupon and updating amount_used field of credit coupon used in carts
            if coupon.type == dict(COUPON_TYPE_CHOICES).get(CREDIT_COUPON):
                if total_credit_amount_used > 0:
                    #  this means still total_credit_amount_used is available hence coupon object needs to be updated
                    # now find out the available credit amount in coupon (amount_limit-amount_used)
                    total_credit_amount_used, current_credit_used = update_amount_used_for_given_coupon_object(
                        coupon, total_credit_amount_used)
                    # now we create order and ordered_item for this senior citizenship cart items
                    create_ordered_item_and_add_to_order(order, cart_item, current_credit_used.__neg__())

            # following section is for discount coupon and updating amount_used field of discount coupon used in carts
            if coupon.type == dict(COUPON_TYPE_CHOICES).get(DISCOUNT_COUPON):
                if total_discount_amount_used > 0:
                    # this means still total_discount_amount_used is available hence coupon object needs to be updated
                    # now find out the available credit amount in coupon (amount_limit-amount_used)
                    total_discount_amount_used, current_discount_used = update_amount_used_for_given_coupon_object(
                        coupon,
                        total_discount_amount_used)
                    # now we create order and ordered_item for this senior citizenship cart items
                    create_ordered_item_and_add_to_order(order, cart_item, current_discount_used.__neg__())
            # coupon type is of senior citizen discount , we need to update the amount used to its amount_limit value
            if coupon.type == dict(COUPON_TYPE_CHOICES).get(SENIOR_CITIZEN_DISCOUNT_COUPON):
                # coupon amount_used is increased only after the coupon is added to cart
                coupon.amount_used = coupon.amount_limit
                coupon.save()
                # now we create order and ordered_item for this senior citizenship cart items
                create_ordered_item_and_add_to_order(order, cart_item)

        else:
            # since ordered items for coupon items are already created above , we need to create only for other than
            # coupon item from carts
            create_ordered_item_and_add_to_order(order, cart_item)

            #  here we need to update the items_booked value of event_item booked
            if cart_item.event_item:
                cart_item.event_item.items_booked = cart_item.event_item.items_booked + 1
                cart_item.event_item.save()

        #  we need to update the event_attendee's registration_status from 'Initiated' to 'Confirmed'
        # after his/her order has been created
        if cart_item.event_attendee.registration_status == dict(EVENT_REGISTRATION_STATUS).get(INITIATED):
            update_registration_status_of_attendee(cart_item.event_attendee,
                                                   dict(EVENT_REGISTRATION_STATUS).get(CONFIRMED))

        # now we need to delete the cart items from eventCartItem after its order_item has been generated
        cart_item.hard_delete()
        # above line hard deletes  cart item from database

    # now we update the balance for order by finding all active ordered_items of all orders, and
    # calculate  balance

    #  we first update the previous_order field of order object, if there is more than one order_queryset (edits done
    #  we need to get second last orders and update its value to latest order
    update_previous_order_field_for_current_order(order, user, event=None)

    # if the order was changed from Onsite Registration Type to Offsite Registration Type, changed_to_offsite
    # field of main_attendee becomes True , on that case
    # now we need to convert each attendee registered_by main_attendee to 'CANCELED' registration status
    if main_attendee.changed_to_offsite:
        #  we update main_attendee's group_type to offsite type as well
        main_attendee.group_type = dict(ITEM_GROUP_TYPE_CHOICES).get(OFFSITE)
        main_attendee.changed_to_offsite = False
        main_attendee.save()

        for each_guest in get_guest_attendees(main_attendee, event):
            #  we also clear the confirmation code for each attendee
            update_registration_status_of_attendee(each_guest, dict(EVENT_REGISTRATION_STATUS).get(CANCELED))

    #  main_attendee has changed group_type to onsite from offiste we need to update the group type for
    # main_attendee and revert back the changed_to_onsite boolean
    if main_attendee.changed_to_onsite:
        #  we update main_attendee's group_type to offsite type as well
        main_attendee.group_type = dict(ITEM_GROUP_TYPE_CHOICES).get(ONSITE)
        main_attendee.changed_to_onsite = False
        main_attendee.save()

        for each_guest in get_guest_attendees(main_attendee, event):
            #  we also clear the confirmation code for each attendee
            update_registration_status_of_attendee(each_guest, dict(EVENT_REGISTRATION_STATUS).get(CANCELED))

    if main_attendee.registration_is_cancelled:
        main_attendee.registration_is_cancelled = False
        main_attendee.save()

        # if registration is cancelled  then we need to make all
        for attendee in get_all_attendees(main_attendee, event):
            #  we also clear the confirmation code for each attendee
            update_registration_status_of_attendee(attendee, dict(EVENT_REGISTRATION_STATUS).get(CANCELED))

    return order


def get_active_items_of_order(order_queryset, main_user, main_attendee=None, event=None):
    #  import is done here to avoid circular dependency error
    from events.utils import (
        get_guest_attendee_order_items, get_all_attendees)

    ordered_items_queryset = get_all_active_ordered_items_of_main_user(order_queryset)

    #  now we update confirmation codes for each attendees
    all_attendees = get_all_attendees(main_attendee, event)

    latest_order = get_latest_order_of_main_user(main_user, event)
    #  refundable_balance value obtained above may be positive or negative , if it is positive , it means
    #  balance is greater than balance_credit so we need to refund him/her back
    # but if the value is negative , more amount has to be paid since credit coupon amount is larger than balance

    return {
        'order': OrderOptimizedSerializer(order_queryset.latest()).data,
        'guest_attendees_order_items': get_guest_attendee_order_items(ordered_items_queryset, order_queryset,
                                                                      # the following excludes main_attendee from all
                                                                      #   attendees to get guest attendees
                                                                      all_attendees.exclude(uuid=main_attendee.uuid),
                                                                      dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                                                          SALE)),
        'main_attendee_order_items': OrderedItemSerializer(
            ordered_items_queryset.filter(user=main_user).filter(transaction_type=SALE).order_by('id'), many=True).data,
        'coupon_items': OrderedItemCouponSerializer(
            get_all_coupon_items_from_ordered_items(ordered_items_queryset), many=True).data,
        'payment_items': OrderedItemSerializer(
            ordered_items_queryset.filter(
                transaction_type=RECEIPT).order_by('id'), many=True).data,
        'service_charge_and_tax_items': OrderedItemSerializer(
            ordered_items_queryset.filter(
                transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(TAX_OR_SERVICE_CHARGE)).order_by('id'),
            many=True).data,
        'refund_items': OrderedItemSerializer(
            ordered_items_queryset.filter(transaction_type=REFUND).order_by('id'), many=True).data,
        'net_balance': get_refundable_balance_from_latest_order(latest_order),
    }


def get_cancelled_items_of_order(order_queryset, main_user, main_attendee=None, event=None):
    #  import is done here to avoid circular dependency error
    from events.utils import (
        get_guest_attendee_order_items, get_all_cancelled_attendees)

    ordered_items_queryset = get_all_cancelled_ordered_items_of_main_user(order_queryset)

    all_attendees = get_all_cancelled_attendees(main_attendee, event)

    latest_order = get_latest_order_of_main_user(main_user, event)
    #  refundable_balance value obtained above may be positive or negative , if it is positive , it means
    #  balance is greater than balance_credit so we need to refund him/her back
    # but if the value is negative , more amount has to be paid since credit coupon amount is larger than balance

    return {
        'order': OrderOptimizedSerializer(order_queryset.latest()).data,
        'guest_attendees_order_items': get_guest_attendee_order_items(ordered_items_queryset, order_queryset,
                                                                      # the following excludes main_attendee from all
                                                                      #   attendees to get guest attendees
                                                                      all_attendees.exclude(uuid=main_attendee.uuid),
                                                                      dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                                                          CANCEL)),
        'main_attendee_order_items': OrderedItemSerializer(
            ordered_items_queryset.filter(user=main_user).filter(transaction_type=CANCEL).order_by('id'),
            many=True).data,
        'coupon_items': OrderedItemCouponSerializer(
            get_all_coupon_items_from_ordered_items(ordered_items_queryset), many=True).data,
        'payment_items': OrderedItemSerializer(
            ordered_items_queryset.filter(
                transaction_type=RECEIPT).order_by('id'), many=True).data,
        'service_charge_and_tax_items': OrderedItemSerializer(
            ordered_items_queryset.filter(
                transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(TAX_OR_SERVICE_CHARGE)), many=True).data,
        'refund_items': OrderedItemSerializer(
            ordered_items_queryset.filter(transaction_type=REFUND).order_by('id'), many=True).data,
        'net_balance': get_refundable_balance_from_latest_order(latest_order),
    }


# this is common function that performs the order confirmation for first time order or order edit ( both for
# for payments and without payments as well)
def perform_order_confirmation(request, all_cart_items, user, main_attendee=None, event=None):
    from carts.utils import calculate_final_amount_to_be_paid_from_cart_items

    latest_order = get_latest_order_of_main_user(user, event)

    [final_amount_to_be_paid, to_add_balance,
     credit_amount_used, to_subtract_balance_credit] = calculate_final_amount_to_be_paid_from_cart_items(
        all_cart_items, latest_order)

    #  now we get final_amount_to_be_paid
    # if difference is positive , still more amount has to be paid from payments data
    # if difference is negative , balance was more than net_amount hence we subtract amount_net from
    # balance and update the previous order balance to absolute value of difference

    # if difference is negative or zero, balance was more  or equal to than net_amount hence we subtract
    # amount_net from
    if final_amount_to_be_paid <= 0:
        order = perform_order_and_ordered_item_operation(all_cart_items, credit_amount_used, user, main_attendee,
                                                         event)
    else:
        token = request.data['id']
        transaction_detail = perform_stripe_payment(token, final_amount_to_be_paid)
        # TODO : logic to separate out which payments is used, then use that payments gateway ,
        #  create order only if the success response from payments is obtained

        order = perform_order_and_ordered_item_operation(all_cart_items, credit_amount_used, main_attendee.user,
                                                         main_attendee,
                                                         event, **transaction_detail)

    #  now we need to update the balance and balance_credit field of order if both are other than 0
    if to_add_balance != 0:
        # first we update the balance
        update_balance_of_order(order, latest_order, to_add_balance)
        # we then create an ordered_item of type BALANCE to indicate that internal balance has
        # been used
        # we need to decide whether balance was used or balance is remaining and needs to be transfered to
        # order , thus we decide this using value of to_add_balance, if it is negative , it means balance was
        # used , but if positive balance is remaining and needs to be topup(self transfer to order)
        item_master_name = dict(DEFAULT_ITEM_MASTERS_NAME).get(
            BALANCE_USED) if to_add_balance < 0 else dict(DEFAULT_ITEM_MASTERS_NAME).get(
            BALANCE_TOPUP)
        balance_ordered_item_data = get_balance_ordered_item_dict(order,
                                                                  main_attendee.user,
                                                                  item_master_name,
                                                                  # since balance is used , we need to pass negation
                                                                  to_add_balance.__neg__(),

                                                                  main_attendee)
        # now we create ordered_item object for given ordered_item_data
        ordered_item = create_ordered_item_object(balance_ordered_item_data)

        #  now we add ordered_item to order object
        order = add_ordered_item_to_order(order, ordered_item)

    if credit_amount_used != 0:
        update_balance_credit_of_order(order, latest_order, credit_amount_used)

    if to_subtract_balance_credit != 0:
        update_balance_credit_of_order(order, latest_order, to_subtract_balance_credit)
