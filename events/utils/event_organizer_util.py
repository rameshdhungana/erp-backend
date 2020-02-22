# to get event object when uuid is passed to this function
from django.core.exceptions import ObjectDoesNotExist

from events.models import Organizer


def get_event_organizer_by_id(id):
    try:
        event_organizer = Organizer.objects.get(id=id)
        return event_organizer
    except ObjectDoesNotExist as e:
        raise Exception(e)
