from django.db.models import Q
from carts.models import ItemCart
from orders.models import ORDER_ITEM_TRANSACTION_TYPE_CHOICES, CANCEL, SALE


#  this function used in transportation items and accommodation items order -edit , hence transaction_filter_param
#  is applied as SALE or CANCEL just to be more precise and error due to accidental data modification
#  to get the event_item if it exists in cart for given attendee (registered by main_attendee) for given event
def get_event_item_if_already_in_cart_items_for_given_attendee(event, main_attendee, event_attendee, event_item):
    transaction_filter_param = (Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE)) | Q(
        transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL)))
    cart_item = ItemCart.objects.filter(event=event, ordered_by_attendee=main_attendee, event_item=event_item,

                                        event_attendee=event_attendee).filter(transaction_filter_param)
    #  returns event_item or None
    return cart_item.latest() if cart_item else cart_item


# this function creates a cart object for event item (registration , accommodation , transportation)
def create_event_item_cart(attendee_cart_data):
    selected_items = attendee_cart_data.pop('selected_items')

    for item in selected_items:
        attendee_cart_data.update({'event_item': item.get('event_item', None),
                                   'item_master': item['item_master'],
                                   'rate': item['rate'],
                                   'transportation_info': item.get('transportation_info', None)

                                   })
        #  if the entry to cart is from the ordered item , then we need to provide the amount, discount,
        # amount_net, item_sc, item_tax, and amount_final by extracting value from the selected_items each item

        if item.get('entry_from_ordered_item', None):
            attendee_cart_data.update({
                'amount': item['amount'],
                'discount': item['discount'],
                'amount_net': item['amount_net'],
                'item_sc': item['item_sc'],
                'amount_taxable': item['amount_taxable'],
                'item_tax': item['item_tax'],
                'amount_final': item['amount_final']

            })

        #  here we get or create to avoid addition of exactly same item for event by an attendee
        event_item_cart = ItemCart.objects.create(**attendee_cart_data)

    return True
