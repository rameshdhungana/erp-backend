from decimal import Decimal

from django.core.exceptions import ObjectDoesNotExist

from carts.models import ItemCart
from coupons.models.coupon import SENIOR_CITIZEN_DISCOUNT_COUPON, COUPON_TYPE_CHOICES, Coupon
from coupons.utils import calculate_exact_discount_for_each_cart_item
from coupons.utils.coupon_util import generate_coupon_code, add_coupon_item_to_cart
from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE


def apply_senior_citizen_discount_to_cart_items(all_cart_items, main_user, main_attendee=None, event=None):
    from events.utils import get_all_attendees

    total_discount_applied = 0.00

    all_attendees = get_all_attendees(main_attendee, event)
    for attendee in all_attendees:
        #  for each attendee , if he/she senior citizen , we need to apply the discount for each items added to him
        if attendee.is_senior_citizen:
            #  now we obtain the cart items only belonging to the attendee
            attendee_cart_items = all_cart_items.filter(event_attendee=attendee)
            for cart_item in attendee_cart_items:
                #  here we apply the discount only if the cart_item type is of SALE type
                if cart_item.transaction_type == dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE):
                    # now we obtain the discount amount for the if the senior_citizen_discount_applicable is true
                    # for the event_item of the cart_item
                    if cart_item.event_item.senior_citizen_discount_applicable:
                        #  now we calculate the exact discount to be applied for item using senior_citizen_discount_per from
                        # item master
                        maximum_discount_applicable = Decimal(
                            Decimal(cart_item.item_master.senior_citizen_discount_per) / 100) * Decimal(
                            cart_item.event_item.get_current_rate())
                        discount = calculate_exact_discount_for_each_cart_item(
                            maximum_discount_applicable,
                            cart_item.quantity, cart_item.rate
                        )
                        # now we update the discount field of cart_item
                        cart_item.discount = discount
                        cart_item.save()
                        # since discount amount is returned , now we decrease the total_discount_applicable by discount calculated
                        # above so that  on next iteration only updated value is passed
                        total_discount_applied = Decimal(total_discount_applied) + Decimal(discount)
    #  if the total discount applied is greater than zero we need to create a coupon in cart with value as
    # SENIOR_CITIZEN_DISCOUNT_COUPON (coupon type)
    if total_discount_applied > 0:
        try:
            coupon_cart_item = ItemCart.objects.get(is_coupon_item=True, event=event,
                                                    ordered_by_attendee=main_attendee,
                                                    coupon__type=dict(COUPON_TYPE_CHOICES).get(
                                                        SENIOR_CITIZEN_DISCOUNT_COUPON))
            coupon_cart_item.coupon.amount_limit = total_discount_applied
            coupon_cart_item.coupon.save()
        except ObjectDoesNotExist:

            coupon = Coupon.objects.create(amount_limit=total_discount_applied,
                                           coupon_code=generate_coupon_code(), type=dict(COUPON_TYPE_CHOICES).get(
                    SENIOR_CITIZEN_DISCOUNT_COUPON))
            add_coupon_item_to_cart(coupon, dict(COUPON_TYPE_CHOICES).get(SENIOR_CITIZEN_DISCOUNT_COUPON), main_user,
                                    main_attendee, event)

    return all_cart_items
