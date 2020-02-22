from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from events.models import Organizer
from events.serializers.organizer_serializer import OrganizerSerializer


class OrganizerViewSet(ModelViewSet):
    serializer_class = OrganizerSerializer
    lookup_field = 'uuid'
    pagination_class = CustomPagination

    def get_queryset(self):
        return Organizer.objects.all()

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Organizer List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Organizer is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
