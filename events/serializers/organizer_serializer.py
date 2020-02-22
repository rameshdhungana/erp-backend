from rest_framework.serializers import ModelSerializer

from events.models import Organizer


class OrganizerSerializer(ModelSerializer):
    class Meta:
        model = Organizer
        fields = ['name', 'description', 'location']

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'id': instance.id, 'uuid': instance.uuid
        }
        response.update(data)
        return response
