from rest_framework.serializers import ModelSerializer
from rest_framework import serializers

from events.models import (AccommodationRoom, EventAttendee)
from events.serializers.event_attendee_serializer import (
    EventAttendeeSerializer)


class AccommodationRoomSerializer(ModelSerializer):
    event_attendee = serializers.PrimaryKeyRelatedField(queryset=EventAttendee.objects.all(),
                                                        allow_null=True,
                                                        required=False)

    class Meta:
        model = AccommodationRoom
        fields = ['room_number', 'event_attendee', 'description']

    def to_representation(self, instance):
        response_data = super().to_representation(instance)
        response_data.update({'uuid': instance.uuid,
                              'id': instance.id})
        if instance.event_attendee:
            response_data.update({
                'event_attendee': EventAttendeeSerializer(
                    instance.event_attendee).data})

        return response_data

    def validate(self, attrs):
        event_item = self.context.get('event_item', None)
        if event_item:
            if event_item.accommodation_rooms.filter(room_number=attrs['room_number']):
                raise serializers.ValidationError('Room with this number already exits.')
            if len(event_item.accommodation_rooms.all()) >= event_item.item_capacity:
                raise serializers.ValidationError('Maximum room capacity for this room type has exceeded.')

        return attrs
