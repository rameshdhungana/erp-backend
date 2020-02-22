from rest_framework.serializers import ModelSerializer

from coupons.models import Coupon
from users.serializers import UserSerializer


class CouponSerializer(ModelSerializer):
    class Meta:
        model = Coupon
        exclude = ['coupon_code', 'uuid', 'deleted_at', 'item_master', 'amount_used', 'created_by', 'updated_by',
                   'status']

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'uuid': instance.uuid,
            'coupon_code': instance.coupon_code,
            'amount_used': instance.amount_used,
            'created_by': UserSerializer(instance.created_by).data,
            'updated_by': UserSerializer(instance.updated_by).data,
            'user': UserSerializer(instance.user).data,
        }
        response.update(data)
        return response


class CouponUpdateSerializer(ModelSerializer):
    class Meta:
        model = Coupon
        fields = ['status', 'notes']
