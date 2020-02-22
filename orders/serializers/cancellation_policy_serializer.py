from rest_framework.serializers import ModelSerializer

from orders.models import CancellationPolicy


class CancellationPolicySerializer(ModelSerializer):
    class Meta:
        model = CancellationPolicy
        fields = ['item_master', 'period_from', 'period_to', 'cancellation_per']

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,

        }
        response.update(data)
        return response
