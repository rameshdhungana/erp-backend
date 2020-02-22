from rest_framework.serializers import ModelSerializer

from events.serializers import EventAttendeeSerializer
from orders.models import Order
from users.serializers import UserSerializer


class OrderSerializer(ModelSerializer):
    from orders.serializers import OrderedItemSerializer

    user = UserSerializer()
    event_attendee = EventAttendeeSerializer()
    order_items = OrderedItemSerializer(many=True)

    class Meta:
        model = Order
        exclude = (
            'deleted_at', 'uuid', 'id', 'order_number', 'order_cfy', 'balance', 'balance_credit', 'operator')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,
            'order_number': instance.order_number,
            'order_cfy': instance.order_cfy,
            'balance': instance.balance,
            'balance_credit': instance.balance_credit,
            'operator': instance.operator,
        }
        response.update(data)
        return response


#  this serializer does not contain the order_items  as its field so that unnecessary data is ommitted
class OrderOptimizedSerializer(OrderSerializer):
    order_items = None

    class Meta(OrderSerializer.Meta):
        exclude = OrderSerializer.Meta.exclude + ('order_items',)
