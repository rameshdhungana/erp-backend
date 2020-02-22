from django.conf import settings
from rest_auth.views import LoginView
from rest_framework import status
from rest_framework.response import Response


class UserLoginView(LoginView):

    def get_response(self):
        serializer_class = self.get_response_serializer()

        serializer = serializer_class(instance=self.token,
                                      context={'request': self.request})

        response = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                    'data': serializer.data,
                    'message': 'Login Successful'}

        return Response(response, status=status.HTTP_200_OK)
