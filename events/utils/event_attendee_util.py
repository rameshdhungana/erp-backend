from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q

from events.models import EventAttendee
from events.models.event_attendee import EVENT_REGISTRATION_STATUS, CANCELED

# this updates the registration_status of
from orders.models import SALE
from orders.serializers import OrderedItemSerializer
from users.utils import check_if_email_is_dummy, check_if_phone_number_is_dummy


def update_registration_status_of_attendee(attendee, updated_value):
    attendee.registration_status = updated_value
    attendee.save()


def clear_confirmation_code_of_attendee(attendee):
    attendee.confirmation_code = ''
    attendee.save()


def update_confirmation_code_for_attendee(attendee_list):
    from events.utils import generate_confirmation_code

    for attendee in attendee_list:
        #  this makes confirmation code unique for each attendee
        # TODO : query optimization possible ?
        confirmation_code = generate_confirmation_code()
        while EventAttendee.objects.filter(confirmation_code=confirmation_code).exists():
            confirmation_code = generate_confirmation_code()
        attendee.confirmation_code = generate_confirmation_code()
        attendee.save()


def get_confirmation_code_for_attendees(attendee_list):
    confirmation_codes = []
    for attendee in attendee_list:
        if not check_if_phone_number_is_dummy(attendee.user.phone_number) or not check_if_email_is_dummy(
                attendee.user.email):
            confirmation_codes.append({'first_name': attendee.user.first_name,
                                       'last_name': attendee.user.last_name,
                                       'phone_number': attendee.user.phone_number if not check_if_phone_number_is_dummy(
                                           attendee.user.phone_number) else None,
                                       'email': attendee.user.email if not check_if_email_is_dummy(
                                           attendee.user.email) else None,
                                       'confirmation_code': attendee.confirmation_code})
    return confirmation_codes


def get_number_of_attendees_registered_by_main_attendee(main_attendee, event):
    return EventAttendee.objects.filter(registered_by=main_attendee, event=event).exclude(
        registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED)).count()


#  this return the main_attendee (registrant of the attendee object passed)
def get_main_attendee_of_given_attendee(attendee):
    main_attendee = attendee.registered_by
    is_main_attendee = True if main_attendee == attendee and main_attendee.registration_status != dict(
        EVENT_REGISTRATION_STATUS).get(CANCELED) else False
    return [attendee.registered_by, is_main_attendee]


# to get all attendees of main_attendee for an event including cancelled attendees , as it is used for
# order summary of cancelled registration
def get_all_cancelled_attendees(main_attendee, event):
    return EventAttendee.objects.filter(registered_by=main_attendee, event=event).filter(
        registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED)).order_by('created_at')


# to get all attendees of main_attendee for an event
def get_all_attendees(main_attendee, event):
    return EventAttendee.objects.filter(registered_by=main_attendee, event=event).exclude(
        registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED)).order_by('created_at')


def get_guest_attendees(main_attendee, event):
    #  we need to exclude the main_attendee using .exclude () since registered_by
    #  object for main_attendee is him/herself
    return EventAttendee.objects.filter(registered_by=main_attendee, event=event).exclude(
        uuid=main_attendee.uuid).exclude(
        registration_status=dict(
            EVENT_REGISTRATION_STATUS).get(
            CANCELED))


def get_guest_attendee_order_items(ordered_items_queryset, order_queryset, all_guest_attendees, transaction_type):
    guest_attendee_order_items = []
    order_item_queryset = ordered_items_queryset.filter(order__in=order_queryset, transaction_type=transaction_type)
    for guest in all_guest_attendees:
        guest_order_items = order_item_queryset.filter(user=guest.user).order_by('id')
        guest_attendee_order_items.append(OrderedItemSerializer(guest_order_items, many=True).data)

    return guest_attendee_order_items


# returns the event_attendee by id

def get_event_attendee_object_by_id(event_attendee_id):
    try:
        event_attendee = EventAttendee.objects.get(id=event_attendee_id)
        return event_attendee
    except ObjectDoesNotExist as e:
        raise Exception(e)


# returns the event_attendee by uuid
def get_event_attendee_object_by_uuid(event_attendee_uuid):
    try:
        event_attendee = EventAttendee.objects.get(uuid=event_attendee_uuid)
        return event_attendee
    except ObjectDoesNotExist as e:
        raise Exception(e)


# updates the group_type_field of event attendee
def update_group_type_field_of_event_attendee(main_attendee, to_update_value):
    #     now we need to update the group_type field of main_attendee
    main_attendee.group_type = to_update_value
    main_attendee.save()


#  to delete the already added event cart item for given attendee for given event
def hard_delete_event_attendee(filter_query):
    # deletes multiple object obtained using the filter_query
    EventAttendee.objects.filter(filter_query).hard_delete()
    return True


def delete_all_guest_attendees_registered_by_main_user(user, event=None):
    if event:
        filter_query = Q(event=event, ordered_by_user=user)
    else:
        filter_query = Q(ordered_by_user=user)

    hard_delete_event_attendee(filter_query)


def get_attendee_related_data(data):
    return {
        'smart_card_number': data['smart_card_number'],
        'name_in_smart_card': data['name_in_smart_card'],
        'is_senior_citizen': data['is_senior_citizen'],
        'is_pwk': data['is_pwk'],
        #  note is in dict return note else ''
        'note': data.get('note', ''),
    }
