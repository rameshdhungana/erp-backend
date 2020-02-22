from datetime import datetime

from decimal import Decimal

from django import template

register = template.Library()


#  this gives the total amount of ordered_items
@register.simple_tag
def generate_ordered_items_total_amount(ordered_items):
    total_amount = 0.00
    for item in ordered_items:
        total_amount = Decimal(total_amount) + Decimal(item['amount_net'])
    return Decimal(total_amount)


# this gives the total amount of coupon_items
@register.simple_tag
def generate_coupon_item_total_amount(coupon_items):
    total_amount = 0.00
    for item in coupon_items:
        total_amount = Decimal(total_amount) + Decimal(item['amount_net'])
    return total_amount.__neg__()


@register.filter
def negate_amount(amount):
    return Decimal(amount).__neg__()


@register.simple_tag
def get_formatted_datetime(datetime_str):
    datetime_object = datetime.strptime(datetime_str, "%Y-%m-%dT%H:%M:%S.%fZ")
    return datetime_object.strftime("%Y-%m-%d %H:%M")


@register.simple_tag
def get_phone_number_or_dash(phone_number):
    return phone_number if phone_number else '---'


@register.simple_tag
def get_email_or_dash(email):
    return email if email else '---'


@register.simple_tag
def get_type_of_tax_item(item_master):
    print(item_master)
    return 'Tax' if item_master['item_is_tax'] else 'Service Charge'
