# this function decreases the event item capacity count by 1
from django.core.exceptions import ObjectDoesNotExist

from carts.utils import get_basic_cart_dict_from_event_item
from events.models import TransportationInfo, EventItemGroup, Event
from events.utils import get_transportation_pickup_location_by_uuid


def get_event_object_by_uuid(event_uuid):
    try:
        event = Event.objects.get(uuid=event_uuid)
        return event
    except ObjectDoesNotExist as e:
        raise Exception(e)


def get_event_object_by_id(id):
    try:
        event = Event.objects.get(id=id)
        return event
    except ObjectDoesNotExist as e:
        raise Exception(e)


def get_event_item_group_by_id(id):
    try:
        event_item_group = EventItemGroup.objects.get(id=id)
        return event_item_group
    except ObjectDoesNotExist as e:
        raise Exception(e)


def decrease_event_item_item_capacity_count(event_item):
    event_item.item_capacity = event_item.item_capacity - 1
    event_item.save()


# returns the form data related to transportation info from form (frontend data)
def get_form_data_for_transportation_item(request, trans_item, attendee_uuid):
    form_data = []
    for attendee_wise_data in request.data:

        if attendee_wise_data['attendee_uuid'] == str(attendee_uuid):
            for data in attendee_wise_data['transportation_item_list']:
                # trans_item.uuid is converted to string since data from request is also on string form
                #  direct comparison of uuid and string does not work
                if data['transportation_item_uuid'] == str(trans_item.uuid):
                    form_data.append({
                        'arrival_datetime': data['arrival_datetime'],
                        'departure_datetime': data['departure_datetime'],
                        'pickup_location': data['pickup_location'],
                    })
    return form_data[0]


#  updates the transportation info to selected item dict for transportaion items
def update_transportation_info_of_transportation_event_item(event_item,
                                                            form_data):
    selected_item_dict = get_basic_cart_dict_from_event_item(event_item)
    #  we create transportation_info object only if any one of data is available using following
    #  conditions
    if event_item.ask_for_arrival_datetime or event_item.ask_for_departure_datetime or event_item.ask_for_pickup_location:
        transportation_info_data = {}
        if event_item.ask_for_arrival_datetime:
            transportation_info_data.update(
                {'arrival_datetime': form_data['arrival_datetime'],
                 })
        if event_item.ask_for_departure_datetime:
            transportation_info_data.update({
                'departure_datetime': form_data[
                    'departure_datetime'], })
        if event_item.ask_for_pickup_location and event_item.transportation_pickup_locations.all():
            transportation_info_data.update(
                {'pickup_location': get_transportation_pickup_location_by_uuid(
                    form_data['pickup_location']['uuid'])})

        transportation_info = TransportationInfo.objects.create(**transportation_info_data)
        selected_item_dict.update({'transportation_info': transportation_info})

    #  selected_items contains transportation_info only if above condition matches
    selected_items = [selected_item_dict]
    return selected_items
