from time import strptime

from django.conf import settings
from django.db.models import Q
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, decorators
from rest_framework.decorators import action, authentication_classes, permission_classes
from rest_framework.filters import SearchFilter
from rest_framework.permissions import IsAuthenticatedOrReadOnly, AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from events.models import (AccommodationRoom)
from events.serializers import AccommodationRoomSerializer
from events.utils import get_event_item_object, get_event_object_by_uuid, get_event_attendee_object_by_uuid
from users.permissions import GroupWisePermission


class AccommodationRoomViewSet(ModelViewSet):
    serializer_class = AccommodationRoomSerializer
    pagination_class = CustomPagination
    lookup_field = 'uuid'
    filter_backends = (DjangoFilterBackend, SearchFilter)
    search_fields = ('room_number', 'description', 'event_attendee__user__first_name',
                     'event_attendee__user__last_name', 'event_attendee__user__email',
                     'event_attendee__user__phone_number')

    filter_fields = ('room_number', 'description', 'event_attendee__user__first_name',
                     'event_attendee__user__last_name', 'event_attendee__user__email',
                     'event_attendee__user__phone_number')

    def get_queryset(self):
        return AccommodationRoom.objects.all()

    def get_serializer_context(self):
        context = super().get_serializer_context()
        if self.request.data.get('event_item_uuid', None):
            context.update({"event_item": get_event_item_object(self.request.data.get('event_item_uuid', None))})
        return context

    def get_event(self):
        return get_event_object_by_uuid(self.kwargs['event_uuid'])

    def retrieve(self, request, *args, **kwargs):
        response_data = super().retrieve(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Accommodation Room Detail is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    @permission_classes(GroupWisePermission, )
    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Accommodation Room List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Accommodation Room  is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        event_item = get_event_item_object(self.request.data.get('event_item_uuid', None))
        accommodation_room = serializer.save()
        #  here we add accommodation room to event_item
        event_item.accommodation_rooms.add(accommodation_room)
        event_item.save()

    def update(self, request, *args, **kwargs):
        response_data = super().update(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Room  is edited successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def partial_update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)

# this is for single person room allocation
# @action(methods='post', detail=True, url_path='allocate-room-to-attendee')
# def allocate_room_to_attendee(self, request, *args, **kwargs):
#     accommodation_room = self.get_object()
#     accommodation_room.event_attendee = get_event_attendee_object_by_uuid(self.request.data['event_attendee_uuid'])
#     accommodation_room.save()
#     response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
#                      'message': 'Room has been allocated  successfully',
#                      'data': self.serializer_class(accommodation_room).data}
#     return Response(response_data, status=status.HTTP_200_OK)
