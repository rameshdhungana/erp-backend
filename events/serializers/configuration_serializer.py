from rest_framework.serializers import ModelSerializer

from events.models import Configuration


class ConfigurationSerializer(ModelSerializer):
    class Meta:
        model = Configuration
        fields = '__all__'
