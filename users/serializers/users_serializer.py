from django.contrib.auth import get_user_model
from rest_framework.serializers import ModelSerializer

from users.utils import check_if_email_is_dummy, check_if_phone_number_is_dummy

User = get_user_model()


#
# class AbstractBaseUserSerializer(ModelSerializer):
#     class Meta:
#         model = User
#         fields = ('first_name', 'last_name', 'email', 'phone_number', 'city', 'country')
#
#
# class AbstractUserSerializer(AbstractBaseUserSerializer):
#     class Meta:
#         model = User
#         fields = ('first_name', 'last_name', 'email', 'phone_number', 'phone_number', 'city', 'country')


class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = ('first_name', 'last_name', 'email', 'phone_number', 'phone_number', 'city', 'country')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {'uuid': instance.uuid, 'username': instance.username}
        response.update(data)
        return response


class UserSerializerWithNoDummyEmailAndPhone(ModelSerializer):
    class Meta:
        model = User
        fields = ('uuid', 'first_name', 'last_name', 'email', 'phone_number', 'country', 'city')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {
            'email': self.get_email_or_alternate_email(instance),
            'phone_number': self.get_phone_number_or_alternate_phone_number(instance)
        }
        response.update(data)
        return response

    def get_email_or_alternate_email(self, instance):
        event_attendee_queryset = instance.eventattendee_set.filter(event=self.context['event'])

        return instance.email if not check_if_email_is_dummy(
            instance.email) else event_attendee_queryset.first().alternate_email if event_attendee_queryset else ''

    def get_phone_number_or_alternate_phone_number(self, instance):
        event_attendee_queryset = instance.eventattendee_set.filter(
            event=self.context['event'])
        return instance.phone_number if not check_if_phone_number_is_dummy(
            instance.phone_number) else event_attendee_queryset.first().alternate_phone_number if event_attendee_queryset else ''
