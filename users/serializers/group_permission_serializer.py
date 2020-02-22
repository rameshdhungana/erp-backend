from django.contrib.auth.models import ContentType, Group, Permission
from rest_framework import serializers
from rest_framework.serializers import ModelSerializer

VALID_APP_LABEL_LIST = ['users', 'events']


class ContentTypeSerializer(ModelSerializer):
    class Meta:
        model = ContentType
        fields = ['app_label', 'model']


class AuthPermissionSerializer(ModelSerializer):
    content_type = ContentTypeSerializer()

    class Meta:
        model = Permission
        fields = ['id', 'name', 'content_type', 'codename']


class GroupPermissionSerializer(ModelSerializer):
    permissions = serializers.PrimaryKeyRelatedField(
        queryset=Permission.objects.filter(content_type__app_label__in=VALID_APP_LABEL_LIST), many=True,
        write_only=True)

    class Meta:
        model = Group
        fields = ['name', 'permissions']

    def to_representation(self, instance):
        response = super().to_representation(instance)
        response['permissions'] = AuthPermissionSerializer(instance.permissions.all(), many=True).data
        return response
