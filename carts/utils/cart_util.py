from decimal import Decimal

from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q

from carts.models import ItemCart
from carts.utils import (get_event_item_if_already_in_cart_items_for_given_attendee,
                         create_event_item_cart, get_or_create_applicable_tax_cart_item_or_service_charge_cart_item,
                         get_event_item_if_already_in_ordered_items_for_given_attendee, get_cart_item_dict_for_user,
                         get_selected_item_dict_from_ordered_item, create_cancellation_charge_cart_items,
                         get_basic_cart_dict_from_event_item, get_all_cancellation_charge_cart_items_of_main_user,
                         calculate_total_amount_net_for_cancellation_charge_cart_items)
from coupons.utils import (get_credit_coupon_items_from_cart_items,
                           calculate_absolute_total_amount_from_coupon_cart_items, update_discount_of_cart_items,
                           get_discount_coupon_items_from_cart_items,
                           apply_credit_coupon_and_calculate_total_credit_amount_used,
                           )
from events.models import (DEFAULT_EVENT_ITEM_GROUPS, TRANSPORTATION, REGISTRATION, ACCOMMODATION,
                           ITEM_GROUP_TYPE_CHOICES, BOTH)
from events.models.event_attendee import EVENT_REGISTRATION_STATUS, CANCELED
from events.utils import get_transportation_pickup_location_by_uuid

from items.models import (DEFAULT_ITEM_MASTERS_NAME, ADDED_SERVICE_CHARGE_ITEM, CANCELED_SERVICE_CHARGE_ITEM,
                          APPLICABLE_TAX_ITEM, CANCELED_TAX_ITEM)
from orders.models import (ORDER_ITEM_TRANSACTION_TYPE_CHOICES, CANCEL, SALE, TAX_OR_SERVICE_CHARGE,
                           CANCELLATION_CHARGE)
from orders.utils import (apply_senior_citizen_discount_to_cart_items,
                          get_net_positive_balance_from_latest_order,
                          get_balance_credit_from_latest_order,
                          get_all_orders_of_main_user, get_absolute_balance_credit_from_latest_order)


def update_discount_of_cart_items_to_zero_value(all_cart_items):
    for item in all_cart_items:
        item.discount = 0.00
        item.save()
    return all_cart_items


def calculate_final_amount_to_be_paid_from_cart_items(all_cart_items, latest_order):
    cart_and_tax_total_amount = calculate_net_amount_with_changed_carts_service_charge_tax_and_cancellation_charge_cart_items(
        all_cart_items)
    credit_coupon_items = get_credit_coupon_items_from_cart_items(all_cart_items)
    credit_coupon_amount_limit = calculate_absolute_total_amount_from_coupon_cart_items(credit_coupon_items)

    balance_from_latest_order = get_net_positive_balance_from_latest_order(latest_order)
    to_subtract_balance_credit = 0.00

    #  we need to find out the whether he/she has to pay extra amount or has refundable amount after order process(edit)
    if cart_and_tax_total_amount > 0:
        # cart_and_tax_total is to be paid either through credit coupon or  or previous balance or payments in sequence

        # first find out if credit amount would be enough to pay

        net_amount = Decimal(cart_and_tax_total_amount) - Decimal(credit_coupon_amount_limit)
        #  now we check if net_amount is greater than zero or other one
        if net_amount <= 0:
            # credit amount was enough to pay thus , we do not need to go through balance or payments
            to_add_balance = Decimal(0.00)
            credit_amount_used = abs(cart_and_tax_total_amount)
            final_amount_to_be_paid = Decimal(0.00)
        else:
            # this means credit amount limit is lesser than amount to be paid(cart and tax , service charge)
            #  hence has to pay through previous balance or payments
            amount_net_after_latest_balance_applied = Decimal(net_amount) - Decimal(balance_from_latest_order)
            # after latest order balance is subtracted , we need to check if payments is enough or
            # further card payments is required
            if amount_net_after_latest_balance_applied <= 0:
                #     this means further payments is not required , balance payments was enough
                # since balance was used here for payments , we need to provide negative value of balance
                # so that it gets decreased while performing addition
                to_add_balance = Decimal(
                    Decimal(balance_from_latest_order) + Decimal(amount_net_after_latest_balance_applied)).__neg__()
                credit_amount_used = credit_coupon_amount_limit
                final_amount_to_be_paid = Decimal(0.00)
            else:
                # has to pay more amount through payments since previous balance was also not enough to pay
                # the net_amount(cart + tax + service - credit ) , hence we need to calculate definite final
                # amount of money
                to_add_balance = Decimal(balance_from_latest_order).__neg__()
                credit_amount_used = credit_coupon_amount_limit
                final_amount_to_be_paid = Decimal(amount_net_after_latest_balance_applied)
    else:
        # since cart_and_tax_total is itself zero or negative , extra amount is not to be paid instead
        #  his/her previous balance and credit balance has to be updated
        #  to_add_balance is absolute value of cart_and_tax_total_amount minus the balance_credit from previous order
        balance_credit_from_latest_order = get_absolute_balance_credit_from_latest_order(latest_order)

        #  we first check if the absoulte value of cart_and_tax_total_amount (obtained due to cancellation) is less than
        #  or equal to balance_credit_from_latest_order

        diff_amount = abs(Decimal(cart_and_tax_total_amount)) - Decimal(balance_credit_from_latest_order)
        if diff_amount > 0:
            to_add_balance = Decimal(diff_amount)
            #  negation is done to subtract the used balance_credit from previous balance_credit for
            #  this order to be updated
            to_subtract_balance_credit = Decimal(balance_credit_from_latest_order).__neg__()
        else:
            to_add_balance = Decimal(0.00)
            # since the cart_and_tax_total_amount is already in negative, this negative amount
            # has to be used to subtract the balance_credit value for this order
            to_subtract_balance_credit = Decimal(cart_and_tax_total_amount)  # this value is already negative , hence
            # negation is not required

        credit_amount_used = Decimal(0.00)
        final_amount_to_be_paid = Decimal(0.00)
    # finally  we return final_amount_to_be_paid (using payments gateway) , to_add_balance(to updated balance of order)
    # and credit_amount_used ( to update the balance_credit of order, ie to be added or substracted according
    # to passed value
    return [final_amount_to_be_paid, to_add_balance, credit_amount_used, to_subtract_balance_credit]


# this function is used before the discount is applied to get amount total of given items
def calculate_total_amount_for_given_type_cart_items(given_type_cart_items):
    total_amount = 0.00
    for cart_item in given_type_cart_items:
        # cart_item.amount
        total_amount = Decimal(total_amount) + Decimal(cart_item.amount)
    return total_amount


# this function is used before the discount is applied to get amount total of given items
def calculate_total_amount_net_for_given_type_cart_items(given_type_cart_items):
    total_amount = 0.00
    for cart_item in given_type_cart_items:
        # cart_item.amount
        total_amount = Decimal(total_amount) + Decimal(cart_item.amount_net)
    return total_amount


def calculate_total_amount_net_for_changed_cart_items(all_cart_items):
    total_amount_net = 0.00
    filter_param = (Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE)) | Q(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL)))

    for cart_item in all_cart_items.filter(filter_param):
        # cart_item.amount_net
        total_amount_net = Decimal(total_amount_net) + Decimal(cart_item.amount_net)
    return total_amount_net


def get_changed_cart_items_with_service_charge_tax_and_cancellation_charge_items(all_cart_items):
    # we are setting filter param to get Items with SALE , CANCEL , TAX and CREDIT COUPON type
    filter_param = (Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE)) |
                    Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL)) |
                    Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(TAX_OR_SERVICE_CHARGE)) |
                    Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCELLATION_CHARGE))
                    )
    return all_cart_items.filter(filter_param)


def calculate_net_amount_with_changed_carts_service_charge_tax_and_cancellation_charge_cart_items(all_cart_items):
    # items with SALE and CANCEL transaction type and SERVICE_CHARGE_AND_TAX_ITEM type
    changed_cart_items_with_service_and_tax_items = get_changed_cart_items_with_service_charge_tax_and_cancellation_charge_items(
        all_cart_items)

    changed_carts_total_amount = 0.00

    for cart_item in changed_cart_items_with_service_and_tax_items:
        # discount is given to amount hence very carefully sum up the cart_item.amount
        changed_carts_total_amount = Decimal(cart_item.amount_net) + Decimal(changed_carts_total_amount)
    return changed_carts_total_amount


def get_cart_items_queryset_for_each_category(user, filter_query, event=None):
    all_cart_items = get_all_cart_items_of_main_user(user, event)
    return all_cart_items.filter(filter_query)


def get_all_cart_items_of_main_user(user, event=None):
    if event:
        return ItemCart.objects.filter(ordered_by_user=user, event=event).exclude(
            event_attendee__registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED)).order_by('id')
    else:
        return ItemCart.objects.filter(ordered_by_user=user).exclude(
            event_attendee__registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED)).order_by('id')


# this returns all cart items of any passed user , belongint to event if event object is also passed
def get_all_cart_items_of_user(user, event=None):
    if event:
        return ItemCart.objects.filter(user=user, event=event)
    else:
        return ItemCart.objects.filter(user=user)


# returns only cart items with transaction type SALE
def get_only_sale_type_cart_items(all_cart_items):
    return all_cart_items.filter(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE))


# returns only cart items with transaction type SALE
def get_only_cancelled_cart_items(all_cart_items):
    return all_cart_items.filter(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL))


#  this function updates the cart items in edit mode, that is , only sale type and cancel type items relative to
#  his previous active order items are created using this logic
# ( new items added as SALE type and canceled items as CANCEL type)
def maintain_only_changed_items_in_cart_in_order_edit(request, main_user, given_type_event_items,
                                                      selected_items_in_cart_uuid_list,
                                                      user=None,
                                                      main_attendee=None, attendee=None, event=None):
    # import done here to avoid the circular dependency error
    from events.utils import (get_form_data_for_transportation_item,
                              update_transportation_info_of_transportation_event_item)
    # here we all orders for main_attendee for given event
    order_queryset = get_all_orders_of_main_user(main_attendee.user, event)

    for event_item in given_type_event_items:
        # we find out if event_item is already in active_ordered_items and edited version cart_items
        # this returns single event_item object
        item_in_active_cart_item_list = get_event_item_if_already_in_cart_items_for_given_attendee(
            event,
            main_attendee,
            attendee,
            event_item)

        # this returns single event_item object
        item_in_active_ordered_item_list = get_event_item_if_already_in_ordered_items_for_given_attendee(
            order_queryset, attendee, event_item)

        # we should check if event_item is already added in cart_item as CANCEL type, if yes
        #  we find out the id value of canceled_ordered_item of that cart_item and exclude it to
        # find out item_in_active_ordered_item_list
        if item_in_active_cart_item_list:
            if item_in_active_cart_item_list.canceled_ordered_item:
                exclude_param = Q(id__in=[item_in_active_cart_item_list.canceled_ordered_item.id])
                # this returns single event_item object
                item_in_active_ordered_item_list = get_event_item_if_already_in_ordered_items_for_given_attendee(
                    order_queryset, attendee, event_item, exclude_param)

        # we check it event_item is in request data (form data)
        # since , transportation_uuid in form data is string , we need to convert event_item.uuid to string
        #  to compare
        if str(event_item.uuid) in selected_items_in_cart_uuid_list:
            # now we check if item_in_active_cart_item_list or
            # item_in_active_ordered_item_list are event_item object or None

            if item_in_active_cart_item_list or item_in_active_ordered_item_list:
                # first check if event_item exits both in ordered_items and cart_items
                if item_in_active_cart_item_list and item_in_active_ordered_item_list:
                    # this means ordered_items have same event_item with SALE type
                    # and cart_items have same event_item with CANCEL type , thus exits in both
                    # hence , we delete the event_item in cart_item(as CANCEL type)

                    hard_delete_item_cart(Q(uuid=item_in_active_cart_item_list.uuid))
                #     check if event_item already exits in cart_item_list
                elif item_in_active_cart_item_list:
                    # this means event_item is already in cart_items_list as CANCEL type
                    #  or SALE type hence ,if it is as SALE type leave it as it is since
                    # it is choosen to be added
                    # but if it is as CANCEL type, it has be be deleted

                    if item_in_active_cart_item_list.transaction_type == dict(
                            ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL):
                        hard_delete_item_cart(Q(uuid=item_in_active_cart_item_list.uuid))


                else:
                    # this means event_item is already in ordered_items as SALE, hence we do nothing
                    # since this time too event_item is selected as SALE type

                    #         here if the event_item type is transportation type , we need to  update the
                    # transportation_info related dict value
                    if event_item.group.name == dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION):
                        form_data = get_form_data_for_transportation_item(request, event_item, attendee.uuid)
                        #              now we actually update arrival_datetime , departure_datetime and pickup_location
                        #  of ordered_item
                        if form_data['arrival_datetime']:
                            item_in_active_ordered_item_list.transportation_info.arrival_datetime = form_data[
                                'arrival_datetime']
                        if form_data['departure_datetime']:
                            item_in_active_ordered_item_list.transportation_info.departure_datetime = form_data[
                                'departure_datetime']
                        if form_data['pickup_location']:
                            item_in_active_ordered_item_list.transportation_info.pickup_location = get_transportation_pickup_location_by_uuid(
                                form_data['pickup_location']['uuid'])
                        item_in_active_ordered_item_list.transportation_info.save()

            else:
                # this means event_item is neither on ordered_items or cart_items , hence
                #  we need to add in cart_items as SALE type
                # if item is transportation_item then we need to get the transporation info related data
                #  and also get the data from nested loop hence

                if event_item.group.name == dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION):
                    form_data = get_form_data_for_transportation_item(request, event_item, attendee.uuid)
                    selected_items = update_transportation_info_of_transportation_event_item(event_item,
                                                                                             form_data)
                # since, the this function is used transportation and accommodation items ,
                # if and else can be used,
                # TODO : if any other kind of items are added here, we need to increase if else conditions
                else:
                    selected_items = [get_basic_cart_dict_from_event_item(event_item)]

                attendee_cart_data = get_cart_item_dict_for_user(
                    main_attendee.user, user, selected_items,
                    dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(

                        SALE),
                    main_attendee,
                    attendee, event,
                    canceled_ordered_item=None)
                #  now create cart_item
                create_event_item_cart(attendee_cart_data)
        else:
            if item_in_active_cart_item_list or item_in_active_ordered_item_list:
                # first check if event_item exits both in ordered_items and cart_items
                if item_in_active_cart_item_list and item_in_active_ordered_item_list:
                    # this means ordered_items have same event_item with SALE type
                    # and cart_items have same event_item with CANCEL type , thus exits in both
                    # hence , we delete the event_item in cart_item(as CANCEL type)

                    hard_delete_item_cart(Q(uuid=item_in_active_cart_item_list.uuid))
                #     check if event_item already exits in cart_item_list
                elif item_in_active_ordered_item_list:
                    # this means event_item is already in ordered_item as SALE type, but since it is
                    # unselected now, cart_item with CANCEL type has to be created
                    # since these event_item are unselected,  we donot have transportation_info for these
                    # selected_items provided list since no transportation_info_update function is not called
                    # which returns list
                    selected_items = [
                        get_selected_item_dict_from_ordered_item(item_in_active_ordered_item_list,
                                                                 is_canceled_item=True)]

                    attendee_cart_data = get_cart_item_dict_for_user(
                        main_attendee.user, user,
                        selected_items,
                        dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                            CANCEL),

                        main_attendee,
                        attendee, event,
                        # canceled_ordered_item against which
                        # cart_item of CANCEL type is created
                        item_in_active_ordered_item_list)
                    # now create cart item
                    create_event_item_cart(attendee_cart_data)

                else:
                    # this means item is unselected in form data, and does not exist  in ordered_item (may
                    # excluded by canceled_ordered_item) and but is in cart_items
                    # if the item is in cart_items as cancel type ( we have to do nothing since , this time too
                    #  it is being unselected meaning it is intended to be CANCEL type
                    # but if it is in cart_item as SALE type we need to delete these items since,
                    # they are to be unselected,
                    if item_in_active_cart_item_list.transaction_type == dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                            SALE):
                        hard_delete_item_cart(Q(uuid=item_in_active_cart_item_list.uuid))


#  this function perform the  operations such as discount, calculation for cart summary for both non-edit and
# edit
def perform_operations_on_cart_items_for_cart_summary(main_user, latest_order=None, main_attendee=None, event=None):
    all_cart_items = get_all_cart_items_of_main_user(main_user, event)
    # first of all we , make the discount field of every cart item 0.00 hence discount is recalculate
    # and updated as per coupons available in below code
    all_cart_items = update_discount_of_cart_items_to_zero_value(all_cart_items)
    selected_taxable_cart_items = all_cart_items.filter(
        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION)) |
        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)) |
        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION))
    )
    #  we need to create the cancellation charge cart items from the cancelled cart items
    #  so that its sum can be considered while performing final calculation to refund or pay
    create_cancellation_charge_cart_items(
        get_only_cancelled_cart_items(selected_taxable_cart_items), main_user, main_attendee, event)

    #  now we need to check if the attendees registered by main_attendee are senior citizens , if yes
    #  we need to provide the senior citizen discount to each item if  senior_citizen_discount_applicable
    #  field from event_item is True and generate SENIOR_CITIZEN_DISCOUNT_COUPON with value obtained from
    # senior_citizen_discount_per (from ItemMaster)
    senior_citizen_discount_applied_cart_items = apply_senior_citizen_discount_to_cart_items(
        selected_taxable_cart_items,
        main_user, main_attendee,
        event)

    # find out the total amount of added (SALE type cart items)
    #  since discount is senior citizen discount is already applied  , we now need to add the
    # amount_net of all returned items with senior citizen discount applied
    total_amount_for_added_carts = calculate_total_amount_net_for_given_type_cart_items(
        senior_citizen_discount_applied_cart_items.filter(
            transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE)))

    #  we then find out the total_discount_applicable from discount cart items
    discount_coupon_items = get_discount_coupon_items_from_cart_items(all_cart_items)
    #  we need to give priority to the senior citizen discount , hence we need to subtract its value to provide
    # maximum_discount_applicable for applying discount
    maximum_discount_applicable = calculate_absolute_total_amount_from_coupon_cart_items(
        discount_coupon_items)

    #  now check if total_discount_applicable is greater than total_amount_for_changed_carts
    #  if yes , total_discount_applicable has to be made equal to total_amount_for_changed_carts
    # since discount more than total_cost can not be given
    if maximum_discount_applicable > total_amount_for_added_carts:
        # provide negative value to discount amount
        maximum_discount_applicable = total_amount_for_added_carts

    # now we need to find out if discount_coupon_items exists in cart_items of main_attendee,
    # if yes , items in loop have to be provided discount to avoid tax
    # and service charge on items until the complete coupon items are utilized fully
    # we have order_by to apply the discount to first main_attendee which is registered first , then only
    # to his guest attendees if exits
    discount_applied_cart_items = update_discount_of_cart_items(
        senior_citizen_discount_applied_cart_items.order_by('event_attendee__id'),
        maximum_discount_applicable)
    # discount_applied_cart_items contains both SALE and CANCEL type item but SALE type items are applied with
    # discount if discount coupon is used

    # get or create added service charge item and tax item
    [service_charge_and_tax_items,
     net_service_charge_and_tax_amount] = get_or_create_applicable_tax_cart_item_or_service_charge_cart_item(
        main_user,
        selected_taxable_cart_items,
        [
            dict(
                DEFAULT_ITEM_MASTERS_NAME).get(
                ADDED_SERVICE_CHARGE_ITEM),
            dict(
                DEFAULT_ITEM_MASTERS_NAME).get(
                CANCELED_SERVICE_CHARGE_ITEM),
            dict(
                DEFAULT_ITEM_MASTERS_NAME).get(
                APPLICABLE_TAX_ITEM),
            dict(
                DEFAULT_ITEM_MASTERS_NAME).get(
                CANCELED_TAX_ITEM)
        ],
        main_attendee.user,
        main_attendee,
        event)

    # it may be negative or positive value
    # this gives the total amount (may be positive or negative) for changed cart items
    # if negative > it means > no more amount to pay , rather left amount is refundable
    # if positive  > it means > more amount has to be paid ( he/she has to pay either through payments card
    #  or credit coupon

    # cancellation charge related cart items and total amount for it
    cancellation_charge_cart_items = get_all_cancellation_charge_cart_items_of_main_user(main_user, event)
    total_cancellation_charge_amount = calculate_total_amount_net_for_cancellation_charge_cart_items(
        cancellation_charge_cart_items)
    # we need to add the total cancellation charge amount to amount_net_for_changed_cart_items , since, he/she
    # has to pay more for items since the amount he/she would receive without the cancellation policy applied ,
    #  would not receive if policy applied and there would be lesser deduction from cancelled amount while calculating
    # net amount
    amount_net_for_changed_cart_items = Decimal(calculate_total_amount_net_for_changed_cart_items(
        discount_applied_cart_items)) + Decimal(total_cancellation_charge_amount)

    amount_net_with_service_charge_and_tax = Decimal(amount_net_for_changed_cart_items) + Decimal(
        net_service_charge_and_tax_amount)

    net_balance_from_latest_order = get_net_positive_balance_from_latest_order(latest_order)
    balance_credit = get_balance_credit_from_latest_order(latest_order)

    if amount_net_with_service_charge_and_tax <= 0:
        #     this means that attendee no more needs to pay any amount for this order edit,
        # but he/she might need to be refunded back . total refundable amount would be
        #  sum of balance from previous order and this amount_net_for_changed_cart_items

        #  here we subtract the total cancellation charge amount to obtain the refundable amount
        refundable_balance = Decimal(net_balance_from_latest_order) + abs(
            Decimal(amount_net_with_service_charge_and_tax))
        final_amount_to_pay = 0.00
        current_total_credit_amount_used = 0.00
    else:
        # this means he/she has to pay more amount for this order edit, thus he/she first either pays using
        # previous balance (used internally) or pays using coupon or pays using payments card
        amount_after_previous_balance_applied = Decimal(amount_net_with_service_charge_and_tax) - Decimal(
            net_balance_from_latest_order)

        #     if amount_after_previous_balance_subtracted is still positive , still more amount is left
        # to be paid , hence credit coupon needs to be applied if credit coupon is added
        if amount_after_previous_balance_applied > 0:
            current_total_credit_amount_used = apply_credit_coupon_and_calculate_total_credit_amount_used(
                all_cart_items,
                amount_after_previous_balance_applied)

            # total_credit_amount_used obtained would be either 0.00 or any negative amount(decreased when added)
            final_amount_to_pay = Decimal(current_total_credit_amount_used) + Decimal(
                amount_after_previous_balance_applied)
            refundable_balance = 0.00

        else:
            # this means payments was sufficient by using previous balance and still previous balance might be
            #  remaining , hence this amount is refundable
            refundable_balance = Decimal(abs(amount_after_previous_balance_applied))
            final_amount_to_pay = 0.00
            amount_after_previous_balance_applied = 0.00
            current_total_credit_amount_used = 0.00

    return {
        'all_cart_items': all_cart_items,
        'amount_net_for_changed_cart_items': amount_net_for_changed_cart_items,
        'service_charge_and_tax_items': service_charge_and_tax_items,
        'net_service_charge_and_tax_amount': net_service_charge_and_tax_amount,
        'cancellation_charge_cart_items': cancellation_charge_cart_items,
        'total_cancellation_charge_amount': total_cancellation_charge_amount,
        'net_balance_from_latest_order': net_balance_from_latest_order,
        'current_total_credit_amount_used': current_total_credit_amount_used,
        'current_total_discount_coupon_used': maximum_discount_applicable,
        'final_amount_to_pay': final_amount_to_pay,
        'balance_credit': balance_credit,
        'refundable_balance': refundable_balance,
    }


#  to delete the already added event cart item for given attendee for given event
def hard_delete_item_cart(filter_query):
    # deletes multiple object obtained using the filter_query
    ItemCart.objects.filter(filter_query).hard_delete()
    return True


def delete_all_cart_items_of_main_user(user, event=None, exclude_coupon_items=False):
    if event:
        filter_query = Q(event=event, ordered_by_user=user)
    else:
        filter_query = Q(ordered_by_user=user)
    if exclude_coupon_items:
        filter_query = filter_query and ~Q(is_coupon_item=True)
    hard_delete_item_cart(filter_query)


def get_cart_item_object_by_uuid(cart_item_uuid):
    try:
        event = ItemCart.objects.get(uuid=cart_item_uuid)
        return event
    except ObjectDoesNotExist as e:
        raise Exception(e)
