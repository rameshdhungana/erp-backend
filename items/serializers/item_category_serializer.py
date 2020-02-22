from rest_framework.serializers import ModelSerializer

from items.models import ItemCategory


class ItemCategorySerializer(ModelSerializer):
    class Meta:
        model = ItemCategory
        fields = ['name']

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {'uuid': instance.uuid}
        response.update(data)
        return response
