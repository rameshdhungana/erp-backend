from rest_framework import serializers

from events.serializers import EventAttendeeSerializer
from items.serializers import ItemMasterSerializer
from orders.models import OrderedItem
from coupons.serializers.coupon_serializer import CouponSerializer
from users.serializers import UserSerializer


class OrderedItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderedItem
        exclude = ('deleted_at', 'uuid', 'id')

    def to_representation(self, instance):
        from events.serializers import EventItemSerializer, TransportationInfoSerializer

        response = super().to_representation(instance)
        data = {'uuid': instance.uuid,
                'event_item': EventItemSerializer(instance.event_item).data,
                'item_master': ItemMasterSerializer(instance.item_master).data,
                'user': UserSerializer(instance.user).data,
                'event_attendee': EventAttendeeSerializer(instance.event_attendee).data,
                'transportation_info': TransportationInfoSerializer(instance.transportation_info).data
                }
        response.update(data)
        return response


class OrderedItemAndCartItemCombineSerializer(serializers.ModelSerializer):
    is_cart_item = serializers.BooleanField()
    is_ordered_item = serializers.BooleanField()

    class Meta:
        model = OrderedItem
        fields = (
            'event_item', 'user', 'event_attendee', 'transaction_type', 'transportation_info', 'quantity', 'rate',
            'amount',
            'discount',
            'amount_net', 'is_cart_item', 'is_ordered_item')

    def to_representation(self, dict_object):
        from events.serializers import EventItemSerializer, TransportationInfoSerializer

        response = super().to_representation(dict_object)
        data = {
            'event_item': EventItemSerializer(dict_object['event_item']).data,
            'item_master': ItemMasterSerializer(dict_object['item_master']).data,
            'user': UserSerializer(dict_object['user']).data,
            'event_attendee': EventAttendeeSerializer(dict_object['event_attendee']).data,
            'transportation_info': TransportationInfoSerializer(dict_object['transportation_info']).data,
        }
        response.update(data)
        return response


class OrderedItemCouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderedItem
        fields = (
            'amount_net', 'coupon', 'is_coupon_item', 'created_at')

    def to_representation(self, instance):
        response = super().to_representation(instance)

        data = {
            'coupon': CouponSerializer(instance.coupon).data
        }
        response.update(data)
        return response


class OrderedItemAndCartItemCouponSerializer(serializers.ModelSerializer):
    is_cart_item = serializers.BooleanField()

    class Meta:
        model = OrderedItem
        fields = (
            'uuid', 'amount_net', 'coupon', 'is_coupon_item', 'created_at', 'is_cart_item')

    def to_representation(self, dict_object):
        response = super().to_representation(dict_object)
        data = {
            'coupon': CouponSerializer(dict_object['coupon']).data
        }
        response.update(data)
        return response
