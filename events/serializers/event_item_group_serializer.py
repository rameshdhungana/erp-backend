from rest_framework import serializers

from events.models import EventItemGroup, DEFAULT_EVENT_ITEM_GROUPS


class EventItemGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = EventItemGroup
        exclude = ('event', 'deleted_at')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {'uuid': instance.uuid}
        response.update(data)
        return response

    def validate(self, attrs):
        if attrs['name'] in DEFAULT_EVENT_ITEM_GROUPS:
            raise serializers.ValidationError('Event Item Group with this name is already created by default.')
        return attrs
