from django.conf import settings
from django.db.models import F
from django_filters import rest_framework as filters
from rest_framework import status
from rest_framework.filters import SearchFilter
from rest_framework.generics import ListAPIView
from rest_framework.response import Response

from cluberpbackend.pagination import CustomPagination
from events.serializers import ReceiptListSerializer
from events.utils import get_event_object_by_uuid
from orders.models import Order, OrderedItem, ORDER_ITEM_TRANSACTION_TYPE_CHOICES, RECEIPT


class ReceiptListView(ListAPIView, CustomPagination):
    serializer_class = ReceiptListSerializer
    pagination_class = CustomPagination
    lookup_field = 'uuid'
    filter_backends = (filters.DjangoFilterBackend, SearchFilter)

    filterset_fields = ('user__first_name', 'user__last_name')
    search_fields = (
        'user__first_name', 'user__last_name', 'user__email', 'user__phone_number')

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"event": get_event_object_by_uuid(self.kwargs['event_uuid'])})
        return context

    def get_queryset(self):
        """
            Return a list of all receipt ordered items of given event
        """
        event = get_event_object_by_uuid(self.kwargs['event_uuid'])

        order_list = Order.objects.filter(event=event)

        return OrderedItem.objects.filter(order__in=order_list).filter(
            transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(RECEIPT))

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event receipt List   is fetched successfully',

                         'data': response_data.data}, status=status.HTTP_200_OK)
