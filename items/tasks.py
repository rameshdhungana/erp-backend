from celery.task import task
from django.core.mail.message import EmailMessage
from django.template.loader import render_to_string

# to send email to main attendee with order summary
from events.models import EVENT_REGISTRATION_STATUS
from events.models.event_attendee import CONFIRMED
from events.utils.event_attendee_util import (get_event_attendee_object_by_uuid, get_confirmation_code_for_attendees,
                                              get_all_attendees)
from users.utils import check_if_email_is_dummy


@task(name="send_email_to_all_attendees_with_order_summary")
def send_email_to_all_attendees_with_order_summary(main_attendee_uuid, event_uuid):
    #  import done here to avoid the circular dependency import error
    from events.utils import get_event_object
    from orders.utils import (get_all_orders_of_main_user, get_active_items_of_order, get_cancelled_items_of_order)

    main_attendee = get_event_attendee_object_by_uuid(main_attendee_uuid)
    event = get_event_object(event_uuid)

    subject = 'Order Summary of  event {}'.format(event.title)
    from_email = 'no@reply.com'
    order_queryset = get_all_orders_of_main_user(main_attendee.user, event)
    if main_attendee.registration_status == dict(EVENT_REGISTRATION_STATUS).get(CONFIRMED):
        response_data = get_active_items_of_order(order_queryset, main_attendee.user, main_attendee, event)
        order_is_cancelled = False

    else:
        response_data = get_cancelled_items_of_order(order_queryset, main_attendee.user, main_attendee, event)
        order_is_cancelled = True

    all_attendees = get_all_attendees(main_attendee, event)
    for attendee in all_attendees:
        if attendee.registered_by == main_attendee:
            confirmation_codes = get_confirmation_code_for_attendees(all_attendees)
        else:
            # if the attendee is not main_atttendee we just pass attendee itself as list to get only his/her confirmation
            # codes
            confirmation_codes = get_confirmation_code_for_attendees([attendee])
        to_email_address = main_attendee.user.email

        email_template = render_to_string('event_order_summary.html',
                                          {'order_detail': response_data['order'],
                                           'main_attendee_order_items': response_data[
                                               'main_attendee_order_items'],
                                           'coupon_items': response_data[
                                               'coupon_items'],
                                           'payment_items': response_data[
                                               'payment_items'],
                                           'service_charge_and_tax_items': response_data[
                                               'service_charge_and_tax_items'],

                                           'guest_attendees_order_items': response_data[
                                               'guest_attendees_order_items'],
                                           'confirmation_codes': confirmation_codes,
                                           # 'order_is_cancelled': order_is_cancelled

                                           },
                                          )
        to_email_address = attendee.user.email
        if to_email_address and not check_if_email_is_dummy(to_email_address):
            msg = EmailMessage(subject, email_template, from_email, [to_email_address])
            msg.content_subtype = "html"  # Main content is now text/html
            msg.send()
