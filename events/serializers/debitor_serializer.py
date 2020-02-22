from rest_framework import serializers
from rest_framework.serializers import ModelSerializer
from events.models import EventAttendee
from users.serializers import UserSerializer, UserSerializerWithNoDummyEmailAndPhone


class DebitorListSerializer(ModelSerializer):
    balance = serializers.SerializerMethodField()
    user = UserSerializer()

    class Meta:
        model = EventAttendee
        exclude = ('updated_at', 'deleted_at',)

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'user': UserSerializerWithNoDummyEmailAndPhone(instance.user,
                                                           context={'event': self.context['event']}).data,
        }
        response.update(data)
        return response

    def get_balance(self, obj):
        from orders.utils import get_latest_order_of_main_user, get_net_positive_balance_credit_from_latest_order

        return get_net_positive_balance_credit_from_latest_order(get_latest_order_of_main_user(obj.user, obj.event))
