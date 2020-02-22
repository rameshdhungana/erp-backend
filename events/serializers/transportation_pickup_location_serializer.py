from rest_framework.serializers import ModelSerializer
from events.models import TransportationPickupLocation


class TransportationPickupLocationSerializer(ModelSerializer):
    class Meta:
        model = TransportationPickupLocation
        fields = ('location',)

    def to_representation(self, instance):
        # import is made lazy to avoid circular dependency
        from events.serializers import EventItemSerializer

        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,
            # 'event_item': EventItemSerializer(instance.event_item).data,

        }
        response.update(data)
        return response
