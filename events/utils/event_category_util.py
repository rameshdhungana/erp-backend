# to get event object when uuid is passed to this function
from django.core.exceptions import ObjectDoesNotExist

from events.models import EventCategory


def get_event_category_by_id(id):
    try:
        event_category = EventCategory.objects.get(id=id)
        return event_category
    except ObjectDoesNotExist as e:
        raise Exception(e)
