from rest_framework import serializers
from rest_framework.serializers import ModelSerializer

from orders.models import CancellationPolicy


class EventCancellationPolicySerializer(ModelSerializer):
    class Meta:
        model = CancellationPolicy
        fields = ['event_item', 'period_from', 'period_to', 'cancellation_per']
        #  since event_item is null=True in Model , we need to make it not nullable through serializer
        extra_kwargs = {'event_item': {'required': True, 'allow_null': False},
                        'cancellation_per': {'required': True, 'allow_null': False}}

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,

        }
        response.update(data)
        return response

    def validate(self, data):

        if data['period_from'] >= data['period_to']:
            raise serializers.ValidationError('Period from can not be greater or equal to Period to')

        if data['cancellation_per'] <= 0 or data['cancellation_per'] > 100:
            raise serializers.ValidationError(
                'Cancellation percentage should be greater than zero and less than  or equal to 100')

        if CancellationPolicy.objects.filter(event_item=data['event_item'],
                                             period_from__lte=data['period_from'],
                                             period_to__gte=data[
                                                 'period_to']).exists():
            raise serializers.ValidationError(
                'Cancellation Policy for this event item for given date range already exits.')

        return data
