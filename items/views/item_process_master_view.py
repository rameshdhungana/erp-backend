from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from items.models import ItemProcessMaster
from items.serializers import ProcessMasterSerializer


class ProcessMasterViewSet(ModelViewSet):
    serializer_class = ProcessMasterSerializer
    queryset = ItemProcessMaster.objects.all()
    lookup_field = 'uuid'

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Item Process Master  List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
