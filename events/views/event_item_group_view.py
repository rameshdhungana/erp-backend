from django.conf import settings
from django_filters import rest_framework as filters
from rest_framework.filters import SearchFilter
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from events.models import Event, EventItemGroup
from events.serializers import EventItemGroupSerializer


class EventItemGroupViewSet(ModelViewSet):
    serializer_class = EventItemGroupSerializer
    lookup_field = 'uuid'
    pagination_class = CustomPagination
    filter_backends = (filters.DjangoFilterBackend, SearchFilter)

    filterset_fields = ('name', 'slug', 'event_registration_type')
    search_fields = (
        'name', 'slug', 'event_registration_type')

    def get_queryset(self):
        return EventItemGroup.objects.filter(event__uuid=self.kwargs['event_uuid'])

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event ItemGroup List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item Group is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        try:
            event = Event.objects.get(uuid=self.kwargs['event_uuid'])
            serializer.save(event=event)
        except ObjectDoesNotExist as e:
            raise Exception(e)
