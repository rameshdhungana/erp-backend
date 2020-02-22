import uuid

from allauth.account import app_settings as allauth_settings
from allauth.account.adapter import get_adapter
from allauth.account.utils import setup_user_email
from allauth.utils import email_address_exists
from django.conf import settings
from django.contrib.auth import get_user_model
from django.utils.translation import ugettext_lazy as _
from phonenumber_field.serializerfields import PhoneNumberField
from rest_framework import serializers

from users.utils import (generate_dummy_email, generate_dummy_phone_number,
                         generate_usercode)

User = get_user_model()

USER_EMAIL_IS_REQUIRED = getattr(settings, 'USER_EMAIL_IS_REQUIRED')
USER_PHONE_IS_REQUIRED = getattr(settings, 'USER_PHONE_IS_REQUIRED')
STAFF_EMAIL_IS_REQUIRED = getattr(settings, 'STAFF_EMAIL_IS_REQUIRED')
STAFF_PHONE_IS_REQUIRED = getattr(settings, 'STAFF_PHONE_IS_REQUIRED')

print(USER_EMAIL_IS_REQUIRED, USER_PHONE_IS_REQUIRED, STAFF_EMAIL_IS_REQUIRED, STAFF_PHONE_IS_REQUIRED)


class AbstractRegistrationSerializer(serializers.Serializer):
    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)
    first_name = serializers.CharField(max_length=30, required=True)
    last_name = serializers.CharField(max_length=150, required=True)
    city = serializers.CharField(max_length=255, required=False)
    gender = serializers.CharField(max_length=6, required=True)
    profile_picture = serializers.ImageField(required=False)

    # def validate_username(self, username):
    #     username = get_adapter().clean_username(username)
    #     return username

    def validate_email(self, email):
        email = get_adapter().clean_email(email)
        if allauth_settings.UNIQUE_EMAIL:
            if email and email_address_exists(email):
                raise serializers.ValidationError(
                    _("A users is already registered with this e-mail address."))
        return email

    def validate_password1(self, password):
        return get_adapter().clean_password(password)

    def validate(self, data):
        if data['password1'] != data['password2']:
            raise serializers.ValidationError(_("The two password fields didn't match."))
        return data

    def custom_signup(self, request, user):
        # in this custom singup form we add the extra fields other than in default signup form to
        # save into that users instance
        cleaned_data = self.get_cleaned_data()
        user.phone_number = cleaned_data['phone_number']
        user.gender = cleaned_data['gender']
        user.city = cleaned_data['city']
        user.profile_picture = cleaned_data['profile_picture']
        # users.groups.add(cleaned_data['groups'])
        user.save()

    def get_cleaned_data(self):
        return {
            'username': generate_usercode(),
            'password1': self.validated_data.get('password1'),
            'first_name': self.validated_data.get('first_name'),
            'last_name': self.validated_data.get('last_name'),
            'gender': self.validated_data.get('gender'),
            # 'groups': self.validated_data.get('groups', ''),
            'city': self.validated_data.get('city', ''),
            'profile_picture': self.validated_data.get('profile_picture', ''),
        }


class UserRegisterSerializer(AbstractRegistrationSerializer):
    email = serializers.EmailField(required=USER_EMAIL_IS_REQUIRED, allow_blank=not USER_EMAIL_IS_REQUIRED)
    phone_number = PhoneNumberField(max_length=20, required=USER_PHONE_IS_REQUIRED,
                                    allow_blank=not USER_PHONE_IS_REQUIRED)

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        # case where phone is not required we need to auto generate phone number unique and save
        cleaned_data.update({'email': self.validated_data.get('email', generate_dummy_email()),
                             'phone_number': self.validated_data.get('phone_number',
                                                                     generate_dummy_phone_number())})

        return cleaned_data

    def validate_phone_number(self, phone_number):
        if User.objects.filter(phone_number__exact=phone_number).exists():
            raise serializers.ValidationError('User with this phone number already exits!')

        return phone_number

    def save(self, request):
        self.cleaned_data = self.get_cleaned_data()
        adapter = get_adapter()
        user = adapter.new_user(request)
        adapter.save_user(request, user, self)
        self.custom_signup(request, user)
        setup_user_email(request, user, [])

        return user


class StaffRegisterSerializer(AbstractRegistrationSerializer):
    email = serializers.EmailField(required=STAFF_EMAIL_IS_REQUIRED, allow_blank=not STAFF_EMAIL_IS_REQUIRED)
    phone_number = PhoneNumberField(max_length=20, required=STAFF_PHONE_IS_REQUIRED,
                                    allow_blank=not STAFF_PHONE_IS_REQUIRED)

    def get_cleaned_data(self):
        cleaned_data = super().get_cleaned_data()
        # case where phone is not required we need to auto generate phone number unique and save
        cleaned_data.update({'email': self.validated_data.get('email', generate_dummy_email()),
                             'phone_number': self.validated_data.get('phone_number',
                                                                     generate_dummy_phone_number())})
        return cleaned_data

    def save(self, request):
        adapter = get_adapter()
        user = adapter.new_user(request)
        self.cleaned_data = self.get_cleaned_data()
        adapter.save_user(request, user, self)
        self.custom_signup(request, user)
        setup_user_email(request, user, [])
        return user
