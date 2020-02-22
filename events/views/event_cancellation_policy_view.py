from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from events.models import Event
from events.serializers import EventCancellationPolicySerializer
from orders.models import CancellationPolicy


class EventCancellationPolicyViewSet(ModelViewSet):
    serializer_class = EventCancellationPolicySerializer
    queryset = CancellationPolicy.objects.all()
    lookup_field = 'uuid'

    def get_queryset(self):
        return self.queryset.filter(event__uuid=self.kwargs['event_uuid'])

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event cancellation policy list is fetched successfully',
                         'data': response_data.data}

        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item cancellation policy  is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        try:
            event = Event.objects.get(uuid=self.kwargs['event_uuid'])
            data = serializer.validated_data
            item_master = data['event_item'].item_master
            serializer.save(event=event, item_master=item_master)
        except ObjectDoesNotExist as e:
            raise Exception(e)
