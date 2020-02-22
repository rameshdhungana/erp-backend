from rest_framework.serializers import ModelSerializer

from events.models import EventRegistrationType


class EventRegistrationTypeSerializer(ModelSerializer):
    class Meta:
        model = EventRegistrationType
        exclude = ('id', 'uuid', 'event', 'deleted_at', 'is_published', 'is_public', 'required_otp')
