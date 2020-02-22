import uuid
import secrets
import requests
from django.conf import settings


def generate_dummy_email():
    return '{}@dummy.com'.format(uuid.uuid4())


def generate_dummy_phone_number():
    return '{}@ph'.format(secrets.token_hex(16)[:12])


def generate_usercode():
    return '{}'.format(uuid.uuid4())


def check_if_email_is_dummy(email_address):
    index = email_address.find('dummy')
    #  if 'dummy' is found in email_address ,it is dummy email hence index is other than -1 (
    #  if not dummy email, index is other than -1
    return False if index == -1 else True


def check_if_phone_number_is_dummy(phone_number):
    index = phone_number.find('@ph')
    #  if 'dummy' is found in phone_number ,it is dummy email hence index is other than -1 (
    #  if not dummy email, index is other than -1
    return False if index == -1 else True


def remove_space_and_dash_from_phone_number(international_phone_number):
    #  dashes and spaces are replaced by '' and result is stripped
    return international_phone_number.replace('-', '').replace(' ', '').strip()


def login_user_and_return_token(request, event_attendee):
    url = '{}://{}/auth/login/'.format(request.scheme, request.META['HTTP_HOST'])

    data = {"username": event_attendee.user.username, "password": getattr(settings, 'DEFAULT_PASSWORD')}

    response_result = requests.post(url, json=data).json()
    if response_result.get('data', None):
        token = response_result['data']['key']
        return token
    # if response does not contain data in dict value , its unauthentic data hence no token is returned
    return None
