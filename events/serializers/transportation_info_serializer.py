from rest_framework.serializers import ModelSerializer
from events.models import TransportationInfo
from events.serializers import TransportationPickupLocationSerializer


class TransportationInfoSerializer(ModelSerializer):
    class Meta:
        model = TransportationInfo
        fields = ('arrival_datetime', 'departure_datetime', 'pickup_location')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,
            'pickup_location': TransportationPickupLocationSerializer(instance.pickup_location).data,

        }
        response.update(data)
        return response
