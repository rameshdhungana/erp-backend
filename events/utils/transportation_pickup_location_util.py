from django.core.exceptions import ObjectDoesNotExist

from events.models import TransportationPickupLocation


#  to get transportation pickup location object with uuid provided
def get_transportation_pickup_location_by_uuid(pickup_location_uuid):
    try:
        pickup_location = TransportationPickupLocation.objects.get(uuid=pickup_location_uuid)
        return pickup_location
    except ObjectDoesNotExist as e:
        raise Exception(e)
