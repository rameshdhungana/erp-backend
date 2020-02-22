from django.conf import settings
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ReadOnlyModelViewSet

from carts.models import ItemCart
from carts.serializers import ItemCartSerializer


class ItemCartViewSet(ReadOnlyModelViewSet):
    serializer_class = ItemCartSerializer
    queryset = ItemCart.objects.all()
    lookup_field = 'uuid'
    filter_backends = (DjangoFilterBackend,)
    filter_fields = ('event__uuid', 'ordered_by_attendee__uuid', 'event_item__group__name')

    def get_queryset(self):
        return self.queryset.filter(event__uuid=self.kwargs['event_uuid'])

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item Cart List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
