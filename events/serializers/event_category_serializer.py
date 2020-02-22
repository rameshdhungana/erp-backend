from rest_framework.serializers import ModelSerializer

from events.models import EventCategory


class EventCategorySerializer(ModelSerializer):
    class Meta:
        model = EventCategory
        fields = ['name', 'description']

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'id': instance.id, 'uuid': instance.uuid
        }
        response.update(data)
        return response
