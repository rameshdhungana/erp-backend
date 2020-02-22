from rest_framework.serializers import ModelSerializer

from events.models import Event
from events.serializers import EventCategorySerializer, EventTypeSerializer
from events.serializers.organizer_serializer import OrganizerSerializer


class EventSerializer(ModelSerializer):
    class Meta:
        model = Event
        exclude = ('title_images', 'description_images', 'timezone')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {'uuid': instance.uuid,
                'created_at': instance.created_at,
                'status': instance.status,
                'organizer': OrganizerSerializer(instance.organizer).data,
                'category': EventCategorySerializer(instance.category).data,
                'type': EventTypeSerializer(instance.type).data,
                }
        response.update(data)
        return response
