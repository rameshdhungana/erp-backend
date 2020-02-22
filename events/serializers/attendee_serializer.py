from rest_framework.serializers import ModelSerializer

from events.models import EventAttendee


class AttendeeSerializer(ModelSerializer):
    class Meta:
        model = EventAttendee
        exclude = ['deleted_at', 'id']

