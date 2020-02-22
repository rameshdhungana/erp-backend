from django.conf import settings
from django.contrib.auth.models import Group, Permission
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.generics import ListAPIView
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from users.serializers import (AuthPermissionSerializer,
                               GroupPermissionSerializer)

VALID_APP_LABEL_LIST = ['users', 'events', 'orders', 'coupons', 'carts', 'items']


class AuthPermissionListView(ListAPIView):
    serializer_class = AuthPermissionSerializer
    queryset = Permission.objects.filter(content_type__app_label__in=VALID_APP_LABEL_LIST)

    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'User List is fetched successfully',
                         'data': serializer.data}
        return Response(response_data, status=status.HTTP_200_OK)


class GroupViewSet(ModelViewSet):
    serializer_class = GroupPermissionSerializer
    queryset = Group.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'Group List is fetched successfully',
                         'data': serializer.data}
        return Response(response_data, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        response_data = {'code': getattr(settings, 'SUCCESS_CODE', 1),
                         'message': 'A new group  is created successfully',
                         'data': serializer.data}
        return Response(response_data, status=status.HTTP_200_OK, headers=headers)
