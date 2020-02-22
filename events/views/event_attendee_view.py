import smtplib

from django.conf import settings
from django.contrib.auth.models import Group
from django.core.exceptions import ObjectDoesNotExist
from django.db import transaction
from django.db.models import Q
from rest_framework import status
from django_filters import rest_framework as filters
from rest_framework.filters import SearchFilter
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from carts.models import ItemCart
from carts.serializers import ItemCartSerializer
from carts.utils import (
    create_canceled_cart_item_from_ordered_item,
    get_event_ordered_items_and_cart_item_combined_category_wise, get_attendee_cart_related_dict)
from cluberpbackend.pagination import CustomPagination
from events.models import (Event, EventAttendee, EventRegistrationType, DEFAULT_EVENT_ITEM_GROUPS,
                           REGISTRATION, ACCOMMODATION, TRANSPORTATION, ONSITE,
                           ITEM_GROUP_TYPE_CHOICES, OFFSITE, BOTH, EVENT_REGISTRATION_STATUS, INITIATED, CANCELED,
                           ACCOMMODATION_GROUP_TYPE_CHOICES, EventItem)
from events.models.event_attendee import CONFIRMED
from events.serializers import (EventAttendeeSerializer, AttendeeUserSerializer,
                                EventItemSerializer, EventAttendeeOptimizedSerializer)
from events.utils import (
    get_event_item_object, get_event_object,
    get_public_event_registration_type_object,
    update_confirmation_code_for_attendee, get_confirmation_code_for_attendees,
    get_main_attendee_of_given_attendee,

    get_all_attendees, get_guest_attendees,
    update_group_type_field_of_event_attendee,
    update_transportation_info_of_transportation_event_item,
    generate_choose_accommodation_type_link, generate_event_order_login_link,
    validate_smart_card_number, get_event_object_by_uuid)
from events.utils.event_attendee_util import (get_event_attendee_object_by_uuid, get_attendee_related_data,
                                              update_registration_status_of_attendee, get_event_attendee_object_by_id,
                                              get_number_of_attendees_registered_by_main_attendee)
from items.tasks import send_email_to_all_attendees_with_order_summary
from orders.models import (
    ORDER_ITEM_TRANSACTION_TYPE_CHOICES, SALE, CANCEL)

from orders.utils import (get_all_active_ordered_items_of_main_user, get_active_items_of_order,
                          perform_order_confirmation, get_latest_order_of_main_user,
                          get_all_orders_of_main_user,
                          get_active_items_of_order_and_changed_items_of_cart, get_all_active_ordered_items_of_user,
                          check_if_ordered_items_contains_item_with_given_query_param)
from carts.utils import (get_all_cart_items_of_main_user,
                         get_basic_cart_dict_from_event_item,
                         get_basic_cart_item_dict_for_main_user,
                         get_cart_item_dict_for_user, maintain_only_changed_items_in_cart_in_order_edit,
                         perform_operations_on_cart_items_for_cart_summary, create_event_item_cart,
                         delete_all_cart_items_of_main_user, hard_delete_item_cart)
from orders.utils.order_util import get_cancelled_items_of_order
from users.models import User, GENDER_CHOICES, NOT_SPECIFIED
from users.utils import (generate_dummy_email, generate_dummy_phone_number,
                         generate_usercode, remove_space_and_dash_from_phone_number, check_if_email_is_dummy)


class EventAttendeeViewSet(ModelViewSet):
    serializer_class = EventAttendeeOptimizedSerializer
    pagination_class = CustomPagination
    lookup_field = 'uuid'
    filter_backends = (filters.DjangoFilterBackend, SearchFilter)

    filterset_fields = ('user__first_name', 'group_type', 'registration_status')
    search_fields = (
        'user__first_name', 'user__last_name', 'user__email', 'user__phone_number', 'group_type', 'alternate_email',
        'alternate_phone_number',
        'registration_status')

    invalid_user_data_collection = []

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context.update({"event": get_event_object_by_uuid(self.kwargs['event_uuid'])})
        return context

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Attendee List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def get_queryset(self):
        return EventAttendee.objects.filter(event__uuid=self.kwargs['event_uuid'])

    # ------------------------------start of registration related APIs-------------------------------#

    def validate_guest_data_to_prevent_same_email_or_phone_number(self, main_attendee, additional_guests):
        if len(additional_guests) > 1:
            guest_email_list = []
            guest_phone_number_list = []
            for extra_guest in additional_guests:
                guest_user_data = self.get_user_related_data(extra_guest)
                if guest_user_data['email'] != main_attendee.user.email:
                    guest_email_list.append(guest_user_data['email'])
                if guest_user_data['phone_number'] != main_attendee.user.phone_number:
                    guest_phone_number_list.append(guest_user_data['phone_number'])
            if len(guest_email_list) > len(set(guest_email_list)):
                self.invalid_user_data_collection.append(
                    {'message': "Same email can not be used for  multiple guests ! Please review guest's emails.",
                     'status': 'INVALID'}
                )
                return None
            if len(guest_phone_number_list) > len(set(guest_phone_number_list)):
                self.invalid_user_data_collection.append(
                    {
                        'message': "Same Mobile Number can not be used for multiple guests! Please review "
                                   "guest's Mobile Numbers. ",
                        'status': 'INVALID'}
                )
                return None
        return True

    def validate_user_data(self, user_data, registrant_type=None, main_registrant_attendee=None,
                           already_registered_event_attendee_id=None):
        user_serializer = AttendeeUserSerializer(data=user_data)
        user_serializer.is_valid(raise_exception=True)
        user_manager = User.objects
        """ 
        we first check if user with phone_number from form data exits, if yes we check if both first_name 
        and last_name are same for that exiting user. If Yes we get valid user.Otherwise we return None.
        """
        user = user_manager.filter(phone_number=user_data['phone_number']).first()
        if user:
            if user.first_name.lower() == user_data['first_name'].lower().strip() and \
                    user.last_name.lower() == user_data['last_name'].lower().strip():

                # if user already exits we need to check if user has been already registered for the event
                [user, event_attendee] = self.validate_if_user_already_registered_for_event(user, 'phone_number',
                                                                                            registrant_type,
                                                                                            main_registrant_attendee)

                # second parameter is to indicate if user is new_user or already exiting, hence False fot this case
                return [user, False, event_attendee]
            else:
                if registrant_type == 'main_user':
                    self.invalid_user_data_collection.append(
                        {'message': "It seems like {} is already associated with another account profile".format(
                            user_data['phone_number']),
                            'status': 'INVALID'})
                    return [None, None, None]
                else:
                    try:
                        event = Event.objects.get(uuid=self.kwargs['event_uuid'])
                    except ObjectDoesNotExist as e:
                        raise Exception(e)
                    event_attendee_queryset = EventAttendee.objects.filter(event=event, user=user)
                    if event_attendee_queryset:
                        event_attendee = event_attendee_queryset.first()
                        main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(
                            event_attendee)
                        # if phone_number entered for guest attendee is same as that entered for main_attendee
                        #  its valid , hence we return valid user
                        if main_attendee == main_registrant_attendee:
                            if not is_main_attendee:
                                if event_attendee.user.phone_number == main_attendee.user.phone_number or \
                                        (event_attendee.registered_by == main_attendee and
                                         event_attendee.user.phone_number == user_data['phone_number']):
                                    return user, False, event_attendee
                            else:
                                # this means phone_number for guest is same as main_attendee, which means
                                # either : we need to create user with new data and send event_attendee as None
                                # Or find out  if form is resubmiited and event_attendee already exits then
                                # we need to find the user whose alternative_phone is main_attendees's phone number
                                if already_registered_event_attendee_id:
                                    attendee_already = get_event_attendee_object_by_id(
                                        already_registered_event_attendee_id)
                                    # when attendee is already registered but is resubmmited,
                                    return attendee_already.user, False, attendee_already
                                else:
                                    # first is run when no attendee for main_attendee is registered, in this case
                                    # create user and attendee
                                    user = User(**user_data)
                                    return [user, True, None]



                        else:
                            self.invalid_user_data_collection.append(
                                {
                                    'message': "It seems like {} is already associated with another account profile".format(
                                        user_data['phone_number']),
                                    'status': 'INVALID'})
                            return [None, None, None]
                    return [None, None, None]
        """ 
        If phone_number already does not exit, we check for email. If yes , we validate with 
        first_name and last_name . If email, first_name,last_name match , we get valid user. 
        Otherwise we return None.
        """
        user = user_manager.filter(email=user_data['email']).first()
        if user:
            if user.first_name.lower() == user_data['first_name'].lower().strip() and \
                    user.last_name.lower() == user_data['last_name'].lower().strip():

                # if user already exits we need to check if user has been already registered for the event
                [user, event_attendee] = self.validate_if_user_already_registered_for_event(user, 'email',
                                                                                            registrant_type,
                                                                                            main_registrant_attendee)

                # second parameter is to indicate if user is new_user or already exiting, hence False fot this case
                return [user, False, event_attendee]
            else:
                if registrant_type == 'main_user':
                    self.invalid_user_data_collection.append(
                        {'message': "It seems like {} is already associated with another account profile".format(
                            user_data['email']),
                            'status': 'INVALID'})
                    return [None, None, None]
                else:
                    try:
                        event = Event.objects.get(uuid=self.kwargs['event_uuid'])
                    except ObjectDoesNotExist as e:
                        raise Exception(e)
                    event_attendee_queryset = EventAttendee.objects.filter(event=event, user=user)
                    if event_attendee_queryset:
                        event_attendee = event_attendee_queryset.first()
                        main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(
                            event_attendee)
                        # if email entered for guest attendee is same as that entered for main_attendee
                        #  its valid , hence we return valid user
                        # if main_attendee of event_attendee is  main_registrant_attendee , guest attendee resubmitted
                        # with first_name or last_name changed but email same
                        if main_attendee == main_registrant_attendee:
                            if not is_main_attendee:
                                # guest data is resubmitted
                                if event_attendee.user.email == main_attendee.user.email or \
                                        (event_attendee.registered_by == main_attendee and event_attendee.user.email ==
                                         user_data['email']):
                                    return user, False, event_attendee
                            else:
                                # this means phone_number for guest is same as main_attendee, which means
                                # either : we need to create user with new data and send event_attendee as None
                                # Or find out  if form is resubmiited and event_attendee already exits then
                                # we need to find the user whose alternative_phone is main_attendees's phone number
                                if already_registered_event_attendee_id:
                                    attendee_already = get_event_attendee_object_by_id(
                                        already_registered_event_attendee_id)
                                    # when attendee is already registered but is resubmmited,
                                    return attendee_already.user, False, attendee_already
                                else:
                                    # first is run when no attendee for main_attendee is registered, in this case
                                    # create user and attendee
                                    user = User(**user_data)
                                    return [user, True, None]
                        else:
                            self.invalid_user_data_collection.append(
                                {
                                    'message': "It seems like {} is already associated with another account profile".format(
                                        user_data['email']),
                                    'status': 'INVALID'})
                            return [None, None, None]
                    return [None, None, None]
        """if user with both email or phone does not exist , this is new data thus we initializer  User Model with these 
        user_data and save it later at once
        """
        user = User(**user_data)
        return [user, True, None]

    def validate_if_user_already_registered_for_event(self, user, field_type, registrant_type,
                                                      main_registrant_attendee):

        try:
            event = Event.objects.get(uuid=self.kwargs['event_uuid'])
        except ObjectDoesNotExist as e:
            raise Exception(e)
        event_registration_type, created = EventRegistrationType.objects.get_or_create(event=event,
                                                                                       is_public=True)
        event_attendee = EventAttendee.objects.filter(event=event, user=user)
        if event_attendee:
            invalid_data_response = {}
            event_attendee = event_attendee.first()
            main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(event_attendee)
            if registrant_type == 'main_user':
                # if the main_attendee  event_registration_status is confirmed , we send the link to order login
                # else if not confirmed  , we send the accommodation-type link
                if is_main_attendee and main_attendee.registration_status == dict(
                        EVENT_REGISTRATION_STATUS).get(CONFIRMED):
                    # change the link here to view the registration detail
                    invalid_data_response.update({'link': generate_event_order_login_link(event),
                                                  'message': "It seems like you have already registered for this event."
                                                             " Please click on link below to view:",
                                                  'status': 'ALREADY'
                                                  })
                else:
                    invalid_data_response.update(
                        {'link': generate_choose_accommodation_type_link(event, main_attendee),
                         'message': "It seems like you have already registered for this event."
                                    " Please click on link below to view:",
                         'status': 'ALREADY'
                         })

                self.invalid_user_data_collection.append(invalid_data_response)

                # user is also None, attendee is also None , which means validation error
                return None, None
            else:
                # we event_attendee with given data exists but is registered by  main_attendee , we need to update
                # other data keeping the event_attendee object same, hence we return the event_attendee object
                # else if not registered by main_attendee but attendee exists we need to send back error message

                # first prevent main_attendee's data validation data to be reentered in guest form
                # if he/she has not entered same data in guest form as well
                if not is_main_attendee and event_attendee.registered_by == main_registrant_attendee:

                    return [user, event_attendee]
                else:

                    invalid_data_response.update({
                        'message': 'It seems like  {} have already registered'.format(
                            user.email if field_type == 'email' else user.phone_number),
                        'status': 'INVALID'
                    })
                    self.invalid_user_data_collection.append(invalid_data_response)

                    return [None, None]

        else:
            return [user, None]

    @staticmethod
    def get_user_related_data(data):
        user_dict = {
            'username': generate_usercode(),
            'first_name': data['first_name'].strip(),
            'last_name': data['last_name'].strip(),
            'email': data.get('email', None),
            'phone_number': remove_space_and_dash_from_phone_number(data['phone_number']['internationalNumber']),
            'country': data['country'],
            'city': data['city'],
            'gender': dict(GENDER_CHOICES).get(NOT_SPECIFIED),
            'is_active': True,
        }
        if user_dict['email'] is None:
            user_dict['email'] = generate_dummy_email()
        return user_dict

    def save_user(self, user, user_data, is_new_user):
        if is_new_user:
            user.save()
        else:
            # we main_user in already existing , we update following information from current request data
            user.first_name = user_data['first_name']
            user.last_name = user_data['last_name']
            user.phone_number = user_data['phone_number']
            user.email = user_data['email']
            user.country = user_data['country']
            user.city = user_data['city']
            user.save()
        # now we add user to Attendee Group
        attendee_group, created = Group.objects.get_or_create(name='Attendee')
        user.groups.add(attendee_group)
        user.set_password(getattr(settings, 'DEFAULT_PASSWORD'))
        user.save()
        return user

    def create_event_attendee(self, request, attendee_data, already_registered_event_attendee=None):
        # now We get Event Object for which registration is happening
        event = get_event_object(self.kwargs['event_uuid'])
        event_registration_type = get_public_event_registration_type_object(event)
        # if already_registered_event_attendee is not None, we need to update the value obtained for event attendee
        # else we need to create new event_attendee
        if already_registered_event_attendee:
            already_registered_event_attendee.smart_card_number = attendee_data.get('smart_card_number', '')
            already_registered_event_attendee.name_in_smart_card = attendee_data.get('name_in_smart_card', '')
            already_registered_event_attendee.is_senior_citizen = attendee_data['is_senior_citizen']
            already_registered_event_attendee.is_pwk = attendee_data['is_pwk']
            already_registered_event_attendee.save()
            return already_registered_event_attendee
        else:
            attendee_data.update({'event': event, 'event_registration_type': event_registration_type,
                                  'group_type': request.data.get('group_type', ''),
                                  'registration_status': dict(EVENT_REGISTRATION_STATUS).get(INITIATED)})
            return EventAttendee.objects.create(**attendee_data)

    @action(methods=['get'], detail=True, url_path='get-already-registered-guest-attendees')
    def get_already_registered_guest_attendees(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        group_type = main_attendee.group_type

        if main_attendee.changed_to_onsite:
            data = {'changed_to_onsite': True}
        else:

            registration_cart_items = ItemCart.objects.filter(event=event, ordered_by_attendee=main_attendee,
                                                              event_item__group__name=dict(
                                                                  DEFAULT_EVENT_ITEM_GROUPS).get(
                                                                  REGISTRATION))
            if group_type == dict(ACCOMMODATION_GROUP_TYPE_CHOICES).get(ONSITE):
                # this means his/her accommodation group_type is onsite
                # hence , guest attendees ( if registered) needs to be provided
                guest_attendees = get_guest_attendees(main_attendee, event)
                guest_attendees_serialized_data = EventAttendeeOptimizedSerializer(guest_attendees,
                                                                                   many=True,
                                                                                   context={'event': event}).data

                data = {'guest_attendees': guest_attendees_serialized_data,
                        'registration_cart_items': EventItemSerializer(
                            (item.event_item for item in registration_cart_items),
                            many=True).data if registration_cart_items else [],
                        'group_type': group_type,
                        'number_of_guest_attendees': len(guest_attendees)}

            elif group_type == dict(ACCOMMODATION_GROUP_TYPE_CHOICES).get(OFFSITE):
                # this means his/her accommodation group_type is offsite
                # hence , offsite_type ( day_pass or all_days) along with these
                # selected items needs to be provided

                # first we check if the all day registration (both type) item exist in cart for given
                # main_attendee , if yes  we it means all_days type was selected else day pass items were selected
                if registration_cart_items.filter(event_item__group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(BOTH)):
                    offsite_stay_type = 'all_days'
                else:
                    offsite_stay_type = 'day_pass'
                data = {
                    'registration_cart_items': EventItemSerializer(
                        (item.event_item for item in registration_cart_items),
                        many=True).data,
                    'group_type': group_type,
                    'offsite_stay_type': offsite_stay_type

                }
            else:
                #     this means group_type of main_attendee has not yet been updated, in case of just after personnnel
                # detail registration and no back and forth
                data = {'group_type': group_type}

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Already registered guest attendees fetched successfully',
                         'data': data
                         }
        return Response(response_data, status=status.HTTP_200_OK)

    @transaction.atomic
    def create(self, request, *args, **kwargs):
        self.invalid_user_data_collection = []
        event = get_event_object(self.kwargs['event_uuid'])

        main_user_data = self.get_user_related_data(request.data)

        # check if main attendee's smart card is valid
        main_attendee_smart_card_number_valid = validate_smart_card_number(request.data['smart_card_number'])

        [main_user, is_new_main_user, already_registered_event_attendee] = self.validate_user_data(main_user_data,
                                                                                                   'main_user')

        if main_user and main_attendee_smart_card_number_valid:

            user = self.save_user(main_user, main_user_data, is_new_main_user)

            # now we create Attendee object for main user
            main_attendee_data = get_attendee_related_data(request.data)
            main_attendee_data.update({'user': user})
            main_attendee = self.create_event_attendee(request, main_attendee_data)
            # update the registered by field for main_attendee
            main_attendee.registered_by = main_attendee
            main_attendee.save()

            response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                             'message': 'Event Attendee is created  successfully',
                             'data': {'main_attendee_uuid': main_attendee.uuid}}
        else:
            response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                             'message': 'Personnel Detail Validation error occurred',
                             'data': self.invalid_user_data_collection}

        return Response(response_data, status=status.HTTP_200_OK)

    @staticmethod
    def perform_action_if_registration_is_changed_to_onsite(request, main_attendee, event):
        order_queryset = get_all_orders_of_main_user(main_attendee.user, event)
        #  we here filter registration , accommodation and transportation items
        filter_param = (Q(event_item__group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(OFFSITE))
                        )
        ordered_items_base_queryset = get_all_active_ordered_items_of_main_user(order_queryset).filter(
            filter_param)
        for ordered_item in ordered_items_base_queryset:
            # then we create CANCEL type cart items from all ordered_items_base_queryset as only onsite
            # registration item is excluded here
            create_canceled_cart_item_from_ordered_item(ordered_item, main_attendee, event,
                                                        is_canceled_item=True)
        # now we check if the onsite all days (both) type conference ticket already exists for
        #     main_attendee , if yes we do nothing, if not we need to create item cart
        if not check_if_ordered_items_contains_item_with_given_query_param(
                Q(event_attendee=main_attendee,
                  event_item__group__name=dict(
                      DEFAULT_EVENT_ITEM_GROUPS).get(
                      REGISTRATION), event_item__group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(BOTH))):
            # we main_attendee is passed separately to update the ordered_by_attendee field in cart item
            main_attendee_cart_data = get_attendee_cart_related_dict(request, main_attendee.user,
                                                                     main_attendee,
                                                                     main_attendee,
                                                                     event)
            # now call function to create cart objects
            create_event_item_cart(main_attendee_cart_data)
            update_group_type_field_of_event_attendee(main_attendee, request.data['group_type'])

    @transaction.atomic
    @action(detail=True, methods=['post'], url_path='register-guest-attendees')
    def register_guest_attendees(self, request, *args, **kwargs):
        self.invalid_user_data_collection = []
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        # check the accommodation group type first
        group_type = request.data['group_type']
        if group_type == dict(ACCOMMODATION_GROUP_TYPE_CHOICES).get(ONSITE):

            # get the addition_guests data from request
            additional_guests = request.data.get('additionalGuests', None)
            # we perform operations for additional_guests only if addition guests non empty
            # if addition guests do not exit( is empty array []) it means only main_attendees is to be updated with
            # given accommodation group type and registration items for main_attendee needs to be added in cart
            if additional_guests:
                guest_user_list = []
                guest_attendee_smart_card_validity_list = []
                #  if the number of additional guests are greater than 1, we need to check if their email and
                #  and phone_number are same but not  different from main_attendee then we need to provide invalid
                # error message as guests can not have same email or phone number
                guest_data_is_valid = self.validate_guest_data_to_prevent_same_email_or_phone_number(main_attendee,
                                                                                                     additional_guests)

                for extra_guest in additional_guests:
                    guest_user_data = self.get_user_related_data(extra_guest)
                    [guest_user, is_new_guest_user, already_registered_event_attendee] = self.validate_user_data(
                        guest_user_data, 'guest_user', main_attendee,
                        already_registered_event_attendee_id=extra_guest.get(
                            'event_attendee_id', None))
                    guest_user_list.append({'guest_user': guest_user, 'is_new_guest_user': is_new_guest_user,
                                            'guest_user_data': guest_user_data,
                                            'guest_attendee_data': get_attendee_related_data(extra_guest),
                                            'already_registered_event_attendee': already_registered_event_attendee,

                                            })
                    # check if guest attendee's smart card is valid
                    guest_attendee_smart_card_validity_list.append(
                        validate_smart_card_number(extra_guest['smart_card_number']))

                # now we check for validation to determine whether to send validation error response or
                # create the the user instance and related only after every user data for each attendee is valid
                create_guest_attendee_id_list = []

                if all(guest_user['guest_user'] for guest_user in
                       guest_user_list) and all(
                    guest_valid for guest_valid in guest_attendee_smart_card_validity_list) and guest_data_is_valid:

                    # first we delete every registration items registered by main_attendee
                    filter_param = Q(event=event, ordered_by_attendee=main_attendee,
                                     event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION))
                    hard_delete_item_cart(filter_param)

                    # if main_attendee is changed_to_onsite (redirect from order edit page to change offsite
                    #  to onsite registration  we need to create cancel type cart items for all offsite event items
                    #  now we create cart items from ordered_items of CANCEL type
                    main_user = main_attendee.user

                    if main_attendee.changed_to_onsite:
                        self.perform_action_if_registration_is_changed_to_onsite(request, main_attendee, event)

                    #  if main_attendee is not changed_to_onsite , it is normal process hence , we will
                    # just create a cart items from selected_items (from frontend) and update group type
                    else:
                        # we main_attendee is passed separately to update the ordered_by_attendee field in cart item
                        main_attendee_cart_data = get_attendee_cart_related_dict(request, main_user,
                                                                                 main_attendee,
                                                                                 main_attendee,
                                                                                 event)
                        # now call function to create cart objects
                        create_event_item_cart(main_attendee_cart_data)
                        update_group_type_field_of_event_attendee(main_attendee, request.data['group_type'])

                    # now we are going to save guest User objects and  create Attendee object for additional guest members
                    for guest in guest_user_list:
                        [guest_user, is_new_guest_user, guest_user_data, already_registered_event_attendee] = [
                            guest['guest_user'],
                            guest['is_new_guest_user'],
                            guest['guest_user_data'],
                            guest['already_registered_event_attendee']
                        ]

                        # we check if main user has entered same email as his/her own to other guests, if yes
                        # we generate dummy email for those to maintain email uniqueness in database

                        if guest_user_data['email'] == main_user.email:
                            guest_user_data['email'] = generate_dummy_email()
                            #  now we update guest_user instance
                            guest_user.email = guest_user_data['email']

                        # we check if main user has entered same phone_number as his/her own to other guests, if yes
                        # we generate dummy email for those to maintain email uniqueness in database
                        if guest_user_data['phone_number'] == main_user.phone_number:
                            guest_user_data['phone_number'] = generate_dummy_phone_number()
                            #  now we update guest_User instance
                            guest_user.phone_number = guest_user_data['phone_number']

                        guest_user = self.save_user(guest_user, guest_user_data, is_new_guest_user)

                        guest_attendee_data = {'user': guest_user,
                                               'registered_by': main_attendee, 'alternate_email': main_user.email,
                                               'alternate_phone_number': main_user.phone_number,
                                               'smart_card_number': guest['guest_attendee_data']['smart_card_number'],
                                               'is_senior_citizen': guest['guest_attendee_data']['is_senior_citizen'],
                                               'is_pwk': guest['guest_attendee_data']['is_pwk'],
                                               }

                        #  first we delete all cart items and event_attendee associated with given user(if previously
                        # created email or phone_number is used, user would be same and event_attendee would have been
                        # already created hence we need to delete cart items and event_attendee if such exists

                        ItemCart.objects.filter(event=event, ordered_by_attendee=main_attendee).filter(
                            user=guest_user).hard_delete()
                        #     now delete event_attendee since single user can not have more than one event_attendee
                        # for given event
                        EventAttendee.objects.filter(event=event, user=guest_user).hard_delete()

                        # now we create Attendee object for guest user
                        guest_attendee = self.create_event_attendee(request, guest_attendee_data,
                                                                    already_registered_event_attendee)

                        # now we are going to create cart object of main_attendee for event registration
                        # type eventItem ( ticket fee items)

                        guest_attendee_cart_data = get_attendee_cart_related_dict(request, guest_user,
                                                                                  guest_attendee,
                                                                                  main_attendee,
                                                                                  event)

                        #  we need to update 'selected_items' , since it get poped out in
                        #  very create_event_item_cart() function

                        # now call function to create cart objects
                        create_event_item_cart(guest_attendee_cart_data)

                        create_guest_attendee_id_list.append(guest_attendee.id)

                    #  now we need to delete every cart items associated with guests other than created above, and
                    # finally delete those event attendees as well
                    ItemCart.objects.filter(event=event, ordered_by_attendee=main_attendee).exclude(
                        event_attendee__id__in=create_guest_attendee_id_list).exclude(
                        event_attendee=main_attendee).hard_delete()
                    #      we also need to delete accommodation item since , number of guest may change , hence
                    # pre-selected accommodation item may not be valid
                    ItemCart.objects.filter(event=event, ordered_by_attendee=main_attendee,
                                            event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(
                                                ACCOMMODATION)).hard_delete()
                    #     finally we delete event_attendees that are not in create_guest_attendee_id_list but excluding
                    # main_attendee itself
                    get_guest_attendees(main_attendee, event).exclude(
                        id__in=create_guest_attendee_id_list).hard_delete()


                else:
                    # we return validation error message with code 0 if guest attendees data are entered but not valid
                    response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                                     'message': 'Personnel Detail Validation error occurred',
                                     'data': self.invalid_user_data_collection}
                    return Response(response_data, status=status.HTTP_200_OK)

            # this means only main_attendee is registered and no guest attendees data are available
            else:
                # first we delete every registration items registered by main_attendee

                if main_attendee.changed_to_onsite:
                    self.perform_action_if_registration_is_changed_to_onsite(request, main_attendee, event)
                else:
                    filter_param = Q(event=event, ordered_by_attendee=main_attendee,
                                     event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION))
                    hard_delete_item_cart(filter_param)
                    main_user = main_attendee.user
                    # main_attendee is passed separately to update the ordered_by_attendee field in cart item
                    main_attendee_cart_data = get_attendee_cart_related_dict(request, main_user,
                                                                             main_attendee,
                                                                             main_attendee,
                                                                             event)
                    # now call function to create cart objects
                    create_event_item_cart(main_attendee_cart_data)
                    update_group_type_field_of_event_attendee(main_attendee, request.data['group_type'])
        else:
            #     accommodation group type is choosen as offsite , hence we need to remove every attendee
            # registered by main_attendee and every cart items added registered by him/her
            delete_all_cart_items_of_main_user(main_attendee.user, event, exclude_coupon_items=True)
            # this hard deletes all the guest_attendees registered by main_attendees ,since offsite type is choosen
            get_guest_attendees(main_attendee, event).hard_delete()
            # we main_attendee is passed separately to update the ordered_by_attendee field in cart item
            main_attendee_cart_data = get_attendee_cart_related_dict(request, main_attendee.user,
                                                                     main_attendee,
                                                                     main_attendee,
                                                                     event)
            # now call function to create cart objects
            create_event_item_cart(main_attendee_cart_data)
            update_group_type_field_of_event_attendee(main_attendee, request.data['group_type'])

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Attendee Registration is done successfully',
                         'data': {'main_attendee_uuid': main_attendee.uuid}}

        return Response(response_data, status=status.HTTP_200_OK)

    #  this API is used to change the attendee( ie makes already previous attendee status inactive and
    #  create another attendee and user with request data if validation is passed
    #  this is used in order-edit section
    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='change-attendee')
    def change_attendee(self, request, event_uuid=None, uuid=None):
        self.invalid_user_data_collection = []
        main_attendee = self.get_object()
        main_user = main_attendee.user
        event = get_event_object(self.kwargs['event_uuid'])
        changed_user_data = self.get_user_related_data(request.data)

        # check if main attendee's smart card is valid
        changed_attendee_smart_card_number_valid = validate_smart_card_number(request.data['smart_card_number'])

        [changed_user, is_new_changed_user, already_registered_event_attendee] = self.validate_user_data(
            changed_user_data, 'guest_user', main_attendee)

        if changed_user and changed_attendee_smart_card_number_valid:
            #  we call function to create or update changed_user, create changed_attendee and return changed_attendee
            # changed_attendee = self.save_user_and_create_attendee(request, changed_user, changed_user_data,
            #                                                       is_new_changed_user)

            # we check if main user has entered same email as his/her own to other guests, if yes
            # we generate dummy email for those to maintain email uniqueness in database
            changed_attendee_data = get_attendee_related_data(request.data)

            if changed_user_data['email'] == main_user.email:
                changed_user_data['email'] = generate_dummy_email()
                #  now we update guest_user instance
                changed_user.email = changed_attendee_data['email']

            # we check if main user has entered same phone_number as his/her own to other guests, if yes
            # we generate dummy email for those to maintain email uniqueness in database
            if changed_user_data['phone_number'] == main_user.phone_number:
                changed_user_data['phone_number'] = generate_dummy_phone_number()
                #  now we update guest_User instance
                changed_user.phone_number = changed_attendee_data['phone_number']

            changed_user = self.save_user(changed_user, changed_user_data, is_new_changed_user)

            changed_attendee_data = {'user': changed_user,
                                     'registered_by': main_attendee, 'alternate_email': main_user.email,
                                     'alternate_phone_number': main_user.phone_number,
                                     'smart_card_number': changed_attendee_data['smart_card_number'],
                                     'is_senior_citizen': changed_attendee_data['is_senior_citizen'],
                                     'is_pwk': changed_attendee_data['is_pwk'],
                                     }
            # now we create Attendee object for guest user

            changed_attendee = self.create_event_attendee(request, changed_attendee_data,
                                                          already_registered_event_attendee)

            changed_attendee.registered_by = main_attendee
            changed_attendee.save()
            # now update the registration status  of changed attendee to CONFIRMED status
            update_registration_status_of_attendee(changed_attendee,
                                                   dict(EVENT_REGISTRATION_STATUS).get(CONFIRMED))

            #  finally we retrieve the removed_attendee_uuid from the request data and
            # update its registration_status

            try:
                removed_attendee = EventAttendee.objects.get(uuid=request.data['removed_attendee_uuid'])
                removed_attendee.registration_status = dict(EVENT_REGISTRATION_STATUS).get(CANCELED)
                removed_attendee.save()
                # now we change event_attendee and user fields of all ordered_items that were registered to previous
                #  attendee
                removed_attendee_order_items = get_all_active_ordered_items_of_user(
                    get_all_orders_of_main_user(main_attendee.user, event), removed_attendee.user)
                for item in removed_attendee_order_items:
                    item.event_attendee = changed_attendee
                    item.user = changed_attendee.user
                    item.save()
            except ObjectDoesNotExist as e:
                raise Exception(e)

            response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                             'message': 'Attendee is changed successfully',
                             'data': {'main_attendee_uuid': main_attendee.uuid}}
        else:
            response_data = {'code': getattr(settings, 'ERROR_CODE', 0),
                             'message': 'Personnel Detail Validation error occurred',
                             'data': self.invalid_user_data_collection}
        return Response(response_data, status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='change-onsite-to-offsite-registration')
    def change_onsite_to_offsite_registration(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])

        #  first we delete every already added cart items for event attendee since, any modification  on carts
        # done by main_attendee has be cleared to avoid any kind of SALE type or CANCEL type cart items
        #  done using transportation or accommodation edit
        delete_all_cart_items_of_main_user(main_attendee.user, event)

        #  now we create cart items from ordered_items of CANCEL type

        order_queryset = get_all_orders_of_main_user(main_attendee.user, event)
        #  we here filter registration , accommodation and transportation items
        filter_param = (Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION)) |
                        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)) |
                        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION))
                        )
        ordered_items_base_queryset = get_all_active_ordered_items_of_main_user(order_queryset).filter(
            filter_param).exclude(
            event_attendee=main_attendee, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION),
            event_item__group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(BOTH))
        for ordered_item in ordered_items_base_queryset:
            # then we create CANCEL type cart items from all ordered_items_base_queryset as only onsite
            # registration item is excluded here
            create_canceled_cart_item_from_ordered_item(ordered_item, main_attendee, event, is_canceled_item=True)

        # now we update the main_attendee's  changed_to_offsite field
        main_attendee.changed_to_offsite = True
        main_attendee.save()

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Registration is changed to OffSite type  successfully',
             'data': {
             }
             }
            , status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='change-offsite-to-onsite-registration')
    def change_offsite_to_onsite_registration(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])

        #  first we delete every already added cart items for event attendee since, any modification  on carts
        # done by main_attendee has be cleared to avoid any kind of SALE type or CANCEL type cart items
        #  done using transportation or accommodation edit
        delete_all_cart_items_of_main_user(main_attendee.user, event)
        # now we update the main_attendee's  changed_to_offsite field
        main_attendee.changed_to_onsite = True
        main_attendee.save()

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Registration is changed to OnSite is on progress.',
             'data': {}
             }
            , status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='cancel-registration')
    def cancel_registration(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])

        #  first we delete every already added cart items for event attendee since, any modification  on carts
        # done by main_attendee has be cleared to avoid any kind of SALE type or CANCEL type cart items
        #  done using transportation or accommodation edit
        delete_all_cart_items_of_main_user(main_attendee.user, event)

        #  now we create cart items from ordered_items of CANCEL type

        order_queryset = get_all_orders_of_main_user(main_attendee.user, event)
        #  we here filter registration , accommodation and transportation items
        filter_param = (Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION)) |
                        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)) |
                        Q(event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION))
                        )
        ordered_items_base_queryset = get_all_active_ordered_items_of_main_user(order_queryset).filter(
            filter_param)
        for ordered_item in ordered_items_base_queryset:
            # then we create CANCEL type cart items from all ordered_items_base_queryset as only onsite
            # registration item is excluded here
            create_canceled_cart_item_from_ordered_item(ordered_item, main_attendee, event, is_canceled_item=True)

        # now we update the main_attendee's  registration_is_cancelled field
        main_attendee.registration_is_cancelled = True
        main_attendee.save()

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Registration is cancelled   successfully',
             'data': {
             }
             }
            , status=status.HTTP_200_OK)

    # ------------------------------------------end of registration related APIs------------------------------#

    # ----------------------------------------start of accommodation related APIs----------------------------#

    @action(methods=['get'], detail=True, url_path='get-all-attendee-detail')
    def get_attendee_detail_for_accommodation_page(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(event_uuid)

        all_attendees = get_all_attendees(main_attendee, event)
        all_attendees_serialized_data = EventAttendeeSerializer(all_attendees, many=True).data

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Attendee Detail for accommodation page is fetched successfully',
             'data': {'attendees': all_attendees_serialized_data,
                      'number_of_attendees': get_number_of_attendees_registered_by_main_attendee(main_attendee, event),
                      'group_type': main_attendee.group_type,
                      'changed_to_onsite': main_attendee.changed_to_onsite}
             }
            , status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='register-accommodation-items')
    def register_accommodation_items(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        event_item = get_event_item_object(request.data['accommodation_item_uuid'])

        #  first we delete already added accommodation item from cart for given attendee for given
        # event , and the we create new event cart items from latest received data from request above
        filter_query = Q(event=event, ordered_by_attendee=main_attendee, event_item__group__name=ACCOMMODATION,
                         event_item__group_type=ONSITE)
        hard_delete_item_cart(filter_query)

        selected_items = [get_basic_cart_dict_from_event_item(event_item)]

        main_attendee_cart_data = get_basic_cart_item_dict_for_main_user(
            main_attendee.user, selected_items, dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(
                SALE),
            main_attendee, event

        )

        # now call function to create cart objects
        create_event_item_cart(main_attendee_cart_data)

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Accommodation is successfully added to your cart successfully',
             'data': {'main_attendee_uuid': main_attendee.uuid}
             }
            , status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='change-accommodation-items')
    def change_accommodation_items(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        # we make list with selected accommodation item uuid in it
        selected_accommodation_items_uuid_list = []
        #  we need to convert uuid to str to make comparison since uuid can not be directly compared with string
        selected_accommodation_items_uuid_list.append(
            str(get_event_item_object(request.data['accommodation_item_uuid']).uuid))

        all_accommodation_items = EventItem.objects.filter(item_capacity__gte=1,
                                                           event__uuid=self.kwargs['event_uuid']).filter(
            Q(event=event, group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(ONSITE),
              group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)))

        #  in case of accommodation main_attendee is attendee itself
        maintain_only_changed_items_in_cart_in_order_edit(request, main_attendee.user, all_accommodation_items,
                                                          selected_accommodation_items_uuid_list,
                                                          main_attendee.user,
                                                          main_attendee, main_attendee, event)

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Accommodation is successfully changed to your cart successfully',
             }

            , status=status.HTTP_200_OK)

    # --------------------------------------end of accommodation related APIs -----------------------#

    # ---------------------------start of transportation related APIS-----------------------------#

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='register-transportation-items')
    def register_transportation_items(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])

        #  first we delete already added transportation items from cart for given attendee for given
        # event , and the we create new event cart items from latest received data from request above
        filter_query = Q(event=event, ordered_by_attendee=main_attendee,
                         event_item__group__name=TRANSPORTATION,
                         event_item__group_type=ONSITE)

        hard_delete_item_cart(filter_query)

        """
              sample data from frontend is as follows:

              data = [
              {
              'not_required': False, 
              'attendee_uuid': '6171c362-0175-4a7b-a3c6-acf91dda43ff', 
              'transportation_item_list': [{
                                              'transportation_item_checked': True, 
                                              'transportation_item_uuid': '6ccdd14c-d4f1-411e-8bfb-1505e9cccaf7', 
                                              'arrival_datetime': '2019-03-15T09:06:04.274Z', 
                                              'departure_datetime': '2019-03-15T09:06:07.627Z', 
                                              'pickup_location': {'location': 'station1', 'event_item': 15, 'uuid': '37553c09-3b96-4433-824b-505edcbdd09c'}
                                              },
                                              {},
                                              {},
                                              ....
                                              }]
              },
              {
              'not_required': False, 
              'attendee_uuid': '6171c362-0175-4a7b-a3c6-acf91dda434f', 
              'transportation_item_list': [{
                                              'transportation_item_checked': True, 
                                              'transportation_item_uuid': '6ccdd14c-d4f1-411e-8bfb-15eee9cccdf7', 
                                              'arrival_datetime': '2019-03-15T09:06:04.274Z', 
                                              'departure_datetime': '2019-03-15T09:06:07.627Z', 
                                              'pickup_location': {'location': 'station1', 'event_item': 15, 'uuid': '37553c09-3b96-4433-824b-505edcbdd09c'}
                                              },
                                              {},
                                              {},
                                              ....
                                              }]}
              """
        for data in request.data:
            #  we need to perform any operation if 'not_required' field is True
            if not data['not_required']:
                for each_item in data['transportation_item_list']:
                    #  we will perform operations only if item is checked using the flag 'transportation_item_checked'
                    if each_item['transportation_item_checked']:
                        event_item = get_event_item_object(each_item['transportation_item_uuid'])
                        attendee = get_event_attendee_object_by_uuid(data['attendee_uuid'])
                        selected_items = update_transportation_info_of_transportation_event_item(event_item,
                                                                                                 each_item)

                        attendee_cart_data = get_cart_item_dict_for_user(
                            main_attendee.user, attendee.user,
                            selected_items,
                            dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE),

                            main_attendee,
                            attendee, event

                        )

                        # now call function to create cart objects
                        create_event_item_cart(attendee_cart_data)

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Transportation is successfully added to your cart successfully',
             'data': {'main_attendee_uuid': main_attendee.uuid}
             }
            , status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='change-transportation-items')
    def change_transportation_items(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])

        """
        sample data from frontend is as follows:

        data = [
        {
        'not_required': False, 
        'attendee_uuid': '6171c362-0175-4a7b-a3c6-acf91dda43ff', 
        'transportation_item_list': [{
                                        'transportation_item_checked': True, 
                                        'transportation_item_uuid': '6ccdd14c-d4f1-411e-8bfb-1505e9cccaf7', 
                                        'arrival_datetime': '2019-03-15T09:06:04.274Z', 
                                        'departure_datetime': '2019-03-15T09:06:07.627Z', 
                                        'pickup_location': {'location': 'station1', 'event_item': 15, 'uuid': '37553c09-3b96-4433-824b-505edcbdd09c'}
                                        },
                                        {},
                                        {},
                                        ....
                                        }]
        },
        {
        'not_required': False, 
        'attendee_uuid': '6171c362-0175-4a7b-a3c6-acf91dda434f', 
        'transportation_item_list': [{
                                        'transportation_item_checked': True, 
                                        'transportation_item_uuid': '6ccdd14c-d4f1-411e-8bfb-15eee9cccdf7', 
                                        'arrival_datetime': '2019-03-15T09:06:04.274Z', 
                                        'departure_datetime': '2019-03-15T09:06:07.627Z', 
                                        'pickup_location': {'location': 'station1', 'event_item': 15, 'uuid': '37553c09-3b96-4433-824b-505edcbdd09c'}
                                        },
                                        {},
                                        {},
                                        ....
                                        }]}
        """
        all_transportation_items = EventItem.objects.filter(item_capacity__gte=1,
                                                            event__uuid=self.kwargs['event_uuid']).filter(
            Q(event=event, group_type=dict(ITEM_GROUP_TYPE_CHOICES).get(ONSITE),
              group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION)))

        #  we get all attendee list despite not_required being checked or not since we need to iterate through
        # each items in transportation_items to track change
        attendee_uuid_list = [data['attendee_uuid'] for data in request.data]
        for attendee_uuid in attendee_uuid_list:
            selected_trans_item_uuid_list = []
            for attendee_wise_data in request.data:
                if attendee_wise_data['attendee_uuid'] == str(attendee_uuid):
                    for data in attendee_wise_data['transportation_item_list']:
                        if data['transportation_item_checked']:
                            selected_trans_item_uuid_list.append(data['transportation_item_uuid'])

            # this is maintain only changed cart items ( new items added as SALE type and canceled items as CANCEL type)
            attendee = get_event_attendee_object_by_uuid(attendee_uuid)
            maintain_only_changed_items_in_cart_in_order_edit(request, main_attendee.user, all_transportation_items,
                                                              selected_trans_item_uuid_list,
                                                              attendee.user,
                                                              main_attendee, attendee, event)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Transportation is successfully added to your cart successfully',
                         'data': {'main_attendee_uuid': main_attendee.uuid}
                         }

        return Response(response_data, status=status.HTTP_200_OK)

    # ----------------------end of transportation related APIs--------------------------------------------#

    # ------------------start of cart related APIs---------------------------------------------------------#

    @staticmethod
    def get_event_item_cart_serialized_data(all_cart_items, filter_query):
        return ItemCartSerializer(all_cart_items.filter(filter_query), many=True).data

    def get_attendee_event_items_cart_list_group_wise(self, main_user, main_attendee=None, event=None):
        latest_order = get_latest_order_of_main_user(main_attendee.user, event)

        result = perform_operations_on_cart_items_for_cart_summary(main_attendee.user, latest_order, main_attendee,
                                                                   event)
        all_cart_items = result['all_cart_items']

        return {
            'registration_cart_items_data': self.get_event_item_cart_serialized_data(
                all_cart_items,
                Q(event_item__group__name=dict(
                    DEFAULT_EVENT_ITEM_GROUPS).get(
                    REGISTRATION))),
            'accommodation_cart_items_data': self.get_event_item_cart_serialized_data(
                all_cart_items,
                Q(event_item__group__name=dict(
                    DEFAULT_EVENT_ITEM_GROUPS).get(
                    ACCOMMODATION))),
            'transportation_cart_items_data': self.get_event_item_cart_serialized_data(
                all_cart_items,
                Q(event_item__group__name=dict(
                    DEFAULT_EVENT_ITEM_GROUPS).get(
                    TRANSPORTATION))),
            'coupon_cart_items_data': self.get_event_item_cart_serialized_data(
                all_cart_items,
                Q(is_coupon_item=True)),
            'service_charge_and_tax_items': ItemCartSerializer(
                (data for data in result['service_charge_and_tax_items']),
                many=True).data,

            'cancellation_charge_cart_items': ItemCartSerializer(
                (data for data in result['cancellation_charge_cart_items']),
                many=True).data,

            'number_of_attendees': get_number_of_attendees_registered_by_main_attendee(main_attendee, event),
            'amount_net_for_changed_cart_items': result['amount_net_for_changed_cart_items'],
            'net_service_charge_and_tax_amount': result['net_service_charge_and_tax_amount'],
            'net_balance_from_latest_order': result['net_balance_from_latest_order'],
            'current_total_credit_amount_used': result['current_total_credit_amount_used'],
            'current_total_discount_coupon_used': result['current_total_discount_coupon_used'],
            'final_amount_to_pay': result['final_amount_to_pay'],
            'balance_credit': result['balance_credit'],
            'refundable_amount': result['refundable_balance'],
            'group_type': main_attendee.group_type,
            'changed_to_onsite': main_attendee.changed_to_onsite

        }

    @staticmethod
    def get_all_cart_items_on_order_edit_by_main_attendee(event, main_attendee):
        filter_query = Q(transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(SALE)) | Q(
            transaction_type=dict(ORDER_ITEM_TRANSACTION_TYPE_CHOICES).get(CANCEL))
        return ItemCart.objects.filter(ordered_by_attendee=main_attendee,
                                       event=event).filter(
            filter_query).exclude(
            event_attendee__registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED))

    @action(methods=['get'], detail=True, url_path='event-cart-summary')
    def event_cart_summary(self, request, event_uuid=None, uuid=None):
        attendee = self.get_object()
        main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(attendee)
        event = get_event_object(self.kwargs['event_uuid'])
        data = self.get_attendee_event_items_cart_list_group_wise(main_attendee.user, main_attendee, event)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Event Item cart summary for attendee is fetched successfully',
                         'data': data
                         }
        response_data['data'].update({'is_main_attendee': is_main_attendee})
        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True, url_path='get-already-added-transportation-cart-items')
    def get_already_added_transportation_cart_items(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        all_cart_items = get_all_cart_items_of_main_user(main_attendee.user, event)

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Already added transportation cart items is fetched successfully',
             'data': {
                 'already_added_transportation_cart_items': self.get_event_item_cart_serialized_data(
                     all_cart_items,
                     Q(
                         event_item__group__name=dict(
                             DEFAULT_EVENT_ITEM_GROUPS).get(
                             TRANSPORTATION))),

             }
             }
            ,
            status=status.HTTP_200_OK
        )

    @action(methods=['get'], detail=True, url_path='get-already-added-accommodation-cart-items')
    def get_already_added_accommodation_cart_items(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        all_cart_items = get_all_cart_items_of_main_user(main_attendee.user, event)

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Already added accommodation cart items is fetched successfully',
             'data': {
                 'already_added_accommodation_cart_items': self.get_event_item_cart_serialized_data(
                     all_cart_items,
                     Q(
                         event_item__group__name=dict(
                             DEFAULT_EVENT_ITEM_GROUPS).get(
                             ACCOMMODATION))),

             }
             }
            , status=status.HTTP_200_OK
        )

    # -----------------------------------------end of cart related APIs----------------------------------------#

    # --------------------------------------starts order related APIs-----------------------------------------#

    # this API is to create a payments and create order for given attendee
    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='confirm-order')
    def confirm_order(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        all_cart_items = get_all_cart_items_of_main_user(main_attendee.user, event)
        # we will perform order confirmation logic only if there are cart items for given main_use for given event

        if all_cart_items:
            perform_order_confirmation(request, all_cart_items, main_attendee.user, main_attendee, event)

            #  now we create confirmation_code for every attendee registered by main_attendee for event
            update_confirmation_code_for_attendee(get_all_attendees(main_attendee, event))

            # now we need to send email to with necessary order summary to main_attendee user's email address
            to_email_address = main_attendee.user.email
            if to_email_address and not check_if_email_is_dummy(to_email_address):
                try:
                    # send_email_to_all_attendees_with_order_summary.delay(main_attendee.uuid, event.uuid)
                    send_email_to_all_attendees_with_order_summary(main_attendee.uuid, event.uuid)
                    pass
                except smtplib.SMTPDataError:
                    pass

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Order has been confirmed successfully', }
            ,
            status=status.HTTP_200_OK)

    @transaction.atomic
    @action(methods=['post'], detail=True, url_path='confirm-order-edit')
    def confirm_order_edit(self, request, event_uuid=None, uuid=None):
        main_attendee = self.get_object()
        event = get_event_object(self.kwargs['event_uuid'])
        all_cart_items = get_all_cart_items_of_main_user(main_attendee.user, event)
        # we will perform order confirmation logic only if there are cart items for given main_use for given event
        if all_cart_items:
            perform_order_confirmation(request, all_cart_items, main_attendee.user, main_attendee, event)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Order has been confirmed successfully', }

        return Response(response_data, status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True, url_path='order-summary')
    def get_event_attendee_order_summary(self, request, event_uuid=None, uuid=None):
        attendee = self.get_object()
        main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(attendee)
        event = get_event_object(self.kwargs['event_uuid'])
        # send_email_to_all_attendees_with_order_summary(main_attendee.uuid, event.uuid)

        # get order object for main_attendee for given event
        order_queryset = get_all_orders_of_main_user(main_attendee.user, event)
        #  here we need to check if the main_attendee's registration status is CONFIRMED or CANCELED
        # if it is CONFIRMED , we need to provide the active ordered items
        # else if it is CANCELED , we need to provice the cancelled ordered items
        if main_attendee.registration_status == dict(EVENT_REGISTRATION_STATUS).get(CONFIRMED):
            result_data = get_active_items_of_order(order_queryset, main_attendee.user, main_attendee, event)
            order_is_cancelled = False

        else:
            result_data = get_cancelled_items_of_order(order_queryset, main_attendee.user, main_attendee, event)
            order_is_cancelled = True

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Order Detail of given attendee  is fetched successfully',
                         'data': result_data
                         }

        if is_main_attendee:
            confirmation_codes = get_confirmation_code_for_attendees(get_all_attendees(main_attendee, event))
        else:
            # if the attendee is not main_atttendee we just pass attendee itself as list to get only his/her confirmation
            # codes
            confirmation_codes = get_confirmation_code_for_attendees([attendee])

        response_data['data'].update({'is_main_attendee': is_main_attendee,
                                      'order_is_cancelled': order_is_cancelled,
                                      'confirmation_codes': confirmation_codes})

        return Response(response_data, status=status.HTTP_200_OK)

    # ------------------------------------end of order related APIs------------------------------------------------#

    # ----------------------------start of order edit APIs ---------------------------------------------------------#

    # @staticmethod
    # def get_event_ordered_items_category_wise(main_attendee, order):
    #     order_data = OrderOptimizedSerializer(order).data
    #     #  here ordered_item_queryset is all items that belong to this order object, this includes order_items of all
    #     #  attendees
    #     ordered_items_queryset = OrderedItem.objects.filter(order=order).exclude(
    #         event_attendee__registration_status=dict(EVENT_REGISTRATION_STATUS).get(CANCELED))
    #
    #     registration_items = OrderedItemSerializer(ordered_items_queryset.filter(
    #         transaction_type=SALE, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(REGISTRATION)),
    #         many=True).data
    #     accommodation_items = OrderedItemSerializer(ordered_items_queryset.filter(
    #         transaction_type=SALE, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(ACCOMMODATION)),
    #         many=True).data
    #     transportation_items = OrderedItemSerializer(ordered_items_queryset.filter(
    #         transaction_type=SALE, event_item__group__name=dict(DEFAULT_EVENT_ITEM_GROUPS).get(TRANSPORTATION)),
    #         many=True).data
    #
    #     coupon_items = CouponSerializer(
    #         Coupon.objects.filter(used_by=main_attendee.user, order=order), many=True).data
    #     payment_items = OrderedItemSerializer(
    #         ordered_items_queryset.filter(
    #             transaction_type=RECEIPT), many=True).data
    #     refund_items = OrderedItemSerializer(
    #         ordered_items_queryset.filter(transaction_type=REFUND), many=True).data
    #
    #     response_data = {
    #         'order': order_data,
    #         'registration_items': registration_items,
    #         'accommodation_items': accommodation_items,
    #         'transportation_items': transportation_items,
    #         'coupon_items': coupon_items,
    #         'payment_items': payment_items,
    #         'refund_items': refund_items,
    #     }
    #
    #     return response_data

    # this function gives the final items intersection of ordered_items in order and event_cart items
    #  so that it is used to provide data to be populated in edit-order section with
    # flexibility of back forth editing until final order edit confirmation is made

    @action(methods=['get'], detail=True, url_path='order-edit-data')
    def get_order_edit_data(self, request, event_uuid=None, uuid=None):
        event = get_event_object(self.kwargs['event_uuid'])

        #  here we get the attendee , find out main_attendee of attendee and also figure out
        #  if obtained attendee is main_attendee itself
        attendee = self.get_object()
        main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(attendee)

        #  we need to check if main_attendee's 'changed_to_offsite' field is True, if it is , it means
        # main_attendee once changed whole registration to offsite and event cart items
        # contains all the canceled cart items from ordered_items,
        #  BUT without submitting that process, main_attendee is again doing back and
        #  forth to edit the process, which means we need to provide the data
        #  as in previous stage of items cotaining only ordered_items and
        #  not any single cart items , hence we delete every carts items for that main_attendee

        if main_attendee.changed_to_offsite:
            # now delete every cart items
            delete_all_cart_items_of_main_user(main_attendee.user, event)

            #  update changed_to_offsite to False
            main_attendee.changed_to_offsite = False
            main_attendee.save()
        #  if registration_is_cancelled is True ,but again reverted back we need to order edit page again
        #  we need to cancel out this cancellation and bring back to previous state
        if main_attendee.registration_is_cancelled:
            # now delete every cart items
            delete_all_cart_items_of_main_user(main_attendee.user, event)

            #  update changed_to_offsite to False
            main_attendee.registration_is_cancelled = False
            main_attendee.save()
        # if changed_to_onsite but again brought back to order edit page , we revert is back
        if main_attendee.changed_to_onsite:
            # now delete every cart items
            delete_all_cart_items_of_main_user(main_attendee.user, event)

            #  update changed_to_offsite to False
            main_attendee.changed_to_onsite = False
            main_attendee.save()

        all_attendees = get_all_attendees(main_attendee, event)
        all_attendees_serialized_data = EventAttendeeSerializer(all_attendees, many=True).data

        # get all orders for main_attendee for given event
        order_queryset = get_all_orders_of_main_user(main_attendee.user, event)
        ordered_items_category_wise = get_event_ordered_items_and_cart_item_combined_category_wise(main_attendee, event,
                                                                                                   order_queryset,
                                                                                                   all_attendees)

        return Response(
            {'code': getattr(settings, 'SUCCESS_CODE', 1),
             'message': 'Data for Order Edit is fetched successfully',
             'data': {'all_attendees': all_attendees_serialized_data,
                      'is_main_attendee': is_main_attendee,
                      'main_attendee_uuid': main_attendee.uuid,
                      'number_of_attendees': get_number_of_attendees_registered_by_main_attendee(main_attendee, event),
                      'registration_items': ordered_items_category_wise['registration_items'],
                      'accommodation_items': ordered_items_category_wise['accommodation_items'],
                      'transportation_items': ordered_items_category_wise['transportation_items'],
                      'net_balance': ordered_items_category_wise['net_balance'],
                      'order': ordered_items_category_wise['order'],
                      'group_type': ordered_items_category_wise['group_type'],
                      'only_offsite_registration': main_attendee.event.only_offsite_registration,
                      }
             },
            status=status.HTTP_200_OK)

    # ----------------------------end of order edit -----------------------------------------------#

    """
    logic to cart_item creation with track of only changed items
    -------------------------------------------------------------------
    for event_item in all_event_item_of_given_category:
        item_in_cart_list = event_item_object
        item_in_order_list = event_item_object
        
        if event_item in form_cart_item_list: # this means item is submitted as equivalent to add it as SALE
            
            if item_in_cart_list or item_in_order_list: # is on either
                if item_in_cart_list and item_in_order_list:
                    delete_already_added_cart_item # this would be as CANCEL type
                    
                elif item_in_order_list:
                    --do nothing # nothing is done since item is already in oredered_item with SALE type
                else:
                    delete_already_adde_cart_item # this would be as CANCEL type
            else:
                ADD event_item in cart as SALE type
            
                
                    
            
        else: # this means item is submitted as equivalent to cancel it
            if item_in_active_cart_item_list or item_in_active_ordered_item_list:
                    # first check if event_item exits both in ordered_items and cart_items
                    if item_in_active_cart_item_list and item_in_active_ordered_item_list:
                         this means ordered_items have same event_item with SALE type
                         and cart_items have same event_item with CANCEL type , thus exits in both
                         hence , we delete the event_item in cart_item(as CANCEL type)
                         DELETE CART ITEM

                    #     check if event_item already exits in cart_item_list
                    elif item_in_active_ordered_item_list:
                         this means event_item is already in ordered_item as SALE type, but since it is
                         unselected now, cart_item with CANCEL type has to be created
                         since these trans_item are unselected,  we donot have transportation_info for these
                         selected_items provided list since no transportation_info_update function is not called
                         which returns list
                        
                        # now create cart item
                        CREATE CART ITEM WITH CANCEL TYPE
                    else:
                        # this means item is unselected in form data, and does not exist  in ordered_item (may
                        # excluded by canceled_ordere_item) and but is in cart_items (as CANCEL status)
                        # hence , this time too it is unselected( CANCEL equivalent) we do nothing here
                        pass
    -------------------------------------------------------------------------------------------
            
            
    """

    # this API provides the summary of order on edit and items added to cart in order-edit portion
    @action(methods=['get'], detail=True, url_path='edited-order-and-cart-summary-data')
    def get_edited_order_and_cart_summary_data(self, request, event_uuid=None, uuid=None):
        attendee = self.get_object()
        main_attendee, is_main_attendee = get_main_attendee_of_given_attendee(attendee)
        event = get_event_object(self.kwargs['event_uuid'])

        # get order object for main_attendee for given event
        order_queryset = get_all_orders_of_main_user(main_attendee.user, event)

        # TODO : remove this email sending line after

        response_data = get_active_items_of_order_and_changed_items_of_cart(event, main_attendee, order_queryset)

        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Order Detail of given attendee  is fetched successfully',
                         'data': response_data
                         }
        response_data['data'].update({'is_main_attendee': is_main_attendee,
                                      'registration_is_cancelled': main_attendee.registration_is_cancelled,
                                      'changed_to_offsite': main_attendee.changed_to_offsite})

        return Response(response_data, status=status.HTTP_200_OK)

        # this API provides the summary of order on edit and items added to cart in order-edit portion
