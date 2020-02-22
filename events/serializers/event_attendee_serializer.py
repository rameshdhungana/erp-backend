from allauth.account.adapter import get_adapter
from allauth.account.utils import setup_user_email
from allauth.utils import email_address_exists
from django.conf import settings
from django.contrib.auth import get_user_model
from phonenumber_field.serializerfields import PhoneNumberField
from rest_framework import serializers
from rest_framework.serializers import ModelSerializer

from events.models import EventAttendee
from users.serializers import UserSerializer, UserSerializerWithNoDummyEmailAndPhone
from users.serializers.register_serializer import \
    AbstractRegistrationSerializer
from users.utils import generate_dummy_email

User = get_user_model()

ATTENDEE_EMAIL_IS_REQUIRED = getattr(settings, 'ATTENDEE_EMAIL_IS_REQUIRED')
ATTENDEE_PHONE_IS_REQUIRED = getattr(settings, 'ATTENDEE_PHONE_IS_REQUIRED')


class RegisteredBySerializer(ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = EventAttendee
        fields = ('uuid', 'user')


class AttendeeUserSerializer(serializers.Serializer):
    first_name = serializers.CharField(max_length=64, required=True)
    last_name = serializers.CharField(max_length=64, required=True)
    city = serializers.CharField(max_length=255, required=False)
    email = serializers.EmailField(required=ATTENDEE_EMAIL_IS_REQUIRED, allow_blank=not ATTENDEE_EMAIL_IS_REQUIRED,
                                   allow_null=not ATTENDEE_EMAIL_IS_REQUIRED)
    phone_number = PhoneNumberField(max_length=20, required=ATTENDEE_PHONE_IS_REQUIRED,
                                    allow_null=not ATTENDEE_PHONE_IS_REQUIRED,
                                    allow_blank=not ATTENDEE_PHONE_IS_REQUIRED)


class EventAttendeeSerializer(ModelSerializer):
    registered_by = RegisteredBySerializer()

    class Meta:
        exclude = ('updated_at', 'deleted_at',)
        model = EventAttendee

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'user': UserSerializer(instance.user).data,
        }
        response.update(data)
        return response


class EventAttendeeOptimizedSerializer(ModelSerializer):
    registered_by = RegisteredBySerializer()

    class Meta:
        model = EventAttendee
        exclude = ('updated_at', 'deleted_at',)

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'id': instance.id,
            'user': UserSerializerWithNoDummyEmailAndPhone(instance.user,
                                                           context={'event': self.context['event']}).data,
        }
        response.update(data)
        return response


class EventAttendeeWithJustUserInformationSerializer(ModelSerializer):
    class Meta:
        model = EventAttendee
        fields = ('user', 'confirmation_code')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'id': instance.id,
            'uuid': instance.uuid,
            'user': UserSerializer(instance.user).data,
        }
        response.update(data)
        return response


class TestAttendeeRegisterSerializer(AbstractRegistrationSerializer):
    email = serializers.EmailField(required=False)
    phone_number = PhoneNumberField(max_length=20, required=True)

    def custom_signup(self, request, user):
        super().custom_signup(request, user)

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        # case where phone is not required we need to auto generate phone number unique and save
        cleaned_data.update({'email': self.validated_data.get('email', generate_dummy_email()),
                             'phone_number': self.validated_data.get('phone_number')})
        return cleaned_data

    def save(self, request):
        adapter = get_adapter()
        user = adapter.new_user(request)
        self.cleaned_data = self.get_cleaned_data()
        adapter.save_user(request, user, self)
        self.custom_signup(request, user)
        setup_user_email(request, user, [])
        return user
