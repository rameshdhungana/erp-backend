from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from users.serializers import UserSerializer

User = get_user_model()


class UserViewSet(ModelViewSet):
    serializer_class = UserSerializer
    queryset = User.objects.all()
    lookup_field = 'uuid'

    def list(self, request, *args, **kwargs):
        response_data = super().list(request, *args, **kwargs)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'User List is fetched successfully',
                         'data': response_data.data}
        return Response(response_data, status=status.HTTP_200_OK)
