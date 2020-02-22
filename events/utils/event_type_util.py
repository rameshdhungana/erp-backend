# to get event object when uuid is passed to this function
from django.core.exceptions import ObjectDoesNotExist

from events.models import EventType


def get_event_type_by_id(id):
    try:
        event_type = EventType.objects.get(id=id)
        return event_type
    except ObjectDoesNotExist as e:
        raise Exception(e)
