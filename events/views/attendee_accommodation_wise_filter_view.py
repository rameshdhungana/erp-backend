from django.conf import settings
from rest_framework import status
from rest_framework.generics import ListAPIView
from rest_framework.response import Response

from cluberpbackend.pagination import CustomPagination
from events.models import EventAttendee, EVENT_REGISTRATION_STATUS, CONFIRMED
from events.serializers import EventAttendeeSerializer
from events.utils import get_event_object_by_uuid, get_event_item_object
from orders.models import OrderedItem


class AttendeeAccommodationWiseFilterView(ListAPIView, CustomPagination):
    serializer_class = EventAttendeeSerializer
    pagination_class = CustomPagination
    lookup_field = 'uuid'

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"event": get_event_object_by_uuid(self.kwargs['event_uuid'])})
        return context

    def get_queryset(self):
        """
            Return a list of all event attendees who have been registered to given
            accommodation item obtained from request data..
        """
        event = get_event_object_by_uuid(self.kwargs['event_uuid'])
        event_item = get_event_item_object(self.request.query_params.get('event_item_uuid'))

        main_attendee_uuid_list = OrderedItem.objects.filter(
            event_attendee__in=EventAttendee.objects.filter(event=event)).filter(event_item=event_item).values_list(
            'event_attendee__uuid', flat=True)

        return EventAttendee.objects.filter(registered_by__uuid__in=main_attendee_uuid_list).filter(
            registration_status=dict(EVENT_REGISTRATION_STATUS).get(CONFIRMED)).order_by('created_at')

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Creditor List   is fetched successfully',

                         'data': response_data.data}, status=status.HTTP_200_OK)
