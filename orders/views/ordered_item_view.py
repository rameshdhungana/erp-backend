import django_filters
from django.conf import settings
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status
from rest_framework.filters import SearchFilter
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from orders.models import OrderedItem
from orders.serializers import OrderedItemSerializer


class OrderedItemFilter(django_filters.FilterSet):
    event_item__group__name = django_filters.CharFilter()
    item_master__name = django_filters.CharFilter()
    transportation_info__pickup_location__location = django_filters.CharFilter()
    event__uuid = django_filters.UUIDFilter()

    class Meta:
        model = OrderedItem
        fields = {
            'transportation_info__departure_datetime': ['date'],
            'transportation_info__arrival_datetime': ['date'],

        }


class OrderedItemViewSet(ModelViewSet):
    serializer_class = OrderedItemSerializer
    lookup_field = 'uuid'
    pagination_class = CustomPagination
    filter_backends = (DjangoFilterBackend, SearchFilter)
    filter_class = OrderedItemFilter

    search_fields = (
        'user__first_name', 'user__last_name', 'user__email', 'user__phone_number',
        'transportation_info__pickup_location__location',
        'item_master__name')

    def get_queryset(self):
        return OrderedItem.objects.all()

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Ordered tem List is fetched successfully',
                         'data': response_data.data}

        return Response(response_data, status=status.HTTP_200_OK)
