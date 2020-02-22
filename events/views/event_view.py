from time import strptime

import django_filters
from django.conf import settings
from django.db import transaction
from django.db.models import Q
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status, decorators
from rest_framework.authtoken.models import Token
from rest_framework.decorators import action, authentication_classes, permission_classes
from rest_framework.filters import SearchFilter
from rest_framework.permissions import IsAuthenticatedOrReadOnly, AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from events.models import (DEFAULT_EVENT_ITEM_GROUPS,
                           Event, EventCategory, EventItemGroup,
                           EventType, Organizer, EventAttendee, EventItem, TRANSPORTATION)
from events.models.event_attendee import EVENT_REGISTRATION_STATUS, CANCELED
from events.models.event_registration_type import (REGISTRATION_TYPE_STATUS,
                                                   EventRegistrationType)
from events.serializers.event_serializer import EventSerializer
from events.utils import get_event_attendee_object_by_uuid
from users.authentication import is_token_expired
from users.permissions import GroupWisePermission
from users.utils import remove_space_and_dash_from_phone_number, login_user_and_return_token


class EventFilterClass(django_filters.FilterSet):
    is_published = django_filters.BooleanFilter()
    status = django_filters.CharFilter()

    class Meta:
        model = Event
        fields = {
            'start_date': ['date__gte']
        }


class EventViewSet(ModelViewSet):
    serializer_class = EventSerializer
    pagination_class = CustomPagination
    lookup_field = 'uuid'
    filter_backends = (DjangoFilterBackend, SearchFilter)
    search_fields = ('title', 'description', 'summary', 'venue_location')
    filter_class = EventFilterClass

    def get_queryset(self):
        return Event.objects.all()

    def retrieve(self, request, *args, **kwargs):
        response_data = super().retrieve(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Detail is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    @transaction.atomic
    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event  is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        event = serializer.save()
        # we will create an EventRegistrationType (public type) object with creation of any event
        event_registration_type_data = {'name': 'PUBLIC', 'event': event,
                                        'status': dict(REGISTRATION_TYPE_STATUS).get('Testing'),
                                        'is_public': True}
        event_registration_type, created = EventRegistrationType.objects.get_or_create(**event_registration_type_data)

        # now we are creating default object for the eventItemGroup ie. registration, accommodation,transportation
        print(event.id)
        event_item_group_data = [
            {'name': dict(DEFAULT_EVENT_ITEM_GROUPS).get('Registration'),
             'slug': dict(DEFAULT_EVENT_ITEM_GROUPS).get('Registration'),
             'is_multi_select': False,
             'event': event,
             'event_registration_type': event_registration_type

             },

            {'name': dict(DEFAULT_EVENT_ITEM_GROUPS).get('Accommodation'),
             'slug': dict(DEFAULT_EVENT_ITEM_GROUPS).get('Accommodation'),
             'is_multi_select': False,
             'event': event,
             'event_registration_type': event_registration_type
             },

            {'name': dict(DEFAULT_EVENT_ITEM_GROUPS).get('Transportation'),
             'slug': dict(DEFAULT_EVENT_ITEM_GROUPS).get('Transportation'),
             'is_multi_select': True,
             'event': event,
             'event_registration_type': event_registration_type

             },
        ]

        for data in event_item_group_data:
            event_item_group, created = EventItemGroup.objects.get_or_create(**data)

    # @action(methods=['GET'], detail=False, url_path='approved')
    # def approved(self, request, *args, **kwargs):
    #     queryset = self.queryset.filter(is_published=True)
    #
    #     serializer = self.get_serializer(queryset, many=True)
    #     response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
    #                      'message': 'Approved Event List is fetched successfully',
    #                      'data': serializer.data}
    #     return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], detail=True, url_path='get-event-timezone')
    def get_event_time_zone(self, request, event_uuid=None, uuid=None):
        event = self.get_object()
        data = {'timezone': event.timezone}
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event timezone is fetched successfully',
                         'data': data}
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], detail=True, url_path='get-transportation-item-master-name-list')
    def get_transportation_item_master_name_list(self, request, event_uuid=None, uuid=None):
        event = self.get_object()
        item_master_name_list = EventItem.objects.filter(event=event,
                                                         group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(
                                                             TRANSPORTATION)).values_list(
            'item_master__name', flat=True)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Transportation Item Master Name List is fetched successfully',
                         'data': item_master_name_list}
        return Response(response_data, status=status.HTTP_200_OK)

    # @action(methods=['GET'], detail=True, url_path='get-event-start-date-end-date-timezone')
    # def get_event_start__date_end_date_timezone(self, request, event_uuid=None, uuid=None):
    #     event = self.get_object()
    #     data = {'timezone': event.timezone,
    #             'start_date': event.start_date,
    #             'end_date': event.end_date}
    #
    #     response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
    #                      'message': 'Event start date, end date ,timezone  is fetched successfully',
    #                      'data': data}
    #     return Response(response_data, status=status.HTTP_200_OK)

    # ------------------------- start of order API  related to event -------------------------------------#

    @action(methods=['post'], detail=True, url_path='order-login')
    def check_order_login_credentials(self, request, uuid=None):
        event = self.get_object()
        if request.data.get('email', None):
            filter_param = Q(user__email=request.data['email'].strip())
        else:
            phone_number = remove_space_and_dash_from_phone_number(request.data['phone_number']['internationalNumber'])
            filter_param = Q(
                user__phone_number=phone_number)

        #  strip is made to avoid space in confirmation codes when is copy pasted
        attendee_queryset = EventAttendee.objects.exclude(
            registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED)).filter(
            confirmation_code=request.data['confirmation_code'].strip(), event=event).filter(
            filter_param)
        # if query return only one attendee , then request data is valid ,else invalid
        #  if 0 , object with request data does not exits or greater than 1 , multiple results
        # obtained but we do not know which one to provide in response
        if len(attendee_queryset) == 1:
            attendee = attendee_queryset.first()
            token = login_user_and_return_token(request, attendee)
            if token:

                response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                                 'message': 'Order Login credentials are  correct.',
                                 'data': {'attendee_uuid': attendee.uuid,
                                          'key': token,
                                          'confirmation_code': attendee.confirmation_code
                                          }
                                 }
            else:
                response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                                 'message': 'InValid Order Login credentials',
                                 }

        else:

            response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                             'message': 'InValid Order Login credentials',
                             }

        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['post'], detail=True, url_path='validate-order-login-confirmation-code')
    def validate_order_login_confirmation_code(self, request, uuid=None):
        attendee_uuid = request.data.get('attendee_uuid', None)
        confirmation_code = request.data.get('confirmation_code', None)
        if attendee_uuid and confirmation_code:
            event_attendee = get_event_attendee_object_by_uuid(attendee_uuid)
            if event_attendee.confirmation_code == confirmation_code and event_attendee.registration_status != dict(
                    EVENT_REGISTRATION_STATUS).get(CANCELED):
                token = Token.objects.get(user=event_attendee.user)
                if token:
                    expired = is_token_expired(token)
                    if expired:
                        token.delete()
                        Token.objects.create(user=token.user)
                        response_data = {'code': getattr(settings, 'ERROR_CODE', 0),

                                         'message': 'Session has expired.',
                                         }
                    else:

                        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                                         'message': 'Order Login credentials are  correct.',
                                         'data': {'attendee_uuid': attendee_uuid,
                                                  'key': token.key
                                                  }
                                         }

                else:
                    response_data = {'code': getattr(settings, 'ERROR_CODE', 0),

                                     'message': 'Invalid Token.',
                                     }


            else:
                response_data = {'code': getattr(settings, 'ERROR_CODE', 0),

                                 'message': 'InValid Order Login credentials',
                                 }

        else:
            response_data = {'code': getattr(settings, 'ERROR_CODE', 0),

                             'message': 'InValid Order Login credentials',
                             }

        return Response(response_data, status=status.HTTP_200_OK)
