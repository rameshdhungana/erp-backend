from django.conf import settings
from django.db import transaction
from django.db.models import Q
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from carts.models import ItemCart
from carts.utils import get_all_cart_items_of_main_user, hard_delete_item_cart
from coupons.models import Coupon
from coupons.serializers.coupon_serializer import CouponSerializer, CouponUpdateSerializer
from coupons.utils.coupon_util import generate_coupon_code, validate_coupon_code, \
    perform_coupon_operation_and_prioritize_discount_coupon
from events.utils import get_event_attendee_object_by_uuid, get_event_object


class CouponViewSet(ModelViewSet):
    serializer_class = CouponSerializer
    queryset = Coupon.objects.all()
    lookup_field = 'uuid'

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Coupon code List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        coupon_code = generate_coupon_code()
        # following condition maintains uniqueness of coupon_code

        while Coupon.objects.filter(coupon_code=coupon_code).exists():
            coupon_code = generate_coupon_code()

        serializer.save(coupon_code=coupon_code)

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', True)
        instance = self.get_object()
        serializer = CouponUpdateSerializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)

        # this API validate the coupon, if valid create it as event item and add to cart

    @transaction.atomic
    @action(methods=['post'], detail=False, url_path='validate-coupon')
    def validate_coupon_and_add_to_cart(self, request):
        main_attendee = get_event_attendee_object_by_uuid(request.data.get('event_attendee_uuid', None))
        event = get_event_object(request.data.get('event_uuid', None))
        coupon_code = request.data['coupon_code']
        valid_coupon, message = validate_coupon_code(coupon_code, main_attendee.user)

        if valid_coupon:
            all_cart_items = get_all_cart_items_of_main_user(main_attendee.user, event)
            [coupon_is_added_to_cart, message] = perform_coupon_operation_and_prioritize_discount_coupon(
                valid_coupon,
                main_attendee.user,
                all_cart_items,
                main_attendee,
                event)

            if coupon_is_added_to_cart:

                response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                                 'message': 'Coupon is applied successfully',
                                 }
            else:

                response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                                 'message': 'Your net amount to pay is already in -(negative).So there is no '
                                            'meaning of applying coupon code.' if message == 'not-required' else
                                 'Coupon is already added !',
                                 'coupon_valid': True
                                 }
        # else condition is applied if coupon is not valid , here we sent code with error_code
        else:
            response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                             'message': 'Invalid coupon code !' if message == 'invalid' else
                             'Coupon is already used by others !',
                             'coupon_valid': False
                             }

        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['post'], detail=False, url_path='remove-coupon-from-cart')
    def remove_coupon_from_cart(self, request, *args, **kwargs):
        filter_param = Q(uuid=request.data.get('cart_item_uuid', None))
        hard_delete_item_cart(filter_param)
        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Coupon Code is successfully removed.',
                         })
