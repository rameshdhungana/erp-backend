from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from items.models import DEFAULT_ITEM_MASTER_SERVICES, ItemService
from items.serializers import ServiceSerializer


class ServiceViewSet(ModelViewSet):
    serializer_class = ServiceSerializer
    queryset = ItemService.objects.all()
    lookup_field = 'uuid'

    def get_queryset(self):
        custom_queryset = self.queryset
        #  default created item services are to be excluded
        for name in dict(DEFAULT_ITEM_MASTER_SERVICES):
            custom_queryset = custom_queryset.exclude(name=name)
        return custom_queryset

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Item Service  List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
