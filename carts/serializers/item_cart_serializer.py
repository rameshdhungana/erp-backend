from rest_framework.serializers import ModelSerializer

from carts.models import ItemCart
from events.serializers import EventItemSerializer, TransportationInfoSerializer, EventAttendeeSerializer
from items.serializers import ItemMasterSerializer
from coupons.serializers.coupon_serializer import CouponSerializer
from users.serializers import UserSerializer


class ItemCartSerializer(ModelSerializer):
    event_item = EventItemSerializer()
    coupon = CouponSerializer()
    item_master = ItemMasterSerializer()
    user = UserSerializer()
    ordered_by_user = UserSerializer()
    transportation_info = TransportationInfoSerializer()
    event_attendee = EventAttendeeSerializer()

    class Meta:
        model = ItemCart
        exclude = ('deleted_at',)

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,

        }
        response.update(data)
        return response
