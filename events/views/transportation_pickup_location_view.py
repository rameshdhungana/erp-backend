from django.conf import settings
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from events.models import TransportationPickupLocation
from events.serializers.transportation_pickup_location_serializer import TransportationPickupLocationSerializer
from events.utils import get_event_item_object, get_event_object_by_uuid


class TransportationPickupLocationViewSet(ModelViewSet):
    serializer_class = TransportationPickupLocationSerializer
    lookup_field = 'uuid'

    def get_queryset(self):
        print(self.kwargs.get('event_uuid', None), get_event_object_by_uuid(self.kwargs.get('event_uuid', None)))
        if self.kwargs.get('event_uuid', None):
            return TransportationPickupLocation.objects.filter(
                event=get_event_object_by_uuid(self.kwargs.get('event_uuid', None)))
        return TransportationPickupLocation.objects.filter(transportationinfo=1)

    def get_serializer_context(self):
        context = super().get_serializer_context()
        if self.request.data.get('event_item_uuid', None):
            context.update({"event_item": get_event_item_object(self.request.data.get('event_item_uuid', None))})
        return context

    def retrieve(self, request, *args, **kwargs):
        response_data = super().retrieve(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Transportation Pickup Location Detail is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Transportation Pickup Location List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Transportation Pickup Location   is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        event_item = get_event_item_object(self.request.data.get('event_item_uuid', None))
        pickup_location = serializer.save(event=event_item.event)
        #  here we add accommodation room to event_item
        event_item.transportation_pickup_locations.add(pickup_location)
        event_item.save()

    def update(self, request, *args, **kwargs):
        print('update dat', request.data)
        response_data = super().update(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Transportation Pickup Location  is edited successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def partial_update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)
