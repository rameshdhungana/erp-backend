from django.conf import settings
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from events.models import Configuration
from events.serializers.configuration_serializer import ConfigurationSerializer


class ConfigurationViewSet(ModelViewSet):
    serializer_class = ConfigurationSerializer
    queryset = Configuration.objects.all()
    lookup_field = 'uuid'
    permission_classes = (IsAuthenticatedOrReadOnly,)

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Configuration List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], url_path='key-value-pairs', detail=False)
    def get_configuration_key_value_pairs(self, request, *args, **kwargs):
        data = {}
        for key, config in enumerate(Configuration.objects.all()):
            data[config.key] = config.value
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Configuration key value pair  is fetched successfully',
                         'data': data}

        return Response(response_data, status=status.HTTP_200_OK)
