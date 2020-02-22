from rest_framework.serializers import ModelSerializer

from items.models import ItemMaster
from items.serializers import (ItemCategorySerializer)


class ItemMasterSerializer(ModelSerializer):
    class Meta:
        model = ItemMaster
        exclude = ('id', 'uuid', 'item_mrp', 'created_at', 'deleted_at', 'updated_at', 'status')

    def to_representation(self, instance):
        response = super().to_representation(instance)
        data = {'uuid': instance.uuid, 'item_mrp': instance.item_mrp, 'created_at': instance.created_at,
                'status': instance.status,
                'category': ItemCategorySerializer(instance.category).data,
                'process': ItemCategorySerializer(instance.process).data,
                'service': ItemCategorySerializer(instance.service).data,
                'uom': ItemCategorySerializer(instance.uom).data,
                }
        response.update(data)
        return response
