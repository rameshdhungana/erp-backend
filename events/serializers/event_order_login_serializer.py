from rest_framework import serializers


class EventOrderLoginSerializer(serializers.Serializer):
    email = serializers.CharField(max_length=64, required=False)
    phone_number = serializers.CharField(max_length=64, required=False)
    confirmation_code = serializers.CharField(max_length=64)
