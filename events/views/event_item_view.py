import math

from django.db.models import Q

from events.serializers.event_attendee_serializer import EventAttendeeWithJustUserInformationSerializer

try:
    from io import BytesIO as IO  # for modern python
except ImportError:
    from io import StringIO as IO  # for legacy python

import pandas as pd
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.filters import SearchFilter
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from cluberpbackend.pagination import CustomPagination
from events.models import (ACCOMMODATION, BOTH, DEFAULT_EVENT_ITEM_GROUPS,
                           ITEM_GROUP_TYPE_CHOICES, OFFSITE, ONSITE,
                           REGISTRATION, Event, EventItem, TRANSPORTATION, EventAttendee, ExcelUploadLog,
                           ACCOMMODATION_ROOM_ALLOCATION, AccommodationRoom, ACCOMMODATION_ROOM_CREATION)
from events.serializers import EventItemSerializer, EventAttendeeSerializer
from events.utils import get_event_object_by_uuid, get_event_item_object_by_id
from orders.models import OrderedItem, ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE


class EventItemViewSet(ModelViewSet):
    serializer_class = EventItemSerializer
    lookup_field = 'uuid'
    pagination_class = CustomPagination
    filter_backends = (DjangoFilterBackend, SearchFilter)
    filter_fields = ('item_sharing_count', 'group_type', 'group__name', 'items_booked', 'item_master__name')
    search_fields = ('item_sharing_count', 'group_type', 'group__name', 'items_booked', 'item_master__name')

    def get_event(self):
        return get_event_object_by_uuid(self.kwargs['event_uuid'])

    def get_queryset(self):
        return EventItem.objects.filter(item_capacity__gte=1, event__uuid=self.kwargs['event_uuid'])

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"event": get_event_object_by_uuid(self.kwargs['event_uuid'])})
        return context

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item List is fetched successfully',
                         'data': response_data.data}

        return Response(response_data, status=status.HTTP_200_OK)

    def retrieve(self, request, *args, **kwargs):
        response_data = super().retrieve(request, *args, **kwargs)

        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item Detail is fetched successfully',
                         'data': response_data.data})

    def create(self, request, *args, **kwargs):
        response_data = super().create(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item  is created successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def perform_create(self, serializer):
        try:
            event = Event.objects.get(uuid=self.kwargs['event_uuid'])
            serializer.save(event=event)
        except ObjectDoesNotExist as e:
            raise Exception(e)

    def update(self, request, *args, **kwargs):
        response_data = super().update(request, *args, **kwargs)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event  is edited successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def partial_update(self, request, *args, **kwargs):
        kwargs['partial'] = True
        return self.update(request, *args, **kwargs)

    @action(methods=['GET'], detail=False, url_path='get-available-accommodation-sharing-list')
    def get_available_accommodation_sharing_list(self, request, *args, **kwargs):
        data = self.get_queryset().filter(group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(ONSITE),
                                          group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)
                                          ).values('item_sharing_count')
        count_list = [value['item_sharing_count'] - 1 for value in data]

        count_list.append(0)
        count_list = list(set(count_list))

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Available accommodation sharing list fetched successfully',
                         'data': count_list
                         }
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], detail=False, url_path='accommodation-item-sharing-count-list')
    def accommodation_item_sharing_count_list(self, request, *args, **kwargs):
        data = self.get_queryset().filter(group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(ONSITE),
                                          group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)
                                          ).values('item_sharing_count')
        count_list = [value['item_sharing_count'] for value in data]

        count_list = list(set(count_list))

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Available accommodation sharing list fetched successfully',
                         'data': count_list
                         }
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], detail=False, url_path='get-offsite-daypass-registration-items')
    def get_offsite_daypass_registration_items(self, request, *args, **kwargs):
        data = self.get_queryset().filter(group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION),
                                          group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(OFFSITE), is_day_pass_item=True
                                          )

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'OffSite day pass registration items list fetched successfully',
                         'data': EventItemSerializer((item for item in data), many=True).data
                         }
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], detail=False, url_path='get-all-days-registration-items')
    def get_all_days_registration_items(self, request, *args, **kwargs):
        items = self.get_queryset().filter(group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION),
                                           group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(BOTH), is_day_pass_item=False
                                           )
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'All days  registrations item list fetched successfully',
                         'data': [EventItemSerializer(items.first()).data]
                         }
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['GET'], detail=True, url_path='get-attendee-list-for-room-allocation')
    def get_attendee_list_for_room_allocation(self, request, *args, **kwargs):
        event_item = self.get_object()
        #  here we only get active SALE TYPE ordered_items
        to_exclude_event_attendee_id = event_item.accommodation_rooms.filter(event_attendee__isnull=False).values_list(
            'event_attendee__id', flat=True)
        ordered_items = OrderedItem.objects.select_related('event_attendee').filter(
            event_item=event_item,
            transaction_type=dict(
                ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                SALE))

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Attendee List for room allocation is  fetched successfully',
                         'data': EventAttendeeWithJustUserInformationSerializer(
                             (data.event_attendee for data in ordered_items if not
                             data.event_attendee.id in to_exclude_event_attendee_id),
                             many=True).data}

        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['post'], detail=True, url_path='upload-room-allocation-excel-sheet')
    def upload_room_allocation_excel_sheet(self, request, *args, **kwargs):
        excel_sheet_name = request.FILES['excel_sheet']
        df = pd.read_excel(excel_sheet_name)
        [event_item_column_name, room_number_column_name, event_attendee_column_name] = df.columns
        final_result = []
        total_processing = 0
        total_success = 0
        total_failure = 0
        for index, row in df.iterrows():
            total_processing = total_processing + 1
            data = {event_item_column_name: row[event_item_column_name],
                    room_number_column_name: row[room_number_column_name],
                    event_attendee_column_name: '' if math.isnan(row[event_attendee_column_name]) else
                    row[event_attendee_column_name],
                    'status': '',
                    'failure_reason': '',
                    }
            try:
                event_item = EventItem.objects.get(id=row[event_item_column_name])
                #  we need to check if item_capacity for room creation has exceeded or not
                if event_item.accommodation_rooms.filter(
                        event_attendee__isnull=False).count() < event_item.item_capacity:

                    try:
                        room = event_item.accommodation_rooms.get(room_number=row[room_number_column_name])

                        try:
                            attendee_param = Q(id=row[event_attendee_column_name]) | Q(
                                confirmation_code=row[event_attendee_column_name]) | Q(
                                user__email=row[event_attendee_column_name]) | Q(
                                user__phone_number=row[event_attendee_column_name])
                            event_attendee = EventAttendee.objects.get(attendee_param)

                            try:
                                #  we need to find out if ordered_item with SALE type transaction exists for given
                                # event_item and event_attendee
                                OrderedItem.objects.get(event_attendee=event_attendee,
                                                        event_item=event_item, transaction_type=dict(
                                        ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE))

                                #     first we check if the room has already been allocated for others
                                if room.event_attendee:
                                    data['status'] = 'Failed'
                                    data['failure_reason'] = 'This room has been already allocated to other attendee.'


                                else:
                                    #     finally data is now valid for further processing
                                    # now we need to update the event_attendee field by event_attendee
                                    room.event_attendee = event_attendee
                                    room.save()
                                    total_success = total_success + 1
                                    data['total_success'] = 'Success'
                                    data['failure_reason'] = ''
                            except:

                                data['status'] = 'Failed'
                                data['failure_reason'] = 'This attendee has not booked this room type.'
                                total_failure = total_failure + 1
                        except:

                            data['status'] = 'Failed'
                            data['failure_reason'] = 'Event Attendee with provided id  does not exits.'
                            total_failure = total_failure + 1
                    except:

                        data['status'] = 'Failed'
                        data['failure_reason'] = 'Given Room Number does not exits for given room type.'
                        total_failure = total_failure + 1
                else:
                    data['status'] = 'Failed'
                    data['failure_reason'] = 'Total room capacity for this room type has exceeded its capacity.'
                    total_failure = total_failure + 1
            except:

                data['status'] = 'Failed'
                data['failure_reason'] = 'Room Type with provided id does not exist.'
                total_failure = total_failure + 1

            final_result.append(data)
        # now we need to create exceluplog instance to keep track of the looger
        ExcelUploadLog.objects.create(type=ACCOMMODATION_ROOM_ALLOCATION, total_success=total_success,
                                      total_failure=total_failure, total_processing=total_processing,
                                      created_by=request.user.id)

        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Room Allocation through excel sheet upload is done successfully',
                         'data': {'excel_data': final_result, 'total_processing': total_processing,
                                  'total_success': total_success, 'total_failure': total_failure}
                         }, status=status.HTTP_200_OK
                        )

    @action(methods=['get'], detail=True, url_path='download-empty-excel-sheet-for-room-allocation')
    def download_empty_excel_sheet_for_room_allocation(self, request, *args, **kwargs):
        event_item = self.get_object()
        accommodation_rooms = event_item.accommodation_rooms.filter(
            event_attendee__isnull=True)
        final_data = []
        for room in accommodation_rooms:
            final_data.append(
                {'Room Type ({})'.format(event_item.item_master.name): event_item.id,
                 'Room Number': room.room_number,
                 'Attendee Id': None})

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Empty excel sheet for accommodation fetched successfully',
                         'data': final_data
                         }
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['post'], detail=True, url_path='upload-room-creation-excel-sheet')
    def upload_room_creation_excel_sheet(self, request, *args, **kwargs):
        event_item = self.get_object()
        excel_sheet_name = request.FILES['excel_sheet']
        df = pd.read_excel(excel_sheet_name)
        #  here we use set to avoid duplicate room number entry from excel sheet
        room_number_list = set(df.iloc[:, 0])  # first column of data frame (room_number)
        final_result = []
        total_success = 0
        total_failure = 0
        total_processing = 0
        for room_number in room_number_list:
            data = {'room_number': room_number,
                    'status': '',
                    'failure_reason': '',
                    }
            #  first check if the item_capacity has been crossed.
            if event_item.accommodation_rooms.all().count() < event_item.item_capacity:
                #     this means room capacity has not been crossed
                #     now we check if room with given room_number already exits
                if event_item.accommodation_rooms.filter(room_number=room_number).exists():
                    data['status'] = 'Failed'
                    data['failure_reason'] = 'Room with this room number already exists for this room type.'
                    total_failure = total_failure + 1
                else:
                    #        room number for event_item is new , hence create it
                    accommodation_room = AccommodationRoom.objects.create(room_number=room_number)
                    event_item.accommodation_rooms.add(accommodation_room)
                    event_item.save()
                    total_success = total_success + 1
                    data['status'] = 'Success'
            else:
                # this means the item capacity has been met and no more rooms are to be created
                data['status'] = 'Failed'
                data['failure_reason'] = 'Total capacity for this room type  has already exceeded.'
                total_failure = total_failure + 1

            # update the final_result
            final_result.append(data)

        # now we need to create exceluplog instance to keep track of the looger
        ExcelUploadLog.objects.create(type=ACCOMMODATION_ROOM_CREATION, total_success=total_success,
                                      total_failure=total_failure, total_processing=total_processing,
                                      created_by=request.user.id)

        return Response({'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Room creation through excel sheet upload is done successfully',
                         'data': {'excel_data': final_result, 'total_processing': total_processing,
                                  'total_success': total_success, 'total_failure': total_failure}
                         }, status=status.HTTP_200_OK
                        )
