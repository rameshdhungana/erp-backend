from django.conf import settings
from django.db.models import F
from django_filters import rest_framework as filters
from rest_framework import status
from rest_framework.filters import SearchFilter
from rest_framework.generics import ListAPIView
from rest_framework.response import Response

from cluberpbackend.pagination import CustomPagination
from events.models import EventAttendee
from events.serializers import CreditorListSerializer
from events.utils import get_event_object_by_uuid, get_event_attendee_object_by_uuid
from orders.models import Order
from orders.utils import (get_latest_order_of_main_user,
                          get_net_positive_balance_from_latest_order)


class CreditorListView(ListAPIView, CustomPagination):
    serializer_class = CreditorListSerializer
    pagination_class = CustomPagination
    lookup_field = 'uuid'
    filter_backends = (filters.DjangoFilterBackend, SearchFilter)

    filterset_fields = ('user__first_name', 'group_type', 'registration_status')
    search_fields = (
        'user__first_name', 'user__last_name', 'user__email', 'user__phone_number', 'group_type', 'alternate_email',
        'alternate_phone_number',
        'registration_status')

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"event": get_event_object_by_uuid(self.kwargs['event_uuid'])})
        return context

    def get_queryset(self):
        """
            Return a list of all event attendees who have more  balance (whose
            latest order has net balance less than zero i.e balance greater than
            balance_credit in his/her latest order..
        """
        event = get_event_object_by_uuid(self.kwargs['event_uuid'])

        attendee_uuid_list = set(
            Order.objects.filter(event=event).filter(balance__gt=F('balance_credit')).values_list(
                'event_attendee__uuid', flat=True))
        creditor_attendee_uuid_list = []
        for uuid in attendee_uuid_list:
            attendee = get_event_attendee_object_by_uuid(uuid)
            if get_net_positive_balance_from_latest_order(
                    get_latest_order_of_main_user(attendee.user,
                                                  attendee.event)) > 0:
                creditor_attendee_uuid_list.append(uuid)
        return EventAttendee.objects.filter(uuid__in=creditor_attendee_uuid_list)

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Creditor List   is fetched successfully',

                         'data': response_data.data}, status=status.HTTP_200_OK)
