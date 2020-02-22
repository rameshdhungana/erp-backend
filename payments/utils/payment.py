import stripe
from django.conf import settings

from items.models import DEFAULT_ITEM_MASTERS_NAME, CREDIT_CARD_PAYMENT_ITEM


def perform_stripe_payment(token, final_amount_to_be_paid):
    # start of payments gateway functions

    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here: https://dashboard.stripe.com/account/apikeys
    stripe.api_key = getattr(settings, 'STRIPE_API_kEY', 'sk_test_4eC39HqLyjWDarjtT1zdp7dc')
    # Token is created using Checkout or Elements!
    # Get the payments token ID submitted by the form:

    # ToDo : get currency type from db configurations
    charge = stripe.Charge.create(
        amount=int(final_amount_to_be_paid * 100),  # here we multiply the amount (in dollar) to amount in cent
        #  as stripe takes smallest unit of money ( in integer value)
        currency='usd',
        description='Example charge',
        source=token,
    )

    transaction_reference_id = charge['id']

    #  end of payments gateway functions
    #  TODO :   logic to create an ordered_item for the receipt payments

    # TODO : we need to distinguish whether payments gateway is bank or credit card and pass it
    payment_method = dict(DEFAULT_ITEM_MASTERS_NAME).get(CREDIT_CARD_PAYMENT_ITEM)
    transaction_detail = {
        'transaction_reference_id': transaction_reference_id, 'payment_method': payment_method,
        'final_amount_to_be_paid': final_amount_to_be_paid
    }
    return transaction_detail
