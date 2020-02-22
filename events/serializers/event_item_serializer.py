from rest_framework.serializers import ModelSerializer

from events.models import EventItem
from events.serializers import (EventItemGroupSerializer, TransportationPickupLocationSerializer,
                                AccommodationRoomSerializer)
from items.serializers import ItemMasterSerializer


class EventItemSerializer(ModelSerializer):
    class Meta:
        model = EventItem

        exclude = ('uuid', 'event', 'items_booked', 'deleted_at')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,
            'early_bird_rate': instance.get_early_bird_rate(),
            'late_bird_rate': instance.get_late_bird_rate(),
            'current_rate': instance.get_current_rate(),
            'items_booked': instance.items_booked,

            'item_master': ItemMasterSerializer(instance.item_master).data,
            'group': EventItemGroupSerializer(instance.group).data,

            'transportation_pickup_locations': TransportationPickupLocationSerializer(
                instance.transportation_pickup_locations, many=True).data,
            'accommodation_rooms': AccommodationRoomSerializer(
                instance.accommodation_rooms, many=True).data
        }
        response.update(data)
        return response
