from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from items.models import ItemMaster, DEFAULT_ITEM_MASTERS_NAME
from items.serializers import ItemMasterSerializer


class ItemMasterViewSet(ModelViewSet):
    serializer_class = ItemMasterSerializer
    queryset = ItemMaster.objects.all()
    lookup_field = 'uuid'

    def get_queryset(self):
        custom_queryset = self.queryset
        #  default created item masters are to be excluded
        for name in dict(DEFAULT_ITEM_MASTERS_NAME):
            custom_queryset = custom_queryset.exclude(name=name)
        return custom_queryset

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Item  List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
