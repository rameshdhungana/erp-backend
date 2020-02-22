from allauth.account import app_settings as allauth_settings
from django.conf import settings
from django.utils.translation import ugettext_lazy as _
from rest_auth.registration.views import RegisterView
from rest_framework import status
from rest_framework.response import Response

from users.serializers import StaffRegisterSerializer, UserRegisterSerializer


class UserRegisterView(RegisterView):
    serializer_class = UserRegisterSerializer


class StaffRegisterView(RegisterView):
    serializer_class = StaffRegisterSerializer
