from django.conf import settings
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from events.models import EventAttendee
from events.serializers import AttendeeSerializer


class AttendeeViewSet(ModelViewSet):
    serializer_class = AttendeeSerializer
    queryset = EventAttendee.objects.all()
    pagination_class = CustomPagination
    lookup_field = 'uuid'

    @action(methods=['get'], detail=True, url_path='get-attendee-detail-for-accommodation-page')
    def get_attendee_detail_for_accommodation_page(self, request, uuid=None):
        attendee = self.get_object()
        main_attendee = self.serializer_class(self.get_object()).data

        guest_attendees = []
        for guest in EventAttendee.objects.filter(registered_by=attendee):
            guest_attendees.append(self.serializer_class(guest).data)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Attendee Detail for accommodation page is fetched successfully',
                         'data': {'main_attendee': main_attendee,
                                  'guest_attendees': guest_attendees,
                                  'number_of_attendees': len(guest_attendees) + 1}
                         }
        return Response(response_data, status=status.HTTP_200_OK)
