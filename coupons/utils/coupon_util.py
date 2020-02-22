import secrets
from decimal import Decimal

from django.core.exceptions import ObjectDoesNotExist

from carts.models import ItemCart

from coupons.models import COUPON_TYPE_CHOICES, CREDIT_COUPON, DISCOUNT_COUPON, Coupon, SENIOR_CITIZEN_DISCOUNT_COUPON
from items.models import ItemMaster
from orders.models import COUPON, ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE
from orders.serializers.ordered_item_serializer import OrderedItemAndCartItemCouponSerializer


def generate_coupon_code():
    return secrets.token_hex(6).upper()


def validate_coupon_code(coupon_code, user):
    coupon = Coupon.objects.filter(coupon_code=coupon_code).first()

    if coupon:
        # coupon status is made False (not usable code) then we need to invalidate coupon first
        if not coupon.status:
            return None, 'invalid'
        #  if coupon is already used , we return None
        if coupon.amount_limit == coupon.amount_used:
            return None, 'invalid'
        # now we check if the coupon is already added to cart by any other user , if yes
        #  we invalidate the coupon
        if check_if_coupon_is_already_added_to_cart(coupon, user):
            return None, 'already'
        # we check if coupon is created for specific user, we check if user is
        # valid and send coupon other None if not valid user
        if coupon.user:
            return coupon if coupon.user == user else None, 'invalid'
        # TODO: we need to create logic for coupon code related to item master

        if coupon.type == dict(COUPON_TYPE_CHOICES).get(SENIOR_CITIZEN_DISCOUNT_COUPON):
            return None, 'invalid'

        return coupon, 'valid'

    else:
        return None, 'invalid'


def add_coupon_item_to_cart(valid_coupon, coupon_type, user, main_attendee=None, event=None):
    from carts.utils import get_basic_cart_item_dict_for_main_user, create_event_item_cart

    # add to cart
    item_master_name = coupon_type
    # add to cart
    item_master = ItemMaster.objects.get(name=item_master_name)
    selected_items = [{
        'item_master': item_master,
        #  we make the coupon rate negative
        'rate': get_available_amount_from_coupon(valid_coupon).__neg__(),
        'quantity': 1,

    }]
    main_attendee_cart_data = get_basic_cart_item_dict_for_main_user(user, selected_items,
                                                                     dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                                                                         COUPON), main_attendee, event)
    main_attendee_cart_data.update({'selected_items': selected_items,
                                    #  here we set is_coupon_item and coupon_type fields to separate
                                    #  it out as coupon type item in cart
                                    'is_coupon_item': True,
                                    'coupon': valid_coupon,

                                    })
    # now call function to create cart objects
    added_to_cart = create_event_item_cart(main_attendee_cart_data)


def revert_back_credit_coupons_to_unused(credit_coupon_items):
    for credit_cart_item in credit_coupon_items:
        try:
            coupon = Coupon.objects.get(id=credit_cart_item.coupon.id)
            coupon.amount_used = 0.00
            coupon.save()
            # also delete credit_cart_item if it is unused
            credit_cart_item.hard_delete()
        except ObjectDoesNotExist:
            pass


def perform_coupon_operation_and_prioritize_discount_coupon(valid_coupon, user, all_cart_items, main_attendee=None,
                                                            event=None):
    # import done here to avoid circular dependency
    from carts.utils import (
        calculate_net_amount_with_changed_carts_service_charge_tax_and_cancellation_charge_cart_items)

    net_changed_carts_amount = calculate_net_amount_with_changed_carts_service_charge_tax_and_cancellation_charge_cart_items(
        all_cart_items)

    if net_changed_carts_amount > 0:
        credit_coupon_items = get_credit_coupon_items_from_cart_items(all_cart_items)
        total_credit_amount = calculate_absolute_total_amount_from_coupon_cart_items(credit_coupon_items)
        discount_coupon_items = get_discount_coupon_items_from_cart_items(all_cart_items)
        total_discount_amount = calculate_absolute_total_amount_from_coupon_cart_items(discount_coupon_items)

        # if the coupon for cart is already added by main_user, we need to say that this coupon code is
        #  already applied and invalidate it

        if check_if_coupon_is_already_added_to_cart_by_same_user(valid_coupon, discount_coupon_items,
                                                                 credit_coupon_items):
            return [False, 'already']


        else:
            if valid_coupon.type == dict(COUPON_TYPE_CHOICES).get(CREDIT_COUPON):
                #  add coupon_item to cart
                add_coupon_item_to_cart(valid_coupon, CREDIT_COUPON, user, main_attendee, event)

            if valid_coupon.type == dict(COUPON_TYPE_CHOICES).get(DISCOUNT_COUPON):
                #  add coupon_item to cart
                add_coupon_item_to_cart(valid_coupon, DISCOUNT_COUPON, user, main_attendee, event)

            #  now we need a logic to make credit coupon type item already
            # cart unused if it passes the conditions
            total_discount_amount = Decimal(total_discount_amount) + get_available_amount_from_coupon(valid_coupon)
            # now find out difference of    net_changed_carts_amount and    total_discount_amount after discount
            # coupon is added
            if net_changed_carts_amount <= 0:
                #     this means all amount has been paid using discount coupons, hence we need to make
                # all credit coupons used (if any) unused
                revert_back_credit_coupons_to_unused(credit_coupon_items)

            else:
                #     this means there is still amount to pay , (net amount  to pay is more total discount coupon
                # applied , hence we need to find out if already added total_credit_amount is greater than the actual
                # difference to pay
                if credit_coupon_items:
                    total_credit_amount_used = Decimal(total_credit_amount) - Decimal(
                        net_changed_carts_amount)
                    if total_credit_amount_used > Decimal(0.00):
                        # this means more extra amount from credit is paid , hence we distribute the total
                        # credit amount to be used among the applied credit coupon items
                        for item in credit_coupon_items:
                            total_credit_amount_used, current_credit_used = update_amount_used_for_given_coupon_object(
                                item.coupon,
                                total_credit_amount_used)
            return [True, 'valid']

    else:
        return [False, 'not-required']


def get_all_coupon_items_from_ordered_items(all_ordered_items):
    return all_ordered_items.filter(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(COUPON))


def get_all_coupon_items_from_cart_items(all_cart_items):
    return all_cart_items.filter(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(COUPON))


def get_discount_coupon_items_from_cart_items(all_cart_items):
    return all_cart_items.filter(is_coupon_item=True,
                                 coupon__type=dict(COUPON_TYPE_CHOICES).get(DISCOUNT_COUPON))


def get_senior_citizen_coupon_items_from_cart_items(all_cart_items):
    return all_cart_items.filter(is_coupon_item=True,
                                 coupon__type=dict(COUPON_TYPE_CHOICES).get(SENIOR_CITIZEN_DISCOUNT_COUPON))


def get_credit_coupon_items_from_cart_items(all_cart_items):
    return all_cart_items.filter(is_coupon_item=True,
                                 coupon__type=dict(COUPON_TYPE_CHOICES).get(CREDIT_COUPON))


# returns the absoulte total amount from queryset provide to it
def calculate_absolute_total_amount_from_coupon_cart_items(coupon_cart_items):
    total_discount_applicable = 0.00
    for coupon_item in coupon_cart_items:
        # we sum up coupon_item.coupon.amount_limit since it is positive exact value, but  amount from cart is negative.
        total_discount_applicable = Decimal(get_available_amount_from_coupon(coupon_item.coupon)) + Decimal(
            total_discount_applicable)
    return total_discount_applicable


def calculate_exact_discount_for_each_cart_item(total_discount_applicable, cart_item_quantity,
                                                cart_item_rate):
    amount = Decimal(cart_item_quantity) * Decimal(cart_item_rate)
    if total_discount_applicable >= amount:
        return amount
    else:
        return total_discount_applicable


def calculate_exact_discount_for_each_already_discounted_cart_item(total_discount_applicable, amount_net):
    if total_discount_applicable >= amount_net:
        return amount_net
    else:
        return total_discount_applicable


def apply_credit_coupon_and_calculate_total_credit_amount_used(all_cart_items, final_net_amount):
    #  first check if final_net_amount_to received as param is negative , it is negative, it means , we need not to
    #  apply  credit coupon , hence total_credit_amount_used would be 0
    if final_net_amount > 0:
        # credit coupon item types
        max_applicable_credit_amount = calculate_absolute_total_amount_from_coupon_cart_items(
            get_credit_coupon_items_from_cart_items(all_cart_items))

        # we need to check if the  credit coupon amount provided is greater than total changed cart items
        # if yes we need to make credit coupon amount at maximum equal to the total changed_cart_item_amount
        # since we can not provide discount more than than cost
        if max_applicable_credit_amount >= final_net_amount:  # since credit amount is negative ,
            # take  its absolute value
            total_credit_amount_used = final_net_amount.__neg__()  # credit discount value
            # should be negative
        else:
            total_credit_amount_used = max_applicable_credit_amount.__neg__()
    else:
        total_credit_amount_used = 0.00

    return total_credit_amount_used


def update_discount_of_cart_items(all_cart_items, maximum_discount_applicable):
    #  now we need to find out all the discount coupon items from all_cart_items
    # For each item to be added in cart_item , we first calculate how
    # much discount (from discount coupon type only sum ) can be added to
    # its discount field,

    for cart_item in all_cart_items:
        # since discount is applied only to items with SALE type , we first filter only SALE type items

        if cart_item.transaction_type == dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE):
            discount = calculate_exact_discount_for_each_already_discounted_cart_item(maximum_discount_applicable,
                                                                                      cart_item.amount_net)
            # now we update the discount field of cart_item
            cart_item.discount = Decimal(discount) + Decimal(cart_item.discount)
            cart_item.save()
            # since discount amount is returned , now we decrease the total_discount_applicable by discount calculated
            # above so that  on next iteration only updated value is passed
            maximum_discount_applicable = Decimal(maximum_discount_applicable) - Decimal(discount)
    return all_cart_items


def get_combined_coupon_items_serialized_data(coupon_ordered_items, coupon_cart_items):
    final_data = []
    for item in coupon_cart_items:
        final_data.append({'uuid': item.uuid, 'coupon': item.coupon, 'is_coupon_item': item.is_coupon_item,
                           'amount_net': item.amount_net,
                           'created_at': item.created_at, 'is_cart_item': True})
    for item in coupon_ordered_items:
        final_data.append({'uuid': item.uuid, 'coupon': item.coupon, 'is_coupon_item': item.is_coupon_item,
                           'amount_net': item.amount_net,
                           'created_at': item.created_at, 'is_cart_item': False})
    return OrderedItemAndCartItemCouponSerializer((item for item in final_data), many=True).data


# returns total discount applied from discount coupons applied within given passed cart items
def get_total_discount_applied_using_discount_coupon_from_cart_items(all_cart_items):
    #  import done here to avoid circular dependency
    from carts.utils import (get_only_sale_type_cart_items, calculate_total_amount_net_for_given_type_cart_items)

    total_discount_used = 0.00
    for cart_item in get_only_sale_type_cart_items(all_cart_items):
        total_discount_used = Decimal(cart_item.discount) + Decimal(total_discount_used)
    #  now we need to subtract the discount provided from the senior citizenship discount coupon , only
    #  discount coupon has to be used here, we need to get absolute value since senior citizenship
    #  cart item has amount_net in negative value
    total_senior_citizen_discount = abs(calculate_total_amount_net_for_given_type_cart_items(
        get_senior_citizen_coupon_items_from_cart_items(all_cart_items)))

    return abs(Decimal(total_discount_used) - Decimal(total_senior_citizen_discount))


# this function is used to update the amount_used field value for coupon object
def update_amount_used_for_given_coupon_object(coupon, total_coupon_amount_used):
    if get_available_amount_from_coupon(coupon) >= 0:
        # since full coupon_amount_used can be available from this credit coupon,
        # we nullify coupon_amount_used and update amount_used of coupon
        coupon.amount_used = Decimal(total_coupon_amount_used) + Decimal(coupon.amount_used)
        current_amount_used = total_coupon_amount_used
        total_coupon_amount_used = 0.00
    else:
        #             this means credit_amount is not fully used by given coupon items hence, needs to
        #  be distributed to other credit coupon in loop until the coupon_amount_used is nullfied
        coupon.amount_used = Decimal(coupon.amount_used) + Decimal(get_available_amount_from_coupon(coupon))
        current_amount_used = get_available_amount_from_coupon(coupon)
        total_coupon_amount_used = Decimal(total_coupon_amount_used) - Decimal(get_available_amount_from_coupon(coupon))

    coupon.save()
    # second coupon.amount_used is current coupon amount used for given coupon item
    return total_coupon_amount_used, current_amount_used


# this function gives the available amount (amount_limit - amount_used) for given coupon object
def get_available_amount_from_coupon(coupon):
    net_amount = Decimal(coupon.amount_limit) - Decimal(coupon.amount_used)
    if net_amount > 0:
        return net_amount
    return 0.00


# this updates the discount coupon amount_used for discount coupon items in cart
def update_amount_used_for_each_discount_coupon_items(all_cart_items, total_discount_amount_used):
    discount_coupon_cart_items = get_discount_coupon_items_from_cart_items(all_cart_items)

    for coupon_item in discount_coupon_cart_items:
        if total_discount_amount_used > 0:
            total_discount_amount_used, current_discount_used = update_amount_used_for_given_coupon_object(
                coupon_item.coupon,
                total_discount_amount_used)


def check_if_coupon_is_already_added_to_cart_by_same_user(valid_coupon, discount_coupon_items, credit_coupon_items):
    for credit_item in credit_coupon_items:
        if credit_item.coupon == valid_coupon:
            return True
    for discount_item in discount_coupon_items:
        if discount_item.coupon == valid_coupon:
            return True
    return False


# returns the absoulte total amount from queryset provide to it
def calculate_total_amount(coupon_cart_items):
    total_discount_applicable = 0.00
    for coupon_item in coupon_cart_items:
        # we sum up coupon_item.coupon.amount_limit since it is positive exact value, but  amount from cart is negative.
        total_discount_applicable = Decimal(get_available_amount_from_coupon(coupon_item.coupon)) + Decimal(
            total_discount_applicable)
    return total_discount_applicable


def check_if_coupon_is_already_added_to_cart(coupon, user):
    for cart_item in ItemCart.objects.filter(is_coupon_item=True).exclude(ordered_by_user=user):
        if cart_item.coupon == coupon:
            return True
    return False
