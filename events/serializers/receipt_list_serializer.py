from rest_framework.serializers import ModelSerializer
from orders.models import OrderedItem
from users.serializers import UserSerializer, UserSerializerWithNoDummyEmailAndPhone


class ReceiptListSerializer(ModelSerializer):
    class Meta:
        model = OrderedItem
        exclude = ('updated_at', 'deleted_at',)

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'user': UserSerializerWithNoDummyEmailAndPhone(instance.user,
                                                           context={'event': self.context['event']}).data,
        }
        response.update(data)
        return response
