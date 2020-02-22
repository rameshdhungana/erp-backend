from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from items.models import UnitOfMeasurement
from items.serializers import UnitOfMeasurementSerializer


class UnitOfMeasurementViewSet(ModelViewSet):
    serializer_class = UnitOfMeasurementSerializer
    queryset = UnitOfMeasurement.objects.all()
    lookup_field = 'uuid'

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Item unit of measurement   List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
