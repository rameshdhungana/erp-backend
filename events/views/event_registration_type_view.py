from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from events.models import Event, EventRegistrationType
from events.serializers import EventRegistrationTypeSerializer


class EventRegistrationTypeViewSet(ModelViewSet):
    serializer_class = EventRegistrationTypeSerializer
    queryset = EventRegistrationType.objects.all()
    lookup_field = 'uuid'

    def get_queryset(self):
        return self.queryset.filter(event__uuid=self.kwargs['event_uuid'])

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Registration Type List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Registration Type  is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        try:
            event = Event.objects.get(uuid=self.kwargs['event_uuid'])
            serializer.save(event=event)
        except ObjectDoesNotExist as e:
            raise Exception(e)
